# FHIRPath Functions Review

Review of all functions defined in the FHIRPath specification (index.md - R3) against `functions.json` and the normative specification at https://hl7.org/fhirpath/N1/index.html (N1).

> Note: The emptyInputResult column now has a new possible value: 'criterion-dependent'
>       *(the other valid values are `true`/`false`/`0`/`empty`)*

**Legend:**
* N1 Column function status in N1 specification
    - `✅` - the function is normative
    - `STU` - the function is STU
    - `- ` - the function was not present
* R3 Column function status in R3 specification (current draft)
    - `✅` - Function semantically unchanged from N1 (or change is purely editorial — added examples, wording polish, signature notation only)
    - `STU` - the function is STU
    - `✱` - the function has had substantive additions / new optional parameters / new feature(s) since N1
    - `⚠` - flag for potentially breaking change vs. N1 — see Notes
* Notes column describes what changed (clarification, ambiguity resolution, added feature, etc.)

> **Final review (R3 publication):** Each row was checked function-by-function against [N1](https://hl7.org/fhirpath/N1/index.html). The Notes column captures every meaningful difference detected, classified as one of:
> *editorial* (wording/example refresh), *clarification* (text made unambiguous, no behavior change),
> *ambiguity resolution* (under-specified case in N1 now defined), *new feature* (`✱`),
> or *breaking* (`⚠`). No breaking changes were detected for the functions in this review.

---

## 5.1 Existence

| Function | Section | N1 | R3 | Notes |
|----------|---------|-----|----|-------|
| `empty() : Boolean` | 5.1.1 | ✅ | ✅ | Unchanged. Added illustrative example. |
| `exists([criteria : ($this, $index) => Boolean]) : Boolean` | 5.1.2 | ✅ | ✅ | *Editorial* — parameter notation changed from `criteria : expression` to lambda form `($this, $index) => Boolean` (same semantics; explicit *scoped function* call-out added). N1 already documented `$this`/`$index` access in expression parameters. |
| `all(criteria : ($this, $index) => Boolean) : Boolean` | 5.1.3 | ✅ | ✅ | *Editorial* — same notation update as `exists()`. |
| `allTrue() : Boolean` | 5.1.4 | ✅ | ✅ | Unchanged. |
| `anyTrue() : Boolean` | 5.1.5 | ✅ | ✅ | Unchanged. |
| `allFalse() : Boolean` | 5.1.6 | ✅ | ✅ | Unchanged. |
| `anyFalse() : Boolean` | 5.1.7 | ✅ | ✅ | Unchanged. |
| `subsetOf(other : collection) : Boolean` | 5.1.8 | ✅ | ✅ | *Clarification* — explicitly states that membership requires `=` to return `true` (so `false` and empty both indicate non-membership). Behavior matches N1. |
| `supersetOf(other : collection) : Boolean` | 5.1.9 | ✅ | ✅ | *Clarification* — same equality-semantics tightening as `subsetOf()`. |
| `count() : Integer` | 5.1.10 | ✅ | ✅ | Unchanged. Added illustrative example. |
| `distinct() : collection` | 5.1.11 | ✅ | ✅ | *Clarification* — explicitly states that items are equal when `=` returns `true`. Quantity unit-conversion example is consistent with the (separately STU) Quantity unit-conversion behavior; not a new behavior of `distinct()` itself. |
| `isDistinct() : Boolean` | 5.1.12 | ✅ | ✅ | *Clarification* — equality semantics tightened as for `distinct()`. |

## 5.2 Filtering and projection

| Function | Section | N1 | R3 | Notes |
|----------|---------|-----|----|-------|
| `where(criteria : ($this, $index) => Boolean) : collection` | 5.2.1 | ✅ | ✅ | *Editorial* — lambda notation for `criteria` (same `$this`/`$index` semantics as N1). |
| `select(projection: ($this, $index) => any) : collection` | 5.2.2 | ✅ | ✅ | *Editorial* — lambda notation for `projection` (same semantics). |
| Instance Selector / Object Creation (not a function) | 5.2.3 | - | STU | New STU language construct (related to `select`). |
| `sort([keySelector: ($this) => any [asc\|desc], ...]) : collection` | 5.2.4 | - | STU | New STU function. |
| `repeat(projection: ($this) => collection) : collection` | 5.2.5 | ✅ | ✅ | *Clarification* — adds an explicit input-queue/output-collection algorithmic description and notes `$index` is undefined inside `repeat`. Explicitly states equality is by `=` returning `true`. Same observable behavior as N1. |
| `repeatAll(projection: ($this) => collection) : collection` | 5.2.6 | - | STU | New STU function (variant of `repeat` that retains duplicates). |
| `ofType(type : type specifier) : collection` | 5.2.7 | ✅ | ✅ | Unchanged. |
| `coalesce(value : collection, [value : collection, ...]) : collection` | 5.2.8 | - | STU | New STU function. |

## 5.3 Subsetting

| Function | Section | N1 | R3 | Notes |
|----------|---------|-----|----|-------|
| `[index : Integer] : any` (indexer) | 5.3.1 | ✅ | ✅ | *Editorial* — return-type notation tightened from `: collection` to `: any` to reflect that at most one item is returned. Behavior unchanged. |
| `single() : any` | 5.3.2 | ✅ | ✅ | *Editorial* — return-type notation `: collection` → `: any` (at most one item). Behavior unchanged. |
| `first() : any` | 5.3.3 | ✅ | ✅ | *Editorial* — return-type `: collection` → `: any`. Behavior unchanged. |
| `last() : any` | 5.3.4 | ✅ | ✅ | *Editorial* — return-type `: collection` → `: any`. Behavior unchanged. |
| `tail() : collection` | 5.3.5 | ✅ | ✅ | Unchanged. Added example. |
| `skip(num : Integer) : collection` | 5.3.6 | ✅ | ✅ | Unchanged. Added examples. |
| `take(num : Integer) : collection` | 5.3.7 | ✅ | ✅ | Unchanged. Added examples. |
| `intersect(other: collection) : collection` | 5.3.8 | ✅ | ✅ | Unchanged. Added example. |
| `exclude(other: collection) : collection` | 5.3.9 | ✅ | ✅ | Unchanged. |

## 5.4 Combining

| Function | Section | N1 | R3 | Notes |
|----------|---------|----|----|-------|
| `union(other : collection) : collection` | 5.4.1 | ✅ | ✅ | *Editorial* — return type `: collection` is now stated explicitly in the signature (N1 omitted it). Equality-semantics wording tightened to refer to `=` returning `true`. Behavior unchanged. |
| `combine(other : collection, [preserveOrder : Boolean]) : collection` | 5.4.2 | ✅ | ✱ | *New feature (STU)* — added optional `preserveOrder : Boolean` parameter. When omitted or `false`, behavior matches N1 (no order expectation). When `true`, the items of `other` are appended to the input items, preserving order. The new parameter's behavior is marked STU within the function description. |

## 5.5 Conversion

| Function | Section | N1 | R3 | Notes |
|----------|---------|----|----|-------|
| `iif(criterion: ($this, $index) => Boolean, true-result: ($this, $index) => collection [, otherwise-result: ($this, $index) => collection]) : collection` | 5.5.1 | ✅ | ✱ | *New feature + clarification* — `true-result` and `otherwise-result` are now scoped (lambdas) with `$this` set to the input value (`$index` is **not** set). Explicitly clarifies that `iif` may be called with no context, with a single-item context, or on an empty collection (in which case `criterion` is still evaluated). Behavior on multiple-item input (error) and short-circuit semantics are unchanged. The lambda evaluation makes existing N1 expressions like `iif(true, $this)` more clearly defined. |
| `toBoolean() : Boolean` | 5.5.2.1 | ✅ | ✅ | Unchanged. Added examples. |
| `convertsToBoolean() : Boolean` | 5.5.2.2 | ✅ | ✅ | Unchanged. Added examples. |
| `toInteger() : Integer` | 5.5.3.1 | ✅ | ✅ | Unchanged. Added examples. |
| `convertsToInteger() : Boolean` | 5.5.3.2 | ✅ | ✅ | Unchanged. Added examples. |
| `toLong() : Long` | 5.5.3.3 | - | STU | New STU function (introduces the STU `Long` type). |
| `convertsToLong() : Boolean` | 5.5.3.4 | - | STU | New STU function. |
| Date/DateTime String Format Codes (not a function) | 5.5.4.1 | - | STU | New STU table of format codes used by the new `format` parameters. |
| `toDate([format : string]) : Date` | 5.5.4.2 | ✅ | ✱ | *New feature (STU)* — added optional `format` parameter using the new format-code table. When omitted, behavior matches N1 (default `yyyy-MM-DD`). |
| `convertsToDate([format : string]) : Boolean` | 5.5.4.3 | ✅ | ✱ | *New feature (STU)* — same `format` parameter as `toDate`. |
| `toDateTime([format : string]) : DateTime` | 5.5.5.1 | ✅ | ✱ | *New feature (STU)* — added optional `format` parameter. Default behavior unchanged from N1. |
| `convertsToDateTime([format : string]) : Boolean` | 5.5.5.2 | ✅ | ✱ | *New feature (STU)* — same `format` parameter as `toDateTime`. |
| `toDecimal() : Decimal` | 5.5.6.1 | ✅ | ✅ | Unchanged. Added examples. |
| `convertsToDecimal() : Boolean` | 5.5.6.2 | ✅ | ✅ | Unchanged. Added examples. |
| `toQuantity([unit : String]) : Quantity` | 5.5.7.1 | ✅ | ✱ | *Ambiguity resolution* — N1's prose said the `unit` argument's effect was a true/false convertibility check, contradicting the declared `Quantity` return type. R3 specifies the documented behavior: when `unit` is provided and the input is convertible, the result is the converted Quantity; otherwise empty. The Long input is also accepted (Long itself is STU). The actual unit-conversion algorithm is described in the (STU) Unit Conversions sub-section. No silent break of N1-conformant implementations expected. |
| Unit Conversions (not a function) | 5.5.7.2 | - | STU | New STU sub-section formalizing UCUM/calendar unit conversion rules. |
| `convertsToQuantity([unit : String]) : Boolean` | 5.5.7.3 | ✅ | ✱ | *Clarification* — wording aligned with the resolved `toQuantity` semantics. Behavior matches the (already-true/false) N1 contract. |
| `toString() : String` | 5.5.8.1 | ✅ | ✅ | Unchanged. Format-table notation tweaked editorially. |
| `convertsToString() : Boolean` | 5.5.8.2 | ✅ | ✅ | Unchanged. |
| `toTime() : Time` | 5.5.9.1 | ✅ | ✅ | Unchanged. Added examples. |
| `convertsToTime() : Boolean` | 5.5.9.2 | ✅ | ✅ | Unchanged. Added examples. |

## 5.6 String Manipulation

| Function | Section | N1 | R3 | Notes |
|----------|---------|----|-----|-------|
| `indexOf(substring : String) : Integer` | 5.6.1 | ✅ | ✅ | *Clarification* — explicitly states the index is measured in characters (Unicode scalar values), not bytes or UTF-16 code units. Behavior matches N1's intent. |
| `lastIndexOf(substring : String) : Integer` | 5.6.2 | - | STU | New STU function. |
| `substring(start : Integer [, length : Integer]) : String` | 5.6.3 | ✅ | ✅ | *Ambiguity resolution* — clarifies measurement in Unicode scalar values, the `start == length` case (returns empty), the negative-start case (returns empty), and a new explicit rule for negative or zero `length` (returns the empty string `''`). N1 was silent on the zero/negative `length` case. Same observable behavior for cases N1 covered. |
| `startsWith(prefix : String) : Boolean` | 5.6.4 | ✅ | ✅ | Unchanged. |
| `endsWith(suffix : String) : Boolean` | 5.6.5 | ✅ | ✅ | Unchanged. (N1 example had a typo `ednsWith`; corrected in R3.) |
| `contains(substring : String) : Boolean` | 5.6.6 | ✅ | ✅ | Unchanged. |
| `upper() : String` | 5.6.7 | ✅ | ✅ | Unchanged. |
| `lower() : String` | 5.6.8 | ✅ | ✅ | Unchanged. |
| `replace(pattern : String, substitution : String) : String` | 5.6.9 | ✅ | ✅ | *Clarification* — added examples showing that surrogate-pair / multi-code-unit Unicode characters are treated as a single character when `pattern` is `''`. Consistent with N1 intent. |
| `matches(regex : String, [flags : String]) : Boolean` | 5.6.10 | ✅ | ✱ | *New feature (STU)* — added optional `flags` parameter (`i`, `m`); also clarifies behavior of `^`/`$` anchors. When `flags` is omitted, behavior matches N1. |
| `matchesFull(regex : String, [flags : String]) : Boolean` | 5.6.11 | - | STU | New STU function. |
| `replaceMatches(regex : String, substitution: String, [flags : String]) : String` | 5.6.12 | ✅ | ✱ | *New feature (STU)* — added optional `flags` parameter (`i`, `m`). Default-flags behavior matches N1. |
| `length() : Integer` | 5.6.13 | ✅ | ✅ | *Clarification* — explicitly defined as the number of Unicode scalar values (not grapheme clusters or UTF-16 code units). Adds a note (STU-marked) about grapheme clusters. Behavior matches N1's intent. |
| `toChars() : collection` | 5.6.14 | ✅ | ✅ | *Clarification* — explicitly states that the output items are individual single-character strings. Behavior matches N1. |

## 5.7 Additional String Functions (STU)

All functions in this section are new in R3 (none in N1).

| Function | Section | N1 | R3 | Notes |
|----------|---------|-----|----|-------|
| `encode(format : String) : String` | 5.7.1 | - | STU | New STU function. |
| `decode(format : String) : String` | 5.7.2 | - | STU | New STU function. |
| `escape(target : String) : String` | 5.7.3 | - | STU | New STU function. |
| `unescape(target : String) : String` | 5.7.4 | - | STU | New STU function. |
| `trim() : String` | 5.7.5 | - | STU | New STU function. |
| `split(separator: String) : collection` | 5.7.6 | - | STU | New STU function. |
| `join([separator: String]) : String` | 5.7.7 | - | STU | New STU function. |

## 5.8 Math (STU)

All Math functions remained STU in R3 (also STU in N1).

| Function | Section | N1 | R3 | Notes |
|----------|---------|-----|----|-------|
| `abs() : Integer \| Long \| Decimal \| Quantity` | 5.8.1 | STU | STU | Return type extended to include `Long` (STU). Quantity behavior clarified. |
| `ceiling() : Integer \| Quantity` | 5.8.2 | STU | STU | Return type extended to include `Quantity`. |
| `exp() : Decimal` | 5.8.3 | STU | STU | Unchanged. |
| `floor() : Integer \| Quantity` | 5.8.4 | STU | STU | Return type extended to include `Quantity`. |
| `ln() : Decimal` | 5.8.5 | STU | STU | Unchanged. |
| `log(base : Decimal) : Decimal` | 5.8.6 | STU | STU | Unchanged. |
| `power(exponent : Integer \| Decimal) : Decimal` | 5.8.7 | STU | STU | Return type narrowed/clarified to `Decimal` (N1 listed `Integer \| Decimal`); aligns with the prose that always returns `Decimal` after implicit conversion when needed. |
| `round([precision : Integer]) : Decimal \| Quantity` | 5.8.8 | STU | STU | Return type extended to include `Quantity`. |
| `sqrt() : Decimal` | 5.8.9 | STU | STU | Unchanged. |
| `truncate() : Integer \| Quantity` | 5.8.10 | STU | STU | Return type extended to include `Quantity`. |

## 5.9 Tree navigation

| Function | Section | N1 | R3 | Notes |
|----------|---------|-----|----|-------|
| `children() : collection` | 5.9.1 | ✅ | ✅ | Unchanged. Added example. |
| `descendants() : collection` | 5.9.2 | ✅ | ✅ | Unchanged. Added example. (N1 said "nodes"; R3 says "items" — editorial only.) |

## 5.10 Utility functions

| Function | Section | N1 | R3 | Notes |
|----------|---------|-----|----|-------|
| `trace(name : String [, projection]) : collection` | 5.10.1 | ✅ | ✅ | *Editorial* — `projection` parameter notation tightened to `($this, $index) => any`; explicitly noted as a scoped function, and that `name` is evaluated once. Same semantics as N1. |
| `pathname([short : Boolean]) : collection` | 5.10.2 | - | STU | New STU function. |
| `now() : DateTime` | 5.10.3.1 | ✅ | ✅ | Unchanged. Added example. |
| `timeOfDay() : Time` | 5.10.3.2 | ✅ | ✅ | Unchanged. Added example. |
| `today() : Date` | 5.10.3.3 | ✅ | ✅ | Unchanged. Added example. |
| `defineVariable(name: String [, projection]) : collection` | 5.10.4 | - | STU | New STU function. |
| `lowBoundary([precision: Integer]) : Decimal \| Date \| DateTime \| Time` | 5.10.5 | - | STU | New STU function. |
| `highBoundary([precision: Integer]) : Decimal \| Date \| DateTime \| Time` | 5.10.6 | - | STU | New STU function. |
| `precision() : Integer` | 5.10.7 | - | STU | New STU function. |

### 5.10.8 Extract Date/DateTime/Time Components (STU)

All component-extraction functions are new in R3 (none in N1).

| Function | Section | N1 | R3 | Notes |
|----------|---------|----|----|-------|
| `yearOf() : Integer` | 5.10.8.1 | - | STU | New STU function. |
| `monthOf() : Integer` | 5.10.8.2 | - | STU | New STU function. |
| `dayOf() : Integer` | 5.10.8.3 | - | STU | New STU function. |
| `hourOf() : Integer` | 5.10.8.4 | - | STU | New STU function. |
| `minuteOf() : Integer` | 5.10.8.5 | - | STU | New STU function. |
| `secondOf() : Integer` | 5.10.8.6 | - | STU | New STU function. |
| `millisecondOf() : Integer` | 5.10.8.7 | - | STU | New STU function. |
| `timezoneOffsetOf() : Decimal` | 5.10.8.8 | - | STU | New STU function. |
| `dateOf() : Date` | 5.10.8.9 | - | STU | New STU function. |
| `timeOf() : Time` | 5.10.8.10 | - | STU | New STU function. |

## 5.11 Date and Time Interval Functions (STU)

| Function | Section | N1 | R3 | Notes |
|----------|---------|-----|----|-------|
| `duration(value, precision) : Integer` | 5.11.1 | - | STU | New STU function. |
| `difference(value, precision) : Integer` | 5.11.2 | - | STU | New STU function. |

## 6.2 Comparison (Operations)

| Function | Section | N1 | R3 | Notes |
|----------|---------|-----|----|-------|
| `comparable(other : Quantity) : Boolean` | 6.2.5 | - | STU | New STU function. |

## 6.3 Types (Operations)

| Function | Section | N1 | R3 | Notes |
|----------|---------|-----|----|-------|
| `is(type : type specifier) : Boolean` | 6.3.2 | ✅ | ✅ | *Editorial* — text unchanged; documented as a backwards-compatibility alias for the `is` operator. **Note:** The companion `is` *operator* (§6.3.1, not in this table) had its empty-input fallback wording changed from "empty collection" (N1) to "`false`" (R3); see [operations-review.md](operations-review.md) — that change is tracked in the operator review, and the function form inherits whatever the operator does. |
| `as(type : type specifier) : collection` | 6.3.4 | ✅ | ✅ | *Editorial* — text unchanged; documented as a backwards-compatibility alias for the `as` operator. |

## 6.5 Boolean Logic (Operations)

| Function | Section | N1 | R3 | Notes |
|----------|---------|-----|----|-------|
| `not() : Boolean` | 6.5.3 | ✅ | ✅ | Unchanged. |

## 7 Aggregates (STU)

| Function | Section | N1 | R3 | Notes |
|----------|---------|-----|----|-------|
| `aggregate(aggregator : ($total, $this, $index) => collection [, init : collection]) : collection` | 7.1 | STU | STU | *Editorial* — lambda notation tightened. STU in both N1 and R3; semantics unchanged. |
| `sum() : Integer \| Long \| Decimal \| Quantity` | 7.2 | - | STU | New STU function. |
| `min() : Integer \| Long \| Decimal \| Quantity \| Date \| DateTime \| Time \| String` | 7.3 | - | STU | New STU function. |
| `max() : Integer \| Long \| Decimal \| Quantity \| Date \| DateTime \| Time \| String` | 7.4 | - | STU | New STU function. |
| `avg() : Decimal \| Quantity` | 7.5 | - | STU | New STU function. |

## 10.2 Reflection (Types and Reflection)

| Function | Section | N1 | R3 | Notes |
|----------|---------|-----|----|-------|
| `type() : collection` | 10.2.2 | STU | STU | *Editorial* — STU in both N1 and R3; minor description polishing. |

---

## Final Review Summary (R3 publication readiness)

### Functions with substantive additions (`✱`) — all new behavior is opt-in or STU-flagged

| Function | What was added | New behavior STU? |
| -------- | -------------- | ----------------- |
| `combine(other, [preserveOrder])` | Optional `preserveOrder : Boolean` parameter | The new parameter is STU; default behavior matches N1 |
| `iif(criterion, true-result, otherwise-result)` | Lambda semantics for `true-result` / `otherwise-result` (with `$this` set to input); explicit empty-input handling | Behavior is normative in R3 but builds on N1 short-circuit semantics — no compatible expression breaks |
| `toDate([format])` / `convertsToDate([format])` | Optional `format` parameter | The `format` parameter is STU |
| `toDateTime([format])` / `convertsToDateTime([format])` | Optional `format` parameter | The `format` parameter is STU |
| `matches(regex, [flags])` | Optional `flags` parameter (`i`, `m`) | The `flags` parameter is STU |
| `replaceMatches(regex, substitution, [flags])` | Optional `flags` parameter (`i`, `m`) | The `flags` parameter is STU |

### Notable clarifications / ambiguity resolutions (no marker — behavior matches N1 intent)

* **`subsetOf` / `supersetOf` / `distinct` / `isDistinct`** — explicitly anchor membership/equality on `=` returning `true` (so `false` and empty both indicate non-membership / non-duplicate). Eliminates a long-standing ambiguity around three-valued equality.
* **`repeat`** — adds an explicit input-queue/output-collection algorithm and confirms `$index` is undefined inside `repeat`.
* **`toQuantity([unit])`** — resolves an N1 contradiction (prose said result was `true`/`false` but signature was `Quantity`); R3 specifies the documented `Quantity`-or-empty result and references the new STU Unit Conversions section for the actual conversion rules.
* **String functions (`indexOf`, `substring`, `length`, `toChars`, `replace`)** — explicitly defined on Unicode scalar values (not bytes/UTF-16 code units). `substring` adds explicit rules for negative/zero `length` and out-of-range `start`.
* **Indexer / `single` / `first` / `last`** — return-type notation tightened from `: collection` to `: any` to reflect that at most one item is returned (no behavior change).
* **Lambda-typed parameter notation** (e.g. `($this, $index) => Boolean`) was applied to scoped functions (`exists`, `all`, `where`, `select`, `repeat`, `trace`, `iif`, `aggregate`). N1 already documented `$this`/`$index` access for `expression` parameters; the new notation is purely descriptive.

### Potentially breaking changes — **none detected in this functions review**

No function in this review changes observable behavior in a way that would silently break an N1-conformant expression:

* All new parameters are optional with the N1 default behavior preserved when omitted.
* All clarifications match N1's documented or strongly-implied behavior.
* The only behavioral spec change with potential implementation impact (`is`/`as` operator: empty input returns `false` instead of empty collection) is **on the operator form** (§6.3.1 / §6.3.3) and is tracked in [operations-review.md](operations-review.md). The function forms `is(type)` / `as(type)` (§6.3.2 / §6.3.4) are documented purely as backwards-compatibility wrappers and inherit the operator's behavior.

### Recommendation

The R3 column is consistent with a publication-ready specification: every change is either (a) STU-flagged, (b) a clarification of N1 intent, (c) an ambiguity resolution that does not contradict N1's documented behavior, or (d) a new optional parameter whose absence preserves N1 semantics. No functions in this review require additional STU flagging or breaking-change call-outs prior to R3 publication.


# Prompt used for final review pass (prior to manual review/cleanup)
We are in the final stages of preparing for the publication of the R3 release of the specification and would like to do one final pass reviewing the R3 column in this review document.
Not looking to update the functions.json file, just compare the definition of each function between the N1 specification, and the index.md definition.
For each function:
* read the normative definition (N1)
* read the current definition in index.md (R3)
* determine what has changed
    * new functions are just marked `STU`
    * is the change a clarification
    * is the change resolving an ambiguity
    * does the change introduce new feature(s) `✱`
    * is the change a breaking feature (flag these and explain - these should not exist)
