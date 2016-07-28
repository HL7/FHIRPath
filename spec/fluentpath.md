FluentPath
==========
FluentPath is a path based navigation and extraction language, somewhat like XPath. Operations are expressed in terms of the logical content of hierarchical data models, and support traversal, selection and projection of data. Its design was influenced by the needs for path navigation, selection and formulation of invariants in both HL7 Fast Healthcare Interoperability Resources (FHIR) and HL7 Clinical Quality Language (CQL).

In both FHIR and CQL, this means that expressions can be written that deal with the contents of the resources and data types as described in the Logical views, or the UML diagrams, rather than against the physical representation of those resources. JSON and XML specific features are not visible to the FluentPath language (such as comments and the split representation of primitives).

The expressions can in theory be converted to equivalent expressions in XPath, OCL, or another similarly expressive language.

1. Navigation model
---------------------
FluentPath navigates and selects nodes from a tree that abstracts away and is independent of the actual underlying implementation of the source against which the FluentPath query is run. This way, FluentPath can be used on in-memory Java POJOs, Xml data or any other physical representation, so long as that representation can be viewed as classes that have properties. In somewhat more formal terms, FluentPath operates on a directed acyclic graph of classes as defined by a MOF-equivalent type system.

Data is represented as a tree of labelled nodes, where each node may optionally carry a primitive value and have child nodes. Nodes need not have a unique label, and leaf nodes must carry a primitive value. For example, a (partial) representation of a FHIR Patient resource in this model looks like this:

![Tree representation of a Patient](treestructure.png)

The diagram shows a tree with a repeating `name` node, which represents repeating members of the FHIR object model. Leaf nodes such as `use` and `family` carry a (string) value. It is also possible for internal nodes to carry a value, as is the case for the node labelled `active`: this allows the tree to represent FHIR "primitives", which may still have child extension data.

2. Path selection
-----------------
FluentPath allows navigation through the tree by composing a path of concatenated labels, e.g.

	name.given

This would result in a set of nodes, one with the value "Wouter" and one with the value "Gert". In fact, each step in such a path results in a collection of nodes by selecting nodes with the given label from the step before it. The focus at the beginning of the evaluation contained all elements from Patient, and the path `name` selected just those named `name`. Since the `name` element repeats, the next step `given` along the path, will contain all nodes labeled `given` from all nodes `name` in the preceding step. 

The path may start with the type of the root node (which otherwise does not have a name), but this is optional. To illustrate this point, the path `name.given` above can be evaluated as an expression on a set of data of any type. However the expression may be prefixed with the name of the type of the root:

	Patient.name.given
  
The two expressions have the same outcome, but when evaluating the second, the evaluation will only produce results when used on data of type `Patient`.

Syntactically, FluentPath defines identifiers as any sequence of characters consisting only of letters, digits, and underscores, beginning with a letter or underscore. Paths may use double quotes to include characters in path parts that would otherwise be interpreted as operators, e.g.:

	Message."PID-1"

### 3.1 Paths and polymorphic items
In the underlying representation of data, nodes may be typed and represent polymorphic items. Paths may either ignore the type of a node, and continue along the path or may be explicit about the expected node and filter the set of nodes by type before navigating down child nodes: 

	Observation.value.unit - all kinds of value	
	Observation.value.as(Quantity).unit - only values that are of type Quantity

The `is` function can be used to determine whether or not a given value is of a given type:

    Observation.value.is(Quantity) - returns true if the value is of type Quantity

The list of available types that can be passed as a parameter to the `as` and `is` functions is determined by the underlying data model.

### 3.2 Referring to the current item
It is sometimes useful to refer to the current item under evaluation when writing an expression, especially within operations like `where()` when the value of the current item needs to be passed as a function parameter. This can be done using the special path `$this`:

	Patient.name.given.where(substring($this.length()-3)) = "out"

### 3.3 Order nodes and traversal
Collections of nodes are inherently ordered, and implementations must retain the original order of a collection. There are two special cases: the outcome of operations like `children()` and `descendants()` cannot be assumed to be in any meaningful order, and `first()`, `last()`, `tail()`, `skip()` and `take()` should not be used on collections derived from these paths. Note that some implementations may follow the standard order, and some may not, and some may be different depending on the underlying source.

4. Expressions
--------------

### Literals
In addition to paths, FluentPath expressions may contain _literals_ and _function invocations_. FluentPath supports the following types of literals:

	boolean: true, false
	string: 'test string', 'urn:oid:3.4.5.6.7.8'
	integer: 0, 45
	decimal: 0.0, 3.141592653587793236
	datetime: @2015-02-04T14:34:28Z (`@` followed by ISO8601 compliant date/time)
	time: @T14:34:28+09:00 (`@` followed by ISO8601 compliant time beginning with `T`)

