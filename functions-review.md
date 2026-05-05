# FHIRPath Functions Review

Review of all functions defined in the FHIRPath specification (index.md - N2-STU1) against `functions.json` and the normative specification at https://hl7.org/fhirpath/N1/index.html (N1).

> Note: The emptyInputResult column now has a new possible value: 'criterion-dependent'
>       *(the other valid values are true/false/0/empty)*

**Legend:**
* N1 Column function status in N1 specification
    - `✅` - the function is normative
    - `STU` - the function is STU
    - `No` - the function was not present
* N2-STU1 Column function status in N2-STU1 specification (current draft)
    - ` ` - Function semantically unchanged from N1
    - `STU` - the function is STU
    - `*` - the function has had substantive clarifications/additions since a normative N1

---

## 5.1 Existence

| Function | Section | N1 | N2-STU1 |
|----------|---------|-----|----|
| `empty() : Boolean` | 5.1.1 | ✅ | |
| `exists([criteria : ($this, $index) => Boolean]) : Boolean` | 5.1.2 | ✅ | |
| `all(criteria : ($this, $index) => Boolean) : Boolean` | 5.1.3 | ✅ | |
| `allTrue() : Boolean` | 5.1.4 | ✅ | |
| `anyTrue() : Boolean` | 5.1.5 | ✅ | |
| `allFalse() : Boolean` | 5.1.6 | ✅ | |
| `anyFalse() : Boolean` | 5.1.7 | ✅ | |
| `subsetOf(other : collection) : Boolean` | 5.1.8 | ✅ | |
| `supersetOf(other : collection) : Boolean` | 5.1.9 | ✅ | |
| `count() : Integer` | 5.1.10 | ✅ | |
| `distinct() : collection` | 5.1.11 | ✅ | |
| `isDistinct() : Boolean` | 5.1.12 | ✅ | |

## 5.2 Filtering and projection

| Function | Section | N1 | N2-STU1 |
|----------|---------|-----|----|
| `where(criteria : ($this, $index) => Boolean) : collection` | 5.2.1 | ✅ | |
| `select(projection: ($this, $index) => any) : collection` | 5.2.2 | ✅ | |
| Instance Selector / Object Creation (not a function) | 5.2.3 | No | STU |
| `sort([keySelector: ($this) => any [asc\|desc], ...]) : collection` | 5.2.4 | No | STU |
| `repeat(projection: ($this) => collection) : collection` | 5.2.5 | ✅ | |
| `repeatAll(projection: ($this) => collection) : collection` | 5.2.6 | No | STU |
| `ofType(type : type specifier) : collection` | 5.2.7 | ✅ | |
| `coalesce(value : collection, [value : collection, ...]) : collection` | 5.2.8 | No | STU |

## 5.3 Subsetting

| Function | Section | N1 | N2-STU1 |
|----------|---------|-----|----|
| `[index : Integer] : any` (indexer) | 5.3.1 | ✅ | |
| `single() : any` | 5.3.2 | ✅ | |
| `first() : any` | 5.3.3 | ✅ | |
| `last() : any` | 5.3.4 | ✅ | |
| `tail() : collection` | 5.3.5 | ✅ | |
| `skip(num : Integer) : collection` | 5.3.6 | ✅ | |
| `take(num : Integer) : collection` | 5.3.7 | ✅ | |
| `intersect(other: collection) : collection` | 5.3.8 | ✅ | |
| `exclude(other: collection) : collection` | 5.3.9 | ✅ | |

## 5.4 Combining

| Function | Section | N1 | N2-STU1 |
|---|----------|---------|-----|----|
| `union(other : collection) : collection` | 5.4.1 | ✅ | |
| `combine(other : collection, [preserveOrder : Boolean]) : collection` | 5.4.2 | ✅ | * |

## 5.5 Conversion

