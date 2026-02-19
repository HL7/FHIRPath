# FHIRPath Functions Review

Review of all functions defined in the FHIRPath specification (index.md - N2-STU1) against `functions.json` and the normative specification at https://hl7.org/fhirpath/N1/index.html (N1).

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
| 47 | `convertsToQuantity([unit : String]) : Boolean` | 5.5.7.2 | ✅ | |
| 48 | `toString() : String` | 5.5.8.1 | ✅ | |
| 49 | `convertsToString() : Boolean` | 5.5.8.2 | ✅ | |
| 50 | `toTime() : Time` | 5.5.9.1 | ✅ | |
| 51 | `convertsToTime() : Boolean` | 5.5.9.2 | ✅ | |

## 5.6 String Manipulation

| # | Function | Section | N1 | N2-STU1 |
|---|----------|---------|-----|-----|
| 52 | `indexOf(substring : String) : Integer` | 5.6.1 | ✅ | |
| 53 | `lastIndexOf(substring : String) : Integer` | 5.6.2 | No | STU |
| 54 | `substring(start : Integer [, length : Integer]) : String` | 5.6.3 | ✅ | |
| 55 | `startsWith(prefix : String) : Boolean` | 5.6.4 | ✅ | |
| 56 | `endsWith(suffix : String) : Boolean` | 5.6.5 | ✅ | |
| 57 | `contains(substring : String) : Boolean` | 5.6.6 | ✅ | |
| 58 | `upper() : String` | 5.6.7 | ✅ | |
| 59 | `lower() : String` | 5.6.8 | ✅ | |
| 60 | `replace(pattern : String, substitution : String) : String` | 5.6.9 | ✅ | |
| 61 | `matches(regex : String, [flags : String]) : Boolean` | 5.6.10 | ✅ | * |
| 62 | `matchesFull(regex : String, [flags : String]) : Boolean` | 5.6.11 | No | STU |
| 63 | `replaceMatches(regex : String, substitution: String, [flags : String]) : String` | 5.6.12 | ✅ | * |
| 64 | `length() : Integer` | 5.6.13 | ✅ | |
| 65 | `toChars() : collection` | 5.6.14 | ✅ | |

## 5.7 Additional String Functions (STU)

| # | Function | Section | N1 | N2-STU1 |
|---|----------|---------|-----|----|
| 66 | `encode(format : String) : String` | 5.7.1 | No | STU |
| 67 | `decode(format : String) : String` | 5.7.2 | No | STU |
| 68 | `escape(target : String) : String` | 5.7.3 | No | STU |
| 69 | `unescape(target : String) : String` | 5.7.4 | No | STU |
| 70 | `trim() : String` | 5.7.5 | No | STU |
| 71 | `split(separator: String) : collection` | 5.7.6 | No | STU |
| 72 | `join([separator: String]) : String` | 5.7.7 | No | STU |

## 5.8 Math (STU)

| # | Function | Section | N1 | N2-STU1 |
|---|----------|---------|-----|----|
| 73 | `abs() : Integer \| Long \| Decimal \| Quantity` | 5.8.1 | STU | STU |
| 74 | `ceiling() : Integer \| Quantity` | 5.8.2 | STU | STU |
| 75 | `exp() : Decimal` | 5.8.3 | STU | STU |
| 76 | `floor() : Integer \| Quantity` | 5.8.4 | STU | STU |
| 77 | `ln() : Decimal` | 5.8.5 | STU | STU |
| 78 | `log(base : Decimal) : Decimal` | 5.8.6 | STU | STU |
| 79 | `power(exponent : Integer \| Decimal) : Decimal` | 5.8.7 | STU | STU |
| 80 | `round([precision : Integer]) : Decimal \| Quantity` | 5.8.8 | STU | STU |
| 81 | `sqrt() : Decimal` | 5.8.9 | STU | STU |
| 82 | `truncate() : Integer \| Quantity` | 5.8.10 | STU | STU |

## 5.9 Tree navigation

| # | Function | Section | N1 | N2-STU1 |
|---|----------|---------|-----|----|
| 83 | `children() : collection` | 5.9.1 | ✅ | |
| 84 | `descendants() : collection` | 5.9.2 | ✅ | |