#### string
Unicode is supported in both string literals and quoted identifiers. String literals are surrounded by single quotes and may use `\`-escapes to escape quotes and represent Unicode characters:
 
* Unicode characters may be escaped using `\u` followed by four hex digits.
* Additional escapes are those supported in JSON:
	* `\\` (backslash),
	* `\/` (slash), 
	* `\f` (form feed - \u000c),
	* `\n` (newline - \u000a), 
	* `\r` (carriage return - \u000d), 
	* `\t` (tab - \u0009)
	* `\"` (double quote)
	* `\'` (single quote)   

#### decimal
Decimals cannot use exponential notation.

#### datetime

`datetime` uses a subset of ISO8601:

* It used the YYYY-MM-DD format, though month and days may be left out
* Week dates and ordinal dates are not allowed
* Years must be present (--MM-DD is not used)
* Months must be present if a day is present
* The date may be followed by a `time` as described in the next section.
* Consult the formal grammar for more details.   

#### time

`time` uses a subset of ISO8601:

* A time begins with a `T`
* Timezone is optional, but if present the notation "±hh:mm" is used (so must include both minutes and hours)
* `Z` is allowed for the zero UTC offset.
 
Consult the formal grammar for more details.   

### Operators
Expressions can also contain _operators_, like those for mathematical operations and boolean logic:

	Appointment.minutesDuration / 60 > 5
	MedicationAdministration.wasNotGiven.exists() implies MedicationAdministration.reasonNotGiven.exists()
	name.given | name.family
	'sir ' + name.given

### Functions	
Finally, FluentPath supports the notion of functions, which all take a collection of values as input and produce another collection as output. For example:

	(name.given | name.family).distinct()
	identifier.where(use = 'official')

Since all functions work on collections, constants will first be converted to a collection when functions are invoked on constants:

	(4+5).count()

will return `1`, since this is implicitly a collection with one constant number `9`.

### Null and empty 
There is no concept of `null` in FluentPath. This means that when, in an underlying datamodel a member is null or missing, there will simply be no corresponding node for that member in the tree, e.g. `Patient.name` will return an empty collection (not null) if there are no name elements in the instance.

In expressions, the empty collection is represented as `{}`.

### 4.1 Boolean evaluation of collections
Collections can be evaluated as booleans in logical tests in criteria. When a collection is implicitly converted to a boolean then:

* IF the collection contains a single node AND the node's value is a boolean THEN
  - the collection evaluates to the value of that single boolean node
* ELSE IF the collection is empty THEN
  - the collection evaluates to an empty collection
* ELSE 
  - the collection evaluates to `true`

This same principle applies when using the path statement in invariants.

> Note: Because the path language is side effect free, it does not matter whether implementations use short circuit boolean evaluation or not. However with regard to performance, implementations are encouraged to use short circuit evaluation, and authors of path statements should pay attention to short circuit evaluation when designing statements for optimal performance.

### 4.2 Propagation of empty results
FluentPath functions and operators both propagate empty results. This means in general that if any input to a function or operator is empty, then the result will be empty as well. More specifically:
* If a function operates on an empty collection, the result is an empty collection
* If a function is passed an empty collection as argument, the result is an empty collection
* If any operand to an operator is an empty collection, the result is an empty collection.

When functions behave differently (for example the `count()` and `empty()` functions), this is clearly documented in the next sections.

5. Functions
-------------------------
Functions are distinguished from path navigation names by the fact that they are followed by a `()` with zero or more parameters. Functions always take a collection as input and produce another collection as output, even though these may be collections of just a single item. Correspondingly, arguments to the functions can be any FluentPath expression, though some functions require these expressions to evaluate to a collection containing a single item of a specific type.

The following list contains all functions supported in FluentPath, detailing the expected kind of parameters and kind of collection returned by the function:

