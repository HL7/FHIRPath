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

| # | Function | Section | N1 | N2-STU1 |
|---|----------|---------|-----|----|
| 1 | `empty() : Boolean` | 5.1.1 | ✅ | |
| 2 | `exists([criteria : ($this, $index) => Boolean]) : Boolean` | 5.1.2 | ✅ | |
| 3 | `all(criteria : ($this, $index) => Boolean) : Boolean` | 5.1.3 | ✅ | |
| 4 | `allTrue() : Boolean` | 5.1.4 | ✅ | |
| 5 | `anyTrue() : Boolean` | 5.1.5 | ✅ | |
| 6 | `allFalse() : Boolean` | 5.1.6 | ✅ | |
| 7 | `anyFalse() : Boolean` | 5.1.7 | ✅ | |
| 8 | `subsetOf(other : collection) : Boolean` | 5.1.8 | ✅ | |
| 9 | `supersetOf(other : collection) : Boolean` | 5.1.9 | ✅ | |
| 10 | `count() : Integer` | 5.1.10 | ✅ | |
| 11 | `distinct() : collection` | 5.1.11 | ✅ | |
| 12 | `isDistinct() : Boolean` | 5.1.12 | ✅ | |

## 5.2 Filtering and projection

| # | Function | Section | N1 | N2-STU1 |
|---|----------|---------|-----|----|
| 13 | `where(criteria : ($this, $index) => Boolean) : collection` | 5.2.1 | ✅ | |
| 14 | `select(projection: ($this, $index) => any) : collection` | 5.2.2 | ✅ | |
| 15 | Instance Selector / Object Creation (not a function) | 5.2.3 | No | STU |
| 16 | `sort([keySelector: ($this) => any [asc\|desc], ...]) : collection` | 5.2.4 | No | STU |
| 17 | `repeat(projection: ($this) => collection) : collection` | 5.2.5 | ✅ | |
| 18 | `repeatAll(projection: ($this) => collection) : collection` | 5.2.6 | No | STU |
| 19 | `ofType(type : type specifier) : collection` | 5.2.7 | ✅ | |
| 20 | `coalesce(value : collection, [value : collection, ...]) : collection` | 5.2.8 | No | STU |

## 5.3 Subsetting

| # | Function | Section | N1 | N2-STU1 |
|---|----------|---------|-----|----|
| 21 | `[index : Integer] : any` (indexer) | 5.3.1 | ✅ | |
| 22 | `single() : any` | 5.3.2 | ✅ | |
| 23 | `first() : any` | 5.3.3 | ✅ | |
| 24 | `last() : any` | 5.3.4 | ✅ | |
| 25 | `tail() : collection` | 5.3.5 | ✅ | |
| 26 | `skip(num : Integer) : collection` | 5.3.6 | ✅ | |
| 27 | `take(num : Integer) : collection` | 5.3.7 | ✅ | |
| 28 | `intersect(other: collection) : collection` | 5.3.8 | ✅ | |
| 29 | `exclude(other: collection) : collection` | 5.3.9 | ✅ | |

## 5.4 Combining

| # | Function | Section | N1 | N2-STU1 |
|---|----------|---------|-----|----|
| 30 | `union(other : collection) : collection` | 5.4.1 | ✅ | |
| 31 | `combine(other : collection, [preserveOrder : Boolean]) : collection` | 5.4.2 | ✅ | * |

## 5.5 Conversion