## 5.10 Utility functions

| # | Function | Section | N1 | N2-STU1 |
|---|----------|---------|-----|-----|
| 85 | `trace(name : String [, projection]) : collection` | 5.10.1 | ✅ | |
| 86 | `pathname([short : Boolean]) : collection` | 5.10.2 | No | STU |
| 87 | `now() : DateTime` | 5.10.3.1 | ✅ | |
| 88 | `timeOfDay() : Time` | 5.10.3.2 | ✅ | |
| 89 | `today() : Date` | 5.10.3.3 | ✅ | |
| 90 | `defineVariable(name: String [, projection]) : collection` | 5.10.4 | No | STU |
| 91 | `lowBoundary([precision: Integer]) : Decimal \| Date \| DateTime \| Time` | 5.10.5 | No | STU |
| 92 | `highBoundary([precision: Integer]) : Decimal \| Date \| DateTime \| Time` | 5.10.6 | No | STU |
| 93 | `precision() : Integer` | 5.10.7 | No | STU |

### 5.10.8 Extract Date/DateTime/Time Components (STU)

| # | Function | Section | N1 | N2-STU1 |
|---|----------|---------|-----|-----|
| 94 | `yearOf() : Integer` | 5.10.8.1 | No | STU |
| 95 | `monthOf() : Integer` | 5.10.8.2 | No | STU |
| 96 | `dayOf() : Integer` | 5.10.8.3 | No | STU |
| 97 | `hourOf() : Integer` | 5.10.8.4 | No | STU |
| 98 | `minuteOf() : Integer` | 5.10.8.5 | No | STU |
| 99 | `secondOf() : Integer` | 5.10.8.6 | No | STU |
| 100 | `millisecondOf() : Integer` | 5.10.8.7 | No | STU |
| 101 | `timezoneOffsetOf() : Decimal` | 5.10.8.8 | No | STU |
| 102 | `dateOf() : Date` | 5.10.8.9 | No | STU |
| 103 | `timeOf() : Time` | 5.10.8.10 | No | STU |

## 5.11 Date and Time Interval Functions (STU)

| # | Function | Section | N1 | N2-STU1 |
|---|----------|---------|-----|----|
| 104 | `duration(value, precision) : Integer` | 5.11.1 | No | STU |
| 105 | `difference(value, precision) : Integer` | 5.11.2 | No | STU |

## 6.2 Comparison (Operations)

| # | Function | Section | N1 | N2-STU1 |
|---|----------|---------|-----|----|
| 106 | `comparable(other : Quantity) : Boolean` | 6.2.5 | No | STU |

## 6.3 Types (Operations)

| # | Function | Section | N1 | N2-STU1 |
|---|----------|---------|-----|----|
| 107 | `is(type : type specifier) : Boolean` | 6.3.2 | ✅ | |
| 108 | `as(type : type specifier) : collection` | 6.3.4 | ✅ | |

## 6.5 Boolean Logic (Operations)

| # | Function | Section | N1 | N2-STU1 |
|---|----------|---------|-----|----|
| 109 | `not() : Boolean` | 6.5.3 | ✅ | |

## 7 Aggregates (STU)

| # | Function | Section | N1 | N2-STU1 |
|---|----------|---------|-----|----|
| 110 | `aggregate(aggregator : ($total, $this, $index) => collection [, init : collection]) : collection` | 7.1 | STU | STU |
| 111 | `sum() : Integer \| Long \| Decimal \| Quantity` | 7.2 | No | STU |
| 112 | `min() : Integer \| Long \| Decimal \| Quantity \| Date \| DateTime \| Time \| String` | 7.3 | No | STU |
| 113 | `max() : Integer \| Long \| Decimal \| Quantity \| Date \| DateTime \| Time \| String` | 7.4 | No | STU |
| 114 | `avg() : Decimal \| Quantity` | 7.5 | No | STU |

## 10.2 Reflection (Types and Reflection)

| # | Function | Section | N1 | N2-STU1 |
|---|----------|---------|-----|----|
| 115 | `type() : collection` | 10.2.2 | STU | STU |