* If the function expects a parameter to be a single value (e.g. `item(index: integer)` and it is passed an argument that evaluates to a collection with multiple items or a collection with an item that is not of the required type, the evaluation of the expression will end and an error will be signaled to the calling environment.
* If the function takes an `expression` as a parameter, the function will evaluate this parameter with respect to each of the items in the input collection. These expressions may refer to the special `$this` element, which represents the item from the input collection currently under evaluation. For example, in:

	```
 	name.given.where($this > 'ba' and $this < 'bc')
	```

	the `where()` function will iterate over each item in the input collection (elements named `given`) and `$this` will be set to each item when the expression passed to `where()` is evaluated.
* Optional parameters are enclosed in square brackets in the definition of a function.
* All functions return a collection, but if this is a single item of a predefined type, the description of the function will specify its output type explicitly, instead of just stating `collection`, e.g. `all(...) : boolean`

### 5.1 Existence
#### empty() : boolean
Returns `true` if the input collection is empty (`{ }`) and `false` otherwise.

#### not() : boolean 
Returns `true` if the input collection evaluates to `false`, and `false` if it evaluates to `true`. Otherwise, the result is empty (`{ }`):

| &nbsp; | not |
| --- | --- |
| `true` | `false` |
| `false` | `true` |
| empty (`{ }`) | empty (`{ }`) |

#### exists() : boolean
Returns the opposite of `empty()`, and as such is a shorthand for `empty().not()`

#### all() : boolean
Returns `true` if every element in the input collection evaluates to `true`, and `false` if any element evaluates to `false`. Otherwise, the result is empty (`{ }`).

#### subsetOf(other : collection) :  boolean
Returns `true` if all items in the input collection are members of the collection passed as the `other` argument. Membership is determined using the equals (`=`) operation (see below).

#### supersetOf(other : collection) : boolean
Returns `true` if all items in the collection passed as the `other` argument are members of the input collection. Membership is determined using the equals (`=`) operation (see below).

#### isDistinct() : boolean
Returns `true` if all the items in the input collection are distinct. To determine whether two items are distinct, the equals (`=`) operator is used, as defined below.

#### distinct() : collection
Returns a collection containing only the unique items in the input collection. To determine whether two items are the same, the equals (`=`) operator is used, as defined below.

#### count() : integer
Returns a collection with a single value which is the integer count of the number of items in the input collection. Returns 0 when the input collection is empty.

### 5.2 Filtering and projection

#### where(criteria : expression) : collection
Filter the input collection to only those elements for which the stated criteria expression evaluates to true.

#### select(projection: expression) : collection
Evaluates the given expression for each item in the input collection. The result of each evaluation is added to the output collection. If the evaluation results in a collection with multiple items, all items are added to the output collection (collections resulting from evaluation of `projection` are _flattened_).

#### repeat(projection: expression) : collection
A version of `select` that will repeat the projection and add it to the output collection, as long as the projection yields new items (as determined by the Equals operator). 

This operation can be used to traverse a tree and selecting only specific children:

	ValueSet.expansion.repeat(contains)

Will repeat finding children called `contains`, until no new nodes are found.

	Questionnaire.repeat(group | question).question

Will repeat finding children called `group` or `question`, until no new nodes are found.

Note that this is slightly different from

	Questionnaire.descendants().select(group | question)

which would find **any** descendants called `group` or `question`, not just the ones nested inside other `group` or `question` elements.

#### is(type : identifier) : boolean
Returns `true` if the collection contains a single element of the given type or a subclass thereof.

#### as(type : identifier) : collection
Returns a collection that contains all items in the input collection that are of the given type or a subclass thereof.

### 5.3 Subsetting
#### _name_[ index : integer ] : collection
This indexer operation returns a collection with only the `index`-th item (0-based index). If the index lies outside the boundaries of the input collection, an empty collection is returned.

Example:

	Patient.name[0]

#### single() : collection
Will return the single item in the input if there is just one item. If there are multiple items, an error is signaled to the evaluation environment.

#### first() : collection
Returns a collection containing just the first item in the list. Equivalent to `item(0)`, so it will return an empty collection if the input collection has no items.

#### last() : collection
Returns a collection containing the last item in the list. Will return an empty collection if the input collection has no items.

#### tail() : collection
Returns a collection containing all but the first item in the list. Will return an empty collection if the input collection has no or just one item.

#### skip(num : integer) : collection
Returns a collection containing all but the first `num` items in the list. Will return an empty collection if there are no items remaining after the indicated number of items have been skipped.

#### take(num : integer) : collection
Returns a collection containing the first `num` items in the list, or less if there are less then `num` items. Will return an empty collection if the input collection is empty.

### 5.5 Conversion
The functions in this section operate on collections with a single item. If there is more than one item, or an incompatible item, the evaluation of the expression will end and signal an error to the calling environment.

To use these functions over a collection with multiple items, one may use filters like `where()` and `select()`:

	Patient.name.given.select(substring(1))

#### iif(criterium: boolean, true: collection [, otherwise: collection]) : collection
If `criterium` is true, the function evaluates the `true-expression` on the input and returns that as a result. 

If `criterium` is `false` or an empty collection, the `otherwise-expression` is evaluated on the input and returned, unless the optional `otherwise-expression` is not given, in which case the function returns an empty collection.

#### toInteger() : integer
If the input collection contains a single item, this function will return a single integer if:

* the item in the input collection is an integer
* the item in the input collection is a string and is convertible to an integer
* the item is a boolean, where `true` results in a 1 and `false` results in a 0.

In all other cases, the function will return an empty collection.

#### toDecimal() : decimal
If the input collection contains a single item, this function will return a single decimal if:

* the item in the input collection is a decimal
* the item in the input collection is a string and is convertible to a decimal
* the item is a boolean, where `true` results in a 1 and `false` results in a 0.

In all other cases, the function will return an empty collection.

#### toString() : string
If the input collection contains a single item, this function will return a single string if:

* the item in the input collection is a string
* the item in the input collection is an integer, decimal, time or dateTime the output will contain its string representation
* the item is a boolean, where `true` results in "true" and `false` in "false".

In all other cases, the function will return an empty collection.

### 5.6 String manipulation
The functions in this section operate on collections with a single item. If there is more than one item, or an item that is not a string, the evaluation of the expression will end and signal an error to the calling environment.

#### indexOf(substring : string) : integer
If the input collection contains a single item of type string, will return the 0-based index of the first position this substring is found in the input string, or -1 if it is not found. If the `substring` is an empty string, the function returns 0. 

#### substring(start : integer [, length : integer]) : string
If the input collection contains a single item of type string, it returns a collection with the part of the string starting at position `start` (zero-based). If `length` is given, will return at most `length` number of characters from the input string.

If `start` lies outside the length of the string, the function returns an empty collection. If there are less remaining characters in the string than indicated by `length`, the function returns just the remaining characters.

#### startsWith(prefix : string) : boolean
If the input collection contains a single item of type string, the function will return `true` when the input string starts with the given `prefix`. Also returns `true` when `prefix` is the empty string. 

#### endsWith(suffix : string) : boolean
If the input collection contains a single item of type string, the function will return `true` when the input string ends with the given `suffix`. Also returns `true` when `suffix` is the empty string. 

#### contains(substring : string) : boolean
If the input collection contains a single item of type string, the function will return `true` when the given `substring` is a substring of the input string. Also returns `true` when `substring` is the empty string.

#### replace(pattern : string, substitution : string) : string
If the input collection contains a single item of type string, the function will return the input string with all instances of `pattern` replaced with `substitution`. If the substitution is the empty string, the instances of the pattern are removed from the input string. If the pattern is the empty string, every character in the input string is surrounded by the substitution, e.g. `'abc'.replace('','x')` becomes `'xaxbxcx'`.

#### matches(regex : string) : boolean
If the input collection contains a single item of type string, the function will return `true` when the  value matches the given regular expression. Regular expressions are supposed to work culture invariant, case-sensitive and in 'single line' mode and allow Unicode characters. 

#### replaceMatches(regex : string, substitution: string) : string
If the input collection contains a single item of type string, the function will match the input using the regular expression in `regex` and replace each match with the `substitution` string. The substitution may refer to identified match groups in the regular expression. 

This example of `replace()` will convert a string with a date formatted as MM/dd/yy to dd-MM-yy:

	'11/30/1972'.replace('\\b(?<month>\\d{1,2})/(?<day>\\d{1,2})/(?<year>\\d{2,4})\\b',
           '${day}-${month}-${year}')

> Note: All platforms will use their native regular expression implementations, which will commonly be close to the regular expressions in Perl 5, however there are always small differences. I don't think we can prescribe any "common" dialect for FluentPath.

#### length() : integer
If the input collection contains a single item of type string, the function will return the length of the string.

### 5.6 Tree navigation

#### children() : collection
Returns a collection with all immediate child nodes of all items in the input collection.

#### descendants() : collection
Returns a collection with all descendant nodes of all items in the input collection. The result does not include the nodes in the input collection themselves. Is a shorthand for `repeat(children())`.

> Note: Many of these functions will result in a set of nodes of different underlying types. It may be necessary to use `as()` as described in the previous section to maintain type safety. See section 8 for more information about type safe use of FluentPath expressions.

### 5.7 Utility functions

#### memberOf(valueset : string) : boolean
If the input collection contains a single string item, it is taken to be a code and valueset membership is tested against the valueset passed as the argument. The `valueset` argument is a uri used to resolve to a valueset.  

#### trace(name : string) : collection
Add a string representation of the input collection to the diagnostic log, using the parameter `name` as the name in the log. This log should be made available to the user in some appropriate fashion. Does not change the input, so returns the input collection as output.

#### today() : datetime
Returns a datetime containing the current date.

#### now() : datetime
Returns a datetime containing the current date and time, including timezone.

6. Operations
-------------
Operators are allowed to be used between any kind of path expressions (e.g. expr op expr). Like functions, operators will generally propagate an empty collection in any of their operands. This is true even when comparing two empty collections using the equality operators, e.g.

	{} = {} 
	true > {}
	{} != 'dummy'

all result in `{}`.

### 6.1 Equality

#### = (Equals)
Returns `true` if the left collection is equal to the right collection:

If both operands are collections with a single item:
* For primitives:
		* `string`: comparison is based on Unicode values
		* `integer`: values must be exactly equal
	    * `decimal`: values must be equal, trailing zeroes are ignored 
		* `boolean`: values must be the same
		* `dateTime`: must be exactly the same, including timezone (though +24:00 = +00:00 = Z)
		* `time`: must be exactly the same, including timezone (though +24:00 = +00:00 = Z)
		* If a `time` or `dateTime` has no indication of timezone, the timezone of the evaluating machine is assumed.
* For complex types, equality requires all child properties to be equal, recursively.

If both operands are collections with at least one item:
* Each item must be equal
* Comparison is order dependent

Otherwise, equals returns `false`. 

Note that this implies that if both collections have a different number of items to compare, the result will be `false`. 

Typically, this operator is used with single fixed values as operands. This means that `Patient.telecom.system = 'phone'` will return `false` if there is more than one `telecom` with a `use`. Typically, you'd want Patient.telecom.where(system = 'phone')

If one or both of the operands is the empty collection, this operation returns an empty collection.

Note: in FHIR, comparing a primitive with extensions against a primitive will compare  
#### ~ (Equivalent)
Returns `true` if the collections are the same.

If both operands are collections with a single item:
* For primitives
	* `string`: the strings must be the same while ignoring case, accents, and nonspacing combing characters (i.e. German ß and 'ss').
	* `integer`: exactly equal
	* `decimal`: values must be equal, comparison is done on values rounded to the precision of the least precise operand. Trailing zeroes are ignored in determining precision.
	* `dateTime`: only the date part must be exactly equal. If one operand
has less precision than the other, comparison is done at the lowest precision.
	* `time`: comparison disregards seconds and microseconds, though timezone is still relevant (see equals). If one operand
has less precision than the other, comparison is done at the lowest precision.
	* `boolean`: the values must be the same
* For complex types, equivalence requires all child properties to be equivalent, recursively.

If both operands are collections with multiple items:
* Each item must be equivalent
* Comparison is not order dependent

Note that this implies that if both collections have a different number of items to compare, the result will be `false`. 

If one or both of the operands is the empty collection, this operation returns an empty collection.

####  != (Not Equals)
The inverse of the equals operator.

#### !~ (Not Equivalent)
The inverse of the equivalent operator.

### 6.2 Comparison
* The comparison operators are defined for strings, integers, decimals, datetimes and times.
* If one or both of the arguments is an empty collection, a comparison operator will return an empty collection.
* Unless there is only one item in each collection (left and right), the comparisons return false
* Both arguments must be of the same type, and the evaluator will throw an error if the types differ.
* When comparing integers and decimals, the integer will be converted to a decimal to make comparison possible. 
* String ordering is strictly lexical and is based on the Unicode value of the individual characters.

#### \> (Greater Than)
     
#### < (Less Than)

#### <= (Less or Equal)

#### \>= (Greater or Equal)

### 6.3 Types

#### is
If the left operand is a collection with a single item and the second operand is an identifier, this operator returns `true` if the type of the left operand is the type specified in the second operand, or a subclass thereof. In all other cases this function returns the empty collection.

	Patient.contained.all($this is Patient implies age > 10)

#### as
If the left operand is a collection with a single item and the second operand is an identifier, this function returns the value of the left operand, or a subclass thereof. Otherwise, this operator returns the empty collection.

### 6.4 Collections

#### | (union collections)
Merge the two collections into a single collection, eliminating any duplicate values (using equals (`=`)) to determine equality).