| # | Function | Section | N1 | N2-STU1 |
|---|----------|---------|-----|-----|
| 32 | `iif(criterion: ($this, $index) => Boolean, true-result: ($this, $index) => collection [, otherwise-result: ($this, $index) => collection]) : collection` | 5.5.1 | ✅ | * |
| 33 | `toBoolean() : Boolean` | 5.5.2.1 | ✅ | |
| 34 | `convertsToBoolean() : Boolean` | 5.5.2.2 | ✅ | |
| 35 | `toInteger() : Integer` | 5.5.3.1 | ✅ | |
| 36 | `convertsToInteger() : Boolean` | 5.5.3.2 | ✅ | |
| 37 | `toLong() : Long` | 5.5.3.3 | No | STU |
| 38 | `convertsToLong() : Boolean` | 5.5.3.4 | No | STU |
| 39 | Date/DateTime String Format Codes (not a function) | 5.5.4.1 | No | STU |
| 40 | `toDate([format : string]) : Date` | 5.5.4.2 | ✅ | * |
| 41 | `convertsToDate([format : string]) : Boolean` | 5.5.4.3 | ✅ | * |
| 42 | `toDateTime([format : string]) : DateTime` | 5.5.5.1 | ✅ | * |
| 43 | `convertsToDateTime([format : string]) : Boolean` | 5.5.5.2 | ✅ | * |
| 44 | `toDecimal() : Decimal` | 5.5.6.1 | ✅ | |
| 45 | `convertsToDecimal() : Boolean` | 5.5.6.2 | ✅ | |
| 46 | `toQuantity([unit : String]) : Quantity` | 5.5.7.1 | ✅ | |
| 47 | Unit Conversions (not a function) | 5.5.7.2 | No | STU |
| 48 | `convertsToQuantity([unit : String]) : Boolean` | 5.5.7.3 | ✅ | |
| 49 | `toString() : String` | 5.5.8.1 | ✅ | |
| 50 | `convertsToString() : Boolean` | 5.5.8.2 | ✅ | |
| 51 | `toTime() : Time` | 5.5.9.1 | ✅ | |
| 52 | `convertsToTime() : Boolean` | 5.5.9.2 | ✅ | |

## 5.6 String Manipulation

| # | Function | Section | N1 | N2-STU1 |
|---|----------|---------|-----|-----|
| 53 | `indexOf(substring : String) : Integer` | 5.6.1 | ✅ | |
| 54 | `lastIndexOf(substring : String) : Integer` | 5.6.2 | No | STU |
| 55 | `substring(start : Integer [, length : Integer]) : String` | 5.6.3 | ✅ | |
| 56 | `startsWith(prefix : String) : Boolean` | 5.6.4 | ✅ | |
| 57 | `endsWith(suffix : String) : Boolean` | 5.6.5 | ✅ | |
| 58 | `contains(substring : String) : Boolean` | 5.6.6 | ✅ | |
| 59 | `upper() : String` | 5.6.7 | ✅ | |
| 60 | `lower() : String` | 5.6.8 | ✅ | |
| 61 | `replace(pattern : String, substitution : String) : String` | 5.6.9 | ✅ | |
| 62 | `matches(regex : String, [flags : String]) : Boolean` | 5.6.10 | ✅ | * |
| 63 | `matchesFull(regex : String, [flags : String]) : Boolean` | 5.6.11 | No | STU |
| 64 | `replaceMatches(regex : String, substitution: String, [flags : String]) : String` | 5.6.12 | ✅ | * |
| 65 | `length() : Integer` | 5.6.13 | ✅ | |
| 66 | `toChars() : collection` | 5.6.14 | ✅ | |

## 5.7 Additional String Functions (STU)

| # | Function | Section | N1 | N2-STU1 |
|---|----------|---------|-----|----|
| 67 | `encode(format : String) : String` | 5.7.1 | No | STU |
| 68 | `decode(format : String) : String` | 5.7.2 | No | STU |
| 69 | `escape(target : String) : String` | 5.7.3 | No | STU |
| 70 | `unescape(target : String) : String` | 5.7.4 | No | STU |
| 71 | `trim() : String` | 5.7.5 | No | STU |
| 72 | `split(separator: String) : collection` | 5.7.6 | No | STU |
| 73 | `join([separator: String]) : String` | 5.7.7 | No | STU |

## 5.8 Math (STU)

| # | Function | Section | N1 | N2-STU1 |
|---|----------|---------|-----|----|
| 74 | `abs() : Integer \| Long \| Decimal \| Quantity` | 5.8.1 | STU | STU |
| 75 | `ceiling() : Integer \| Quantity` | 5.8.2 | STU | STU |
| 76 | `exp() : Decimal` | 5.8.3 | STU | STU |
| 77 | `floor() : Integer \| Quantity` | 5.8.4 | STU | STU |
| 78 | `ln() : Decimal` | 5.8.5 | STU | STU |
| 79 | `log(base : Decimal) : Decimal` | 5.8.6 | STU | STU |
| 80 | `power(exponent : Integer \| Decimal) : Decimal` | 5.8.7 | STU | STU |
| 81 | `round([precision : Integer]) : Decimal \| Quantity` | 5.8.8 | STU | STU |
| 82 | `sqrt() : Decimal` | 5.8.9 | STU | STU |
| 83 | `truncate() : Integer \| Quantity` | 5.8.10 | STU | STU |