| Function | Section | N1 | N2-STU1 |
|---|----------|---------|-----|-----|
| `iif(criterion: ($this, $index) => Boolean, true-result: ($this, $index) => collection [, otherwise-result: ($this, $index) => collection]) : collection` | 5.5.1 | ✅ | * |
| `toBoolean() : Boolean` | 5.5.2.1 | ✅ | |
| `convertsToBoolean() : Boolean` | 5.5.2.2 | ✅ | |
| `toInteger() : Integer` | 5.5.3.1 | ✅ | |
| `convertsToInteger() : Boolean` | 5.5.3.2 | ✅ | |
| `toLong() : Long` | 5.5.3.3 | No | STU |
| `convertsToLong() : Boolean` | 5.5.3.4 | No | STU |
| Date/DateTime String Format Codes (not a function) | 5.5.4.1 | No | STU |
| `toDate([format : string]) : Date` | 5.5.4.2 | ✅ | * |
| `convertsToDate([format : string]) : Boolean` | 5.5.4.3 | ✅ | * |
| `toDateTime([format : string]) : DateTime` | 5.5.5.1 | ✅ | * |
| `convertsToDateTime([format : string]) : Boolean` | 5.5.5.2 | ✅ | * |
| `toDecimal() : Decimal` | 5.5.6.1 | ✅ | |
| `convertsToDecimal() : Boolean` | 5.5.6.2 | ✅ | |
| `toQuantity([unit : String]) : Quantity` | 5.5.7.1 | ✅ | |
| Unit Conversions (not a function) | 5.5.7.2 | No | STU |
| `convertsToQuantity([unit : String]) : Boolean` | 5.5.7.3 | ✅ | |
| `toString() : String` | 5.5.8.1 | ✅ | |
| `convertsToString() : Boolean` | 5.5.8.2 | ✅ | |
| `toTime() : Time` | 5.5.9.1 | ✅ | |
| `convertsToTime() : Boolean` | 5.5.9.2 | ✅ | |

## 5.6 String Manipulation

| Function | Section | N1 | N2-STU1 |
|---|----------|---------|-----|-----|
| `indexOf(substring : String) : Integer` | 5.6.1 | ✅ | |
| `lastIndexOf(substring : String) : Integer` | 5.6.2 | No | STU |
| `substring(start : Integer [, length : Integer]) : String` | 5.6.3 | ✅ | |
| `startsWith(prefix : String) : Boolean` | 5.6.4 | ✅ | |
| `endsWith(suffix : String) : Boolean` | 5.6.5 | ✅ | |
| `contains(substring : String) : Boolean` | 5.6.6 | ✅ | |
| `upper() : String` | 5.6.7 | ✅ | |
| `lower() : String` | 5.6.8 | ✅ | |
| `replace(pattern : String, substitution : String) : String` | 5.6.9 | ✅ | |
| `matches(regex : String, [flags : String]) : Boolean` | 5.6.10 | ✅ | * |
| `matchesFull(regex : String, [flags : String]) : Boolean` | 5.6.11 | No | STU |
| `replaceMatches(regex : String, substitution: String, [flags : String]) : String` | 5.6.12 | ✅ | * |
| `length() : Integer` | 5.6.13 | ✅ | |
| `toChars() : collection` | 5.6.14 | ✅ | |

## 5.7 Additional String Functions (STU)

| Function | Section | N1 | N2-STU1 |
|---|----------|---------|-----|----|
| `encode(format : String) : String` | 5.7.1 | No | STU |
| `decode(format : String) : String` | 5.7.2 | No | STU |
| `escape(target : String) : String` | 5.7.3 | No | STU |
| `unescape(target : String) : String` | 5.7.4 | No | STU |
| `trim() : String` | 5.7.5 | No | STU |
| `split(separator: String) : collection` | 5.7.6 | No | STU |
| `join([separator: String]) : String` | 5.7.7 | No | STU |

## 5.8 Math (STU)

| Function | Section | N1 | N2-STU1 |
|---|----------|---------|-----|----|
| `abs() : Integer \| Long \| Decimal \| Quantity` | 5.8.1 | STU | STU |
| `ceiling() : Integer \| Quantity` | 5.8.2 | STU | STU |
| `exp() : Decimal` | 5.8.3 | STU | STU |
| `floor() : Integer \| Quantity` | 5.8.4 | STU | STU |
| `ln() : Decimal` | 5.8.5 | STU | STU |
| `log(base : Decimal) : Decimal` | 5.8.6 | STU | STU |
| `power(exponent : Integer \| Decimal) : Decimal` | 5.8.7 | STU | STU |
| `round([precision : Integer]) : Decimal \| Quantity` | 5.8.8 | STU | STU |
| `sqrt() : Decimal` | 5.8.9 | STU | STU |
| `truncate() : Integer \| Quantity` | 5.8.10 | STU | STU |