#### in (membership)
If the left operand is a collection with a single item, this operator returns true if the item is in the right operand using equality semantics. This is the inverse operation of contains.

#### contains (containership)
If the right operand is a collection with a single item, this operator returns true if the item is in the left operand using equality semantics. This is the inverse operation of in.

### 6.5 Boolean logic

For all boolean operators, the collections passed as operands are first evaluated as booleans (as described in 4.1). The operators then use three-valued logic to propagate empty operands.

#### and     
Returns `true` if both operands evaluate to `true`, `false` if either operand evaluates to `false`, and empty collection (`{ }`) otherwise:

|&nbsp;|`true`|`false`|empty (`{ }`)|
|-----|----|-----|-----|
|`true` |`true`|`false`|empty (`{ }`)|
|`false`|`false`|`false`|`false`|
|empty (`{ }`)|empty (`{ }`)|`false`|empty (`{ }`)|

#### or
Returns `false` if both operands evaluate to `false`, `true` if either operand evaluates to `true`, and empty (`{ }`) otherwise:

|&nbsp;|`true`|`false`|empty (`{ }`)|
|-----|----|-----|-----|
|`true` |`true`|`true`|`true`|
|`false`|`true`|`false`|empty (`{ }`)|
|empty (`{ }`)|`true`|empty (`{ }`)|empty (`{ }`)|

