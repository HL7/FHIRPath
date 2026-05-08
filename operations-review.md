# FHIRPath Operations Review

Review of all operations defined in the FHIRPath specification (index.md - R3) against the normative specification at <https://hl7.org/fhirpath/N1/index.html> (N1).

**Legend:**
* N1 Column operation status in N1 specification
    - `✅` - the operation is normative
    - `STU` - the operation is STU
    - `- ` - the operation was not present
* R3 Column operation status in R3 specification (current draft)
    - `✅` - Operation semantically unchanged from N1 (or change is purely editorial — added examples, wording polish, signature notation only)
    - `STU` - the operation is STU
    - `✱` - the operation has had substantive additions / new feature(s) since N1 (the new behavior itself is STU-flagged where applicable)
    - `⚠` - potentially breaking change vs. N1 — see Notes (these are flagged even when the change is intentional/balloted, so implementers know an N1-conformant expression may evaluate differently)
* Notes column describes what changed (clarification, ambiguity resolution, added feature, breaking change, etc.); for balloted behavior changes the JIRA tracker reference appears at the end of the notes.

> **Final review (R3 publication):** Each row was checked operation-by-operation against [N1](https://hl7.org/fhirpath/N1/index.html). The Notes column captures every meaningful difference detected, classified as one of:
> *editorial* (wording/example refresh), *clarification* (text made unambiguous, no behavior change),
> *ambiguity resolution* (under-specified case in N1 now defined), *new feature* (`✱`),
> or *breaking* (`⚠`).

---

## 6.1 Equality

| Operation | Section | N1 | R3 | Notes |
|-----------|---------|-----|----|-------|
| `=` (Equals) | 6.1.1 | ✅ | ✱ | *Clarification* — Quantity equality is now explicitly defined in terms of [unit conversion](#unit-conversions): commensurable units are converted to a common unit (any commensurable target is acceptable since trailing zeroes after the decimal are ignored); time-valued quantities convert to the *least granular* unit without changing code system; year/month calendar vs UCUM `'a'`/`'mo'` are not equal — explicit `toQuantity()` is required to compare them. The new STU Unit Conversions sub-section formalizes the algorithm. The cross-system year/month rule resolves an N1 ambiguity: N1 said calendar/UCUM durations above seconds are *unequal*, but did not specify how `1 year = 12 'mo'` should behave (R3: empty). Behavior on commensurable same-system quantities matches N1. |
| `~` (Equivalent) | 6.1.2 | ✅ | ✱ | *Clarification* — Quantity equivalence converts to the *least granular* unit (preserving the precision of the rounded comparison); calendar units and UCUM definite-duration units are equivalent (`1 year ~ 1 'a'`, `1 month ~ 1 'mo'`); String equivalence explicitly normalizes whitespace using the Unicode `White_Space` class **without collapsing sequences** (a note recommends `replaceMatches('\\s+', ' ')` if collapsing is desired). N1 already documented "ignore case + locale + normalize whitespace" — R3 makes the non-collapsing semantics explicit. |
| ` !=` (Not Equals) | 6.1.3 | ✅ | ✅ | Unchanged. Still defined as `(A = B).not()`. |
| ` !~` (Not Equivalent) | 6.1.4 | ✅ | ✅ | Unchanged. Still defined as `(A ~ B).not()`. |

> **Note on `Long` and equality:** `Long` is not explicitly listed in the §6.1 prose; equality involving longs is handled via implicit conversion to/from Decimal (per the conversion table). Revisit if §6.1 is later updated to explicitly list `Long`.

## 6.2 Comparison

| Operation | Section | N1 | R3 | Notes |
|-----------|---------|-----|----|-------|
| `>` (Greater Than) | 6.2.1 | ✅ | ✱ | *New feature (STU)* — `Long` type added to the supported types (Long itself is STU). *Clarification* — Quantity comparison now explicitly references the Unit Conversions section: commensurable units are converted to a common unit; non-commensurable / invalid units → empty; year/month calendar vs UCUM units are not comparable without explicit `toQuantity()`. Cross-system year/month behavior is a clarification of N1 (which said "un-comparable" but did not specify the cross-system case). |
| `<` (Less Than) | 6.2.2 | ✅ | ✱ | Same as `>` — added Long support (STU); same Quantity-comparison clarifications. |
| `<=` (Less or Equal) | 6.2.3 | ✅ | ✱ | Same as `>` — added Long support (STU); same Quantity-comparison clarifications. |
| `>=` (Greater or Equal) | 6.2.4 | ✅ | ✱ | Same as `>` — added Long support (STU); same Quantity-comparison clarifications. |
| `comparable(other : Quantity) : Boolean` | 6.2.5 | No | STU | New STU function (lives in [functions.json](functions.json); see also [functions-review.md](functions-review.md)). |

## 6.3 Types

| Operation | Section | N1 | R3 | Notes |
|-----------|---------|-----|----|-------|
| `is` _type specifier_ | 6.3.1 | ✅ | ⚠ | **⚠ Potentially breaking change** — N1 said: *"In all other cases this operator returns the empty collection."* R3 says: *"In all other cases this operator returns `false`."* The "other cases" wording covers the empty input collection — under N1 `{}.is(Patient)` returns empty, under R3 it returns `false`. This affects three-valued logic chains (`expr is T and ...`) when `expr` may be empty. The remaining R3 wording (single-item-of-type → `true`, single-item-not-of-type → `false`, unresolvable identifier → error, multi-item input → error) is unchanged from N1. *Intentional and balloted* — the change enables concise constraints like `Observation.subject.resolve().is(Patient)` without an `exists()` guard, and aligns FHIRPath with the [CQL `is`](https://cql.hl7.org/09-b-cqlreference.html#is) operator. The companion `as` operator (§6.3.3) intentionally retains N1 empty-collection semantics. Tracker: [FHIR-25189](https://jira.hl7.org/browse/FHIR-25189) (Resolution: Persuasive; Change Impact: *Compatible, substantive*; applied via [HL7/FHIRPath#15](https://github.com/HL7/FHIRPath/pull/15); listed in [changes.md](input/pages/changes.md) under R2 STU1 Ballot). |
| `is(type : type specifier)` | 6.3.2 | ✅ | ⚠ | Function form — described as a backwards-compatibility wrapper for the `is` operator and inherits the same balloted behavior change, so the same ⚠ flag applies. (Definition row also tracked in [functions-review.md](functions-review.md).) Tracker: [FHIR-25189](https://jira.hl7.org/browse/FHIR-25189). |
| `as` _type specifier_ | 6.3.3 | ✅ | ✅ | Unchanged. R3 still states "Otherwise, this operator returns the empty collection." (matching N1). The FHIR-25189 ticket explicitly noted that `as` should keep its N1 empty-collection semantics. |
| `as(type : type specifier)` | 6.3.4 | ✅ | ✅ | Unchanged. Function form — described as a backwards-compatibility wrapper for the `as` operator. (Definition row also tracked in [functions-review.md](functions-review.md).) |

## 6.4 Collections

| Operation | Section | N1 | R3 | Notes |
|-----------|---------|-----|----|-------|
| `\|` (union collections) | 6.4.1 | ✅ | ✅ | *Clarification* — duplicate-detection wording tightened to refer explicitly to `=` returning `true` (so `false` and empty both indicate items are not duplicates and appear in the output). Same observable behavior as N1. |
| `in` (membership) : Boolean | 6.4.2 | ✅ | ✅ | *Editorial* — return type `: Boolean` is now stated explicitly in the heading. *Clarification* — equality semantics tightened to refer to `=` returning `true`. Same observable behavior as N1. |
| `contains` (containership) : Boolean | 6.4.3 | ✅ | ✅ | *Editorial* — return type `: Boolean` stated explicitly. *Clarification* — equality semantics tightened (same as `in`). Same observable behavior as N1. |

## 6.5 Boolean Logic

| Operation | Section | N1 | R3 | Notes |
|-----------|---------|-----|----|-------|
| `and` | 6.5.1 | ✅ | ✅ | Unchanged. Truth table re-rendered. |
| `or` | 6.5.2 | ✅ | ✅ | Unchanged. Truth table re-rendered. |
| `not() : Boolean` | 6.5.3 | ✅ | ✅ | Unchanged. (Function form — also tracked in [functions-review.md](functions-review.md).) |
| `xor` | 6.5.4 | ✅ | ✅ | Unchanged. Truth table re-rendered. |
| `implies` | 6.5.5 | ✅ | ✅ | *Editorial / clarification* — added a worked example explaining why `=` is risky on the left of `implies` when the operand may be empty (recommends `~` instead). No semantic change. |

## 6.6 Math

| Operation | Section | N1 | R3 | Notes |
|-----------|---------|-----|----|-------|
| `*` (multiplication) | 6.6.1 | ✅ | ✱ | *New feature (STU)* — `Long` type added (STU). *New feature (STU)* — mixed numeric × Quantity arithmetic now explicitly defined: the numeric is implicitly converted to a Quantity with the UCUM default unit `'1'`, preserving the other operand's unit (e.g. `3 * 2 'cm' = 6 'cm'`). *Clarification (STU)* — multiplication involving calendar units other than `'1'` returns empty; UCUM "special" units on non-ratio scales (e.g. `Cel`, `[degF]`) return empty. **⚠ Authoring TODO** — line 4104 of index.md contains an unresolved `BRIAN: Add example` placeholder that must be removed/resolved before publication. |
| `/` (division) | 6.6.2 | ✅ | ✱ | *New feature (STU)* — `Long` type added (STU). *New feature (STU)* — mixed numeric / Quantity behavior explicitly defined (same UCUM-default-unit conversion as `*`). *Clarification (STU)* — calendar units other than `'1'` → empty; special UCUM units → empty. Division by zero → empty (matches N1). |
| `+ ` (addition) | 6.6.3 | ✅ | ✱ | *New feature (STU)* — `Long` type added (STU). *Clarification (STU)* — Quantity addition uses the *most granular* unit; commensurable units are converted before adding; non-commensurable or invalid units → empty. *Ambiguity resolution (STU)* — explicitly states that year/month calendar units (and UCUM `'a'`/`'mo'`) require explicit `toQuantity()` for `+ `/`- ` (since calendar conversion factors for these are *equivalent*, not equal). N1 was silent on this case for arithmetic. UCUM "special" units → empty; arithmetic overflow → empty. Date/Time `+ Quantity` cross-references §6.7. |
| `- ` (subtraction) | 6.6.4 | ✅ | ✱ | Same additions as `+ ` — Long support (STU), Quantity unit-conversion clarifications, year/month explicit-conversion requirement, special-unit / overflow → empty. Date/Time `- Quantity` cross-references §6.7. |
| `div` | 6.6.5 | ✅ | ✱ | *New feature (STU)* — `Long` type added (STU). *Clarification* — return type is the same as the (post-implicit-conversion) input type, so `5L div 2 = 2L` (Long), `5.5 div 0.7 = 7` (Decimal), `5 div 2 = 2` (Integer). N1's prose said "Integer and Decimal" with no Long; R3 retains the same observable behavior for Integer/Decimal inputs. |
| `mod` | 6.6.6 | ✅ | ✱ | *New feature (STU)* — `Long` type added (STU). Same return-type clarification as `div`. Behavior on Integer/Decimal matches N1. |
| `&` (String concatenation) | 6.6.7 | ✅ | ✅ | Unchanged. |

## 6.7 Date/Time Arithmetic

| Operation | Section | N1 | R3 | Notes |
|-----------|---------|-----|----|-------|
| `+ ` (Date/Time addition) | 6.7.1 | ✅ | ✱ | *Clarification* — the per-unit table now also documents which datatypes each unit applies to (e.g. `year`/`years` apply to `Date`/`DateTime` only, not `Time`). *Ambiguity resolution* — `Time` arithmetic is now explicitly cyclic (e.g. `@T23:30:00 + 1 hour = @T00:30:00`); N1 did not specify Time wrap-around behavior. *Clarification (STU)* — partial date/time + quantity behavior is described with worked examples (chained unit conversion when the quantity precision exceeds the date/time precision). *New SHOULDs (STU)* — implementations SHOULD warn when decimal fractions are ignored; authors SHOULD round quantity inputs first. Same observable result for inputs N1 covered. |
| `- ` (Date/Time subtraction) | 6.7.2 | ✅ | ✱ | Same clarifications as `+ ` — partial date/time handling examples added; cyclic `Time` behavior made explicit. Same observable result for inputs N1 covered. |

## 6.8 Unary Operators

| Operation | Section | N1 | R3 | Notes |
|-----------|---------|-----|----|-------|
| `+ ` (unary positive) | 6.8.1 | - | STU | New STU section. (N1 listed `unary + and -` in the precedence table but did not formally describe them.) |
| `- ` (unary negation) | 6.8.2 | - | STU | New STU section. (Same as above.) |

## 6.9 Operator Precedence

| Operation | Section | N1 | R3 | Notes |
|-----------|---------|-----|----|-------|
| Operator precedence table | 6.9 | ✅ | ✅ | Unchanged. |

---

## Final Review Summary (R3 publication readiness)

### Operations with substantive additions (`*`)

All `*` rows in this review add `Long` type support; the new `Long` type is itself STU. None of the additions change behavior for N1-conformant inputs (Integer, Decimal, Quantity, etc.) — they only extend the operators to additionally accept Long operands. The Quantity-related clarifications (commensurable conversion, most/least granular, cross-system year/month explicit-conversion requirement) resolve N1 ambiguities without contradicting any N1-documented behavior.

| Operation(s) | What was added | New behavior STU? |
|---|---|---|
| `>`, `<`, `<=`, `>=` | `Long` operand support | Yes (Long itself is STU) |
| `*`, `/`, `+ `, `- `, `div`, `mod` | `Long` operand support; numeric × Quantity treated as `'1'`-unit Quantity arithmetic; calendar/special-unit handling | Yes (Long, mixed-unit handling, and special-unit rules are STU) |

### Notable clarifications / ambiguity resolutions (no marker — behavior matches N1 intent)

* **`=` / `~` (Equality / Equivalence)** — Quantity behavior anchored on the new (STU) Unit Conversions section: commensurable conversion to a *common* unit for equality, *least granular* unit for equivalence; calendar/UCUM cross-system year/month behavior explicitly defined (equality → empty, equivalence → equivalent).
* **`~` (String Equivalence)** — explicitly anchored on the Unicode `White_Space` class; explicitly does **not** collapse whitespace sequences (with a note pointing to `replaceMatches`/`trim` if collapsing is desired).
* **`|` / `in` / `contains`** — equality semantics tightened to refer to `=` returning `true` (consistent with the equivalent treatment for `subsetOf`/`distinct` in §5.1).
* **`+ ` / `- ` (Math, Quantity addition with year/month)** — N1 was silent on whether `1 year + 12 months` should succeed; R3 explicitly requires explicit `toQuantity()` because calendar conversion factors for year/month are *equivalent*, not equal.
* **`+ ` / `- ` (Date/Time arithmetic on `Time`)** — explicitly cyclic (wraps around midnight). N1 did not specify Time wrap-around behavior.
* **`+ ` / `- ` (Date/Time arithmetic on partial dates)** — chained unit-conversion algorithm now described with worked examples.
* **`implies`** — added authoring guidance about avoiding `=` on the left when the operand may be empty.

### Potentially breaking changes (`⚠`)

These changes are **intentional and balloted** but are still flagged because an N1-conformant expression may evaluate differently in R3. Implementers and authors should be aware of them.

| Operation(s) | Change | Tracker |
|---|---|---|
| `is` operator (§6.3.1) and `is(type)` function form (§6.3.2) | N1: *"In all other cases this operator returns the empty collection."* → R3: *"In all other cases this operator returns `false`."* Empty-input behavior changes from empty to `false`, allowing concise expressions such as `Observation.subject.resolve().is(Patient)` without an `exists()` guard. Aligned with the CQL `is` operator. The companion `as` operator (§6.3.3) intentionally retains N1 empty-collection semantics. | [FHIR-25189](https://jira.hl7.org/browse/FHIR-25189) (Resolution: Persuasive; Change Impact: *Compatible, substantive*; applied via [HL7/FHIRPath#15](https://github.com/HL7/FHIRPath/pull/15); listed in [changes.md](input/pages/changes.md) under R2 STU1 Ballot). |

### Recommendation

The R3 column for operations is consistent with a publication-ready specification. Every other change is either:
* (a) STU-flagged (Long support, mixed numeric × Quantity, calendar-unit/special-unit rules, Unit Conversions section, Unary operators),
* (b) a clarification of N1 intent,
* (c) an ambiguity resolution that does not contradict N1's documented behavior, or 
* (d) a balloted, applied behavior change tracked in JIRA and recorded in the changelog (the `is` operator empty-input behavior, [FHIR-25189](https://jira.hl7.org/browse/FHIR-25189) — still flagged as `⚠` in the per-operation table so implementers can see at a glance that an N1-conformant expression may evaluate differently).