## 5.9 Tree navigation

| Function | Section | N1 | N2-STU1 |
|---|----------|---------|-----|----|
| `children() : collection` | 5.9.1 | ✅ | |
| `descendants() : collection` | 5.9.2 | ✅ | |

## 5.10 Utility functions

| Function | Section | N1 | N2-STU1 |
|---|----------|---------|-----|-----|
| `trace(name : String [, projection]) : collection` | 5.10.1 | ✅ | |
| `pathname([short : Boolean]) : collection` | 5.10.2 | No | STU |
| `now() : DateTime` | 5.10.3.1 | ✅ | |
| `timeOfDay() : Time` | 5.10.3.2 | ✅ | |
| `today() : Date` | 5.10.3.3 | ✅ | |
| `defineVariable(name: String [, projection]) : collection` | 5.10.4 | No | STU |
| `lowBoundary([precision: Integer]) : Decimal \| Date \| DateTime \| Time` | 5.10.5 | No | STU |
| `highBoundary([precision: Integer]) : Decimal \| Date \| DateTime \| Time` | 5.10.6 | No | STU |
| `precision() : Integer` | 5.10.7 | No | STU |

### 5.10.8 Extract Date/DateTime/Time Components (STU)

| Function | Section | N1 | N2-STU1 |
|---|----------|---------|-----|-----|
| `yearOf() : Integer` | 5.10.8.1 | No | STU |
| `monthOf() : Integer` | 5.10.8.2 | No | STU |
| `dayOf() : Integer` | 5.10.8.3 | No | STU |
| `hourOf() : Integer` | 5.10.8.4 | No | STU |
| `minuteOf() : Integer` | 5.10.8.5 | No | STU |
| `secondOf() : Integer` | 5.10.8.6 | No | STU |
| `millisecondOf() : Integer` | 5.10.8.7 | No | STU |
| `timezoneOffsetOf() : Decimal` | 5.10.8.8 | No | STU |
| `dateOf() : Date` | 5.10.8.9 | No | STU |
| `timeOf() : Time` | 5.10.8.10 | No | STU |

## 5.11 Date and Time Interval Functions (STU)

| Function | Section | N1 | N2-STU1 |
|---|----------|---------|-----|----|
| `duration(value, precision) : Integer` | 5.11.1 | No | STU |
| `difference(value, precision) : Integer` | 5.11.2 | No | STU |

## 6.2 Comparison (Operations)

| Function | Section | N1 | N2-STU1 |
|---|----------|---------|-----|----|
| `comparable(other : Quantity) : Boolean` | 6.2.5 | No | STU |

## 6.3 Types (Operations)

| Function | Section | N1 | N2-STU1 |
|---|----------|---------|-----|----|
| `is(type : type specifier) : Boolean` | 6.3.2 | ✅ | |
| `as(type : type specifier) : collection` | 6.3.4 | ✅ | |

## 6.5 Boolean Logic (Operations)

| Function | Section | N1 | N2-STU1 |
|---|----------|---------|-----|----|
| `not() : Boolean` | 6.5.3 | ✅ | |

## 7 Aggregates (STU)

| Function | Section | N1 | N2-STU1 |
|---|----------|---------|-----|----|
| `aggregate(aggregator : ($total, $this, $index) => collection [, init : collection]) : collection` | 7.1 | STU | STU |
| `sum() : Integer \| Long \| Decimal \| Quantity` | 7.2 | No | STU |
| `min() : Integer \| Long \| Decimal \| Quantity \| Date \| DateTime \| Time \| String` | 7.3 | No | STU |
| `max() : Integer \| Long \| Decimal \| Quantity \| Date \| DateTime \| Time \| String` | 7.4 | No | STU |
| `avg() : Decimal \| Quantity` | 7.5 | No | STU |

## 10.2 Reflection (Types and Reflection)

| Function | Section | N1 | N2-STU1 |
|---|----------|---------|-----|----|
| `type() : collection` | 10.2.2 | STU | STU |