#### xor
Returns `true` if exactly one of the operands evaluates to `true`, `false` if either both operands evaluate to `true` or both operands evaluate to `false`, and the empty collection (`{ }`) otherwise:

|&nbsp;|`true`|`false`|empty (`{ }`)|
|-----|----|-----|-----|
|`true` |`false`|`true`|empty (`{ }`)|
|`false`|`true`|`false`|empty (`{ }`)|
|empty (`{ }`)|empty (`{ }`)|empty (`{ }`)|empty (`{ }`)|

#### implies
If the left operand evaluates to `true`, this operator returns the boolean evaluation of the right operand. If the left operand evaluates to `false`, this operator returns `true`. Otherwise, this operator returns `true` if the right operand evaluates to `true`, and the empty collection (`{ }`) otherwise.

|&nbsp;|`true`|`false`|empty (`{ }`)|
|-----|----|-----|-----|
|`true` |`true`|`false`|empty (`{ }`)|
|`false`|`true`|`true`|`true`|
|empty (`{ }`)|`true`|empty (`{ }`)|empty (`{ }`)|

### 6.6 Math
The math operators require each operand to be a single element. Both operands must be of the same type, each operator below specifies which types are supported.

If there is more than one item, or an incompatible item, the evaluation of the expression will end and signal an error to the calling environment.