## 5.9 Tree navigation

| # | Function | Section | N1 | N2-STU1 |
|---|----------|---------|-----|----|
| 84 | `children() : collection` | 5.9.1 | ✅ | |
| 85 | `descendants() : collection` | 5.9.2 | ✅ | |

## 5.10 Utility functions

| # | Function | Section | N1 | N2-STU1 |
|---|----------|---------|-----|-----|
| 86 | `trace(name : String [, projection]) : collection` | 5.10.1 | ✅ | |
| 87 | `pathname([short : Boolean]) : collection` | 5.10.2 | No | STU |
| 88 | `now() : DateTime` | 5.10.3.1 | ✅ | |
| 89 | `timeOfDay() : Time` | 5.10.3.2 | ✅ | |
| 90 | `today() : Date` | 5.10.3.3 | ✅ | |
| 91 | `defineVariable(name: String [, projection]) : collection` | 5.10.4 | No | STU |
| 92 | `lowBoundary([precision: Integer]) : Decimal \| Date \| DateTime \| Time` | 5.10.5 | No | STU |
| 93 | `highBoundary([precision: Integer]) : Decimal \| Date \| DateTime \| Time` | 5.10.6 | No | STU |
| 94 | `precision() : Integer` | 5.10.7 | No | STU |

### 5.10.8 Extract Date/DateTime/Time Components (STU)

| # | Function | Section | N1 | N2-STU1 |
|---|----------|---------|-----|-----|
| 95 | `yearOf() : Integer` | 5.10.8.1 | No | STU |
| 96 | `monthOf() : Integer` | 5.10.8.2 | No | STU |
| 97 | `dayOf() : Integer` | 5.10.8.3 | No | STU |
| 98 | `hourOf() : Integer` | 5.10.8.4 | No | STU |
| 99 | `minuteOf() : Integer` | 5.10.8.5 | No | STU |
| 100 | `secondOf() : Integer` | 5.10.8.6 | No | STU |
| 101 | `millisecondOf() : Integer` | 5.10.8.7 | No | STU |
| 102 | `timezoneOffsetOf() : Decimal` | 5.10.8.8 | No | STU |
| 103 | `dateOf() : Date` | 5.10.8.9 | No | STU |
| 104 | `timeOf() : Time` | 5.10.8.10 | No | STU |

## 5.11 Date and Time Interval Functions (STU)

| # | Function | Section | N1 | N2-STU1 |
|---|----------|---------|-----|----|
| 105 | `duration(value, precision) : Integer` | 5.11.1 | No | STU |
| 106 | `difference(value, precision) : Integer` | 5.11.2 | No | STU |

## 6.2 Comparison (Operations)

| # | Function | Section | N1 | N2-STU1 |
|---|----------|---------|-----|----|
| 107 | `comparable(other : Quantity) : Boolean` | 6.2.5 | No | STU |

## 6.3 Types (Operations)

| # | Function | Section | N1 | N2-STU1 |
|---|----------|---------|-----|----|
| 108 | `is(type : type specifier) : Boolean` | 6.3.2 | ✅ | |
| 109 | `as(type : type specifier) : collection` | 6.3.4 | ✅ | |

## 6.5 Boolean Logic (Operations)

| # | Function | Section | N1 | N2-STU1 |
|---|----------|---------|-----|----|
| 110 | `not() : Boolean` | 6.5.3 | ✅ | |

## 7 Aggregates (STU)

| # | Function | Section | N1 | N2-STU1 |
|---|----------|---------|-----|----|
| 111 | `aggregate(aggregator : ($total, $this, $index) => collection [, init : collection]) : collection` | 7.1 | STU | STU |
| 112 | `sum() : Integer \| Long \| Decimal \| Quantity` | 7.2 | No | STU |
| 113 | `min() : Integer \| Long \| Decimal \| Quantity \| Date \| DateTime \| Time \| String` | 7.3 | No | STU |
| 114 | `max() : Integer \| Long \| Decimal \| Quantity \| Date \| DateTime \| Time \| String` | 7.4 | No | STU |
| 115 | `avg() : Decimal \| Quantity` | 7.5 | No | STU |

## 10.2 Reflection (Types and Reflection)

| # | Function | Section | N1 | N2-STU1 |
|---|----------|---------|-----|----|
| 116 | `type() : collection` | 10.2.2 | STU | STU |