As with the other operators, the math operators will return an empty collection if one or both of the operands are empty. 

#### * (multiplication)
Multiplies both arguments (numbers only)

#### / (division)
Divides the left operand by the right operand (numbers only). 

#### + (addition)
For integer and decimal, add the operands. For strings, concatenates the right operand to the left operand.

#### - (subtraction)
Subtracts the right operand from the left operand (numbers only).

#### div
Performs truncated division of the left operand by the right operand (numbers only).

#### mod
Computes the remainder of the truncated division of its arguments (numbers only).

#### & (string concatenation)
For strings, will concatenate the strings, where an empty operand is taken to be the empty string. This differs from `+` on two strings, which will result in an empty collection when one of the operans is empty. 

### 6.5 Operator precedence
 
Precedence of operations, in order from high to low:

    #01 . (path/function invocation)
	#02 [] (indexer)
	#03 unary + and -
    #04: *, /, div, mod
    #05: +, -,
	#06: |
    #07: >, <, >=, <=
	#08: is, as
	#09: =, ~, !=, !~
	#10: in, contains
    #11: and 
	#12: xor, or
	#13: implies

As customary, expressions may be grouped by parenthesis (`()`).
  
7. Environment variables
-------------------

A token introduced by a % refers to a value that is passed into the evaluation engine by the calling environment. Using environment variables, authors can avoid repetition of fixed values and can pass in external values and data.

The following environmental values are set for all contexts:

```
%sct        - (string) url for snomed ct
%loinc      - (string) url for loinc
%ucum       - (string) url for ucum
%"vs-[name]" - (string) full url for the provided HL7 value set with id [name]
%"ext-[name]" - (string) full url for the provided HL7 extension with id [name]
%context	- The original node that was passed to the evaluation engine before starting evaluation

Note how the names of the `vs-` and `ext-` constants are escaped (just like paths) to allow "-" in the name. 
```

Implementers should note that using additional environment variables is a formal extension point for the language. Implementation Guides are allowed to define their own externals, and implementers should provide some appropriate configuration framework to allow these constants to be provided to the evaluation engine at run time. E.g.:

	%us-zip = '[0-9]{5}(-[0-9]{4}){0,1}'

Authors of Implementation Guides should be aware that adding specific environment variables restricts the use of the FluentPath to their particular context. 

Note that these tokens are not restricted to simple types, and they may not have defined fixed values that are known before evaluation at run-time, though there is no way to define these kind of values in implementation guides.

8. Type safety and strict evaluation
------------------------------
Strongly typed languages are intended to help authors avoid mistakes by ensuring that expressions written describe valid operations. For example, a strongly typed language would typically disallow the expression:

    1 + 'John'

because it performs an invalid operation, namely adding numbers and strings. However, there are cases where the author knows that a particular invocation may be safe, but the compiler is not aware of, or cannot infer, the reason. In these cases, type-safety errors can become an unwelcome burden, especially for experienced developers.

As a result, FluentPath defines a _strict_ option that allows an execution environment to determine how much type safety should be applied. With _strict_ enabled, FluentPath behaves as a traditional strongly-typed language, whereas without _strict_, it behaves as a traditional dynamically-typed language.

For example, since some functions and most operators will only accept a single item as input, and throw an exception otherwise:

	Patient.name.given + ' ' + Patient.name.family

will work perfectly fine, as long as the patient has a single name, but will fail otherwise. It is in fact "safer" to formulate such statements as either:

	Patient.name.select(given + ' ' + family)

which would return a collection of concatenated first and last names, one for each name of a patient. Of course, if the patient turns out to have multiple given names, even this statement will fail and the author would need to choose the first name in each collection explicitly:

	Patient.name.first().select(given.first() + ' ' + family.first())

It is clear that, although more robust, the last expression is also much more elaborate, certainly in situations where, because of external constraints, the author is sure names will not repeat, even if the unconstrained data model allows repetition.

Apart from throwing exceptions, unexpected outcomes may result because of the way the equality operators are defined. The expression

	Patient.name.given = 'Wouter'

will return false as soon as a patient has multiple names, even though one of those may well be 'Wouter'. Again, this can be corrected:

	Patient.name.where(given = 'Wouter').exists()

but is still less concise than would be possible if constraints were well known in advance.
  
The strict option provides a mode in which the author of the FluentPath statement is protected against such cases by employing strict typing. Based on the definition of the operators and functions and given the type of input, a compiler can trace the statement and determine whether "unsafe" situations can occur.

Unsafe uses are:
* A function that requires an input collection with a single item is called on an output that is not guaranteed to have only one item.
* A function is passed an argument that is not guaranteed to be a single value.
* A function is passed an input value or argument that is not of the expected type
* An operator that requires operands to be collections with a single item is called with arguments that are not guaranteed to have only one item.
* An operator has operands that are not of the expected type
* Equality operators are used on operands that are not both collections or collections of single items.

There are a few constructs in the FluentPath language where the compiler cannot trace the type, and should issue a warning to the user when doing "strict" evaluation:
* The `children()` and `descendants()` functions
* The `resolve()` function
* A member which is polymorphic (e.g. a choice[x] type in FHIR)

Authors can use the `as()` function directly after such constructs to inform the compiler of the expected type, so that strict type-checking can continue.

In strict mode, when the compiler finds places where a collection of multiple items can be present while just a single item is expected, the author will need to make explicit how repetitions are dealt with. Depending on the situation one may:

* Use `first()`, `last()` or indexer (`[ ]`) to select a single item
* Use `select()` and `where()` to turn the expression into one that evaluates each of the repeating items individually (as in the examples above)
* Use `single()` to return either the single item or else an empty collection. This is especially useful when using FluentPath to formulate invariants: in cases where single items are considered the "positive" or "true" situation, `single()` will return an empty collection, so the invariant will evaluate to the empty collection (or false) in any other circumstance.

```
[27-1-2016 20:53:40] Grahame Grieve: I still disagree with the way that the strict evaluation 
section is framed. The issue should be described, and then possible approaches defined, 
including type level evaluation for warnings. I'm not sure when a strict mode on evaluation would actually be appropriate or 
whether strict must be applied purely based on the type definitions, or whether an evaluation 
engine is allowed to be aware of contextual constraints in addition to the type definitions
```

> as() will not be useable if the parent, children or descendants contain backbone elements (which they will). This might not be a big problem, e.g.

>    	Questionnaire.descendants().question

>will really always just select the "anonymous" child called "question" and thus the Question complex element, but we will not get any typesafety again until we do

>   	Questionnaire.descendants().question.concept.as('Coding').etc


# Appendix A - Use of FluentPath in HL7 FHIR

FluentPath is used in five places in the FHIR specifications:
- search parameter paths - used to define what contents the parameter refers to 
- slicing discriminator - used to indicate what element(s) define uniqueness
- invariants in ElementDefinition, used to apply co-occurrence and other rules to the contents 
- error message locations in OperationOutcome
- URL templates in Smart on FHIR's cds-hooks
- may be used for Patch in the future

As stated in the introduction, FluentPath uses a tree model that abstracts away the actual underlying datamodel of the data being queried. For FHIR, this means that the contents of the resources and data types as described in the Logical views (or the UML diagrams) are used as the model, rather than the JSON and XML formats, so specific xml or json features are not visible to the FluentPath language (such as comments and the split representation of primitives).

More specifically:
* A FluentPath may optionally start with a full resource name
* Elements of datatypes and resources are used as the name of the nodes which can be navigated over, except for choice elements (ending with '[x]'), see below.
* The `contained` element node does not have the name of the Resource as its first and only child (instead it directly contains the contained resource's children)
* There is no difference between an attribute and an element
* Repeating elements turn into multiple nodes with the same name

### A.1 Polymorphism in FHIR
FHIR has the notion of choice elements, where elements can be one of multiple types, e.g. `Patient.deceased[x]`. In actual instances these will be present as either `Patient.deceasedBoolean` or `Patient.deceasedDateTime`. In FluentPath choice elements are labeled according to the name without the '[x]' suffix, and children can be explicitly filtered using the `as` operation:

	Observation.value.as(Quantity).unit

### A.2 Using FHIR types in expressions 
The evaluation engine will automatically convert the value of FHIR types representing primitives to FluentPath types when they are used in expression in the following fashion:

|FHIR primitive type|FluentPath type|
|----|----|
|boolean|boolean| 
|string, uri, code, oid, id, uuid, sid, markdown, base64Binary|string|
|integer, unsignedInt, positiveInt|integer|
|decimal|decimal|
|date, dateTime, instant|datetime|
|time|time|

Note that FHIR primitives may contain extensions, so that the following expressions are *not* mutually exclusive:

	Patient.name.given = 'Ewout'			// value of Patient.name.given as a string
	Patient.name.given.extension.first().value = true	// extension of the primitive value

### A.3 Additional functions

FHIR adds (backwards compatible) functionality to the common set of functions:

#### extension(url : string) : collection
Will filter the focus for items named "extension" with the given url. This is a syntactical shortcut for `.extension.where(url = string)`, but is simpler to write. Will return an empty collection if the focus is empty or the url is empty.

#### trace(name : string) : collection
When FluentPath statements are used in an invariant, the log contents should be added to the 
error message constructed when the invariant is violated. For example:

	"SHALL have a local reference if the resource is provided inline (url: height; ids: length,weight)" 

	from 

	"reference.startsWith('#').not() 
		or ($context.reference.substring(1).output('url') in $resource.contained.id.output('ids'))"

#### resolve() : collection
For each item in the collection, if it is a string, locate the target of the reference, and add it to the resulting collection. If the item is not a string, the item is ignored and nothing is added to the output collection.

The items in the collection may also represent a Reference, in which case the `Reference.reference` is resolved.

If fetching the resource fails, the failure message is added to the output collection.

#### as(type : identifier) : collection
In FHIR, only concrete core types are allowed as an argument. All primitives are considered to be independent types (so `markdown` is **not** a subclass of `string`). Profiled types are not allowed, so to select `SimpleQuantity` one would pass `Quantity` as an argument.

### A.4 Changes to operators
#### ~ (Equivalence)
Equivalence works in exactly the same manner, but with the addition that for complex types, equality requires all child properties to be equal, **except for "id" elements**.

### A.5 Environment variables
The FHIR specification specified one additional variable:

```
%resource	- The original resource current context is part of.
 			  When evaluating a datatype, this would be the resource the element is part of. Do not go past a root resource into a bundle, if it is contained in a bundle
```

# Appendix B - Use of FluentPath in Clinical Quality Language (CQL)

Clinical Quality Language is being extended to use FluentPath as its core expression language, in much the same way that XQuery uses XPath to represent expressions within queries. In particular, the following extensions to CQL are proposed:

### Path Traversal
When a path expression involves an element with multiple cardinality, the expression is considered short-hand for an equivalent query invocation. For example:

    Patient.name

is allowed, and is considered a short-hand for the following query expression:

    Patient.name X where X.name is not null return X.name

Note that the restriction is required as it ensures that the resulting list will not contain any null elements.

### Constants and Contexts
FluentPath has the ability to reference contexts (using the `$` prefix) and environment-defined variables (using the `%` prefix). Within CQL, these contexts and environment-defined variables are added to the appropriate scope (global for environment-variables, local for contexts) with the prefix included. This allows them to be referenced like any other variable within CQL, but preserves the prefix as a namespace differentiator.

### Additional Operators
The following additional operators are being added to CQL:
* `~`, `!~` - Equivalent operators (formerly `matches` in CQL)
* `!=` - As a synonym for `<>`
* `implies` - Logical implication
* `|` - As a synonym for `union`

### Method-style Invocation
One of the primary syntactic features of FluentPath is the ability to "invoke" a function on a collection. For example:

    Patient.name.given.substring(3)

The CQL syntax is being extended to support this style of invocation, but as a short-hand for an equivalent CQL statement for each operator. For example:

    stringValue.substring(3, 5)

is allowed, and is considered a short-hand for the following CQL expression:

    Substring(stringValue, 3, 5)

For most functions, this short-hand is a simple rewrite, but for contextual functions such as `where()` and `select()`, this rewrite must preserve the context semantics:

    Patient.name.where(given = 'John')

is short-hand for:

    Patient.name N where N.given = 'John'

### Strict Evaluation
Because CQL is a type-safe language, embedded FluentPath expressions should be compiled in _strict_ mode. However, to enable the use of FluentPath in _loose_ mode, an implicit conversion from a list of elements to an element is added. This implicit conversion is implemented as an invocation of `singleton from`, ensuring that if the list has multiple elements at run-time an error will be thrown.

In addition, the underlying Expression Logical Model (ELM) is being extended to allow for dynamic invocation. A `Dynamic` type is introduced with appropriate operators to support run-time invocation where necessary. However, these operators are introduced as an additional layer on top of core ELM, and CQL compiled with the _strict_ option will never produce expressions containing these elements. This avoids placing additional implementation burden on systems that do not need dynamic capabilities.

