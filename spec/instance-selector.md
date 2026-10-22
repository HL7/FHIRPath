# Instance Selector

Add _instanceSelector_ and _listSelector_ rules to the grammar as follows:

```g4
term
        : invocation                                            #invocationTerm
        | literal                                               #literalTerm
        | externalConstant                                      #externalConstantTerm
        | instanceSelector                                      #instanceSelectorTerm
        | listSelector                                          #listSelectorTerm
        | '(' expression ')'                                    #parenthesizedTerm
        ;

instanceSelector
        : typeSpecifier? '{' (':' | (instanceElementSelector (',' instanceElementSelector)*)) '}'
        ;

instanceElementSelector
        : identifier ':' expression
        ;

listSelector
        : ('List' ('<' typeSpecifier '>')?)? '{' (expression (',' expression)*)? '}'
        ;
```

This would allow for the construction of instances of arbitrary types from models used by the language. For use with FHIR, this would enable:

```fhirpath
ValueSet.expansion.contains.select(Coding { system: system, version: version, code: code, display: display })

Identifier {
  use: 'usual',
  type: CodeableConcept {
    coding: {
      Coding {
        system: 'http://terminology.hl7.org/CodeSystem/v2-0203',
        code: 'MR',
        display: 'Medical Record Number'
      }
    },
    text: 'Medical Record Number'
  },
  system: 'http://hospital.smarthealthit.org',
  value: '1032702'
}

Date { year: 2012, month: 20, day: 10 }

DateTime { year: 2012, month: 20, day: 10, hour: 8, minute: 30, second: 0.0, offset: -5 }

Time { hour: 8, minute: 30, second: 0.0 }

Quantity { value: 87, unit: 'mm[Hg]' }

Quantity {
  value: 17.0,
  unit: 'g/dL',
  code: 'g/dL',
  system: 'http://unitsofmeasure.org'
}

Period {
  start: @2016-12-06,
  end: @2020-07-22
}

Range {
  low: Quantity {
    value: 16.5,
    unit: 'g/dL',
    code: 'g/dL',
    system: 'http://unitsofmeasure.org'
  },
  high: Quantity {
    value: 21.5,
    unit: 'g/dL',
    code: 'g/dL',
    system: 'http://unitsofmeasure.org'
  }
}

CodeableConcept { text: 'Laboratory' }
CodeableConcept {
  coding: {
    Coding {
      system: 'http://terminology.hl7.org/CodeSystem/observation-category',
      code: 'laboratory',
      display: 'Laboratory'
    }
  },
  text: 'Laboratory'
}

```

Note that to really make practical use of this with FHIR, the syntax allows for anonymous tuples and lists as well:

```fhirpath
{ 1, 2, 3, 4, 5 } // List of integers
List<String> { } // Empty list of strings

{
  low: Quantity {
    value: 16.5,
    unit: 'g/dL',
    code: 'g/dL',
    system: 'http://unitsofmeasure.org'
  },
  high: Quantity {
    value: 21.5,
    unit: 'g/dL',
    code: 'g/dL',
    system: 'http://unitsofmeasure.org'
  }
} // Anonymous tuple with low: Quantity, high: Quantity elements
```

And empty instances and tuples:

```fhirpath
{ : } // Empty anonymous tuple
Coding { : } // Empty Coding instance
```

The `:` ensures that the empty list selector `{ }` remains unambiguous (though this does require 1 look-ahead in the parser)

Construction of a Patient example (based on [US Core Patient Example](https://hl7.org/fhir/us/core/Patient-example.html), some elements omitted for brevity):

```fhirpath
Patient {
  id: 'example',
  meta: {
    extension: {
      Extension {
        url: 'http://hl7.org/fhir/StructureDefinition/instance-name',
        value: 'Patient Example'
      },
      Extension {
        url: 'http://hl7.org/fhir/StructureDefinition/instance-description',
        value: 'This is a patient example for the *US Core Patient Profile*.'
      }
    },
    profile: { 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient' }
  },
  extension: {
    Extension {
      url: 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-race',
      extension: {
        Extension: {
          url: 'ombCategory',
          value: Coding {
            system : 'urn:oid:2.16.840.1.113883.6.238',
            code : '2106-3',
            display : 'White'
          }
        },
        Extension: {
          url: 'ombCategory',
          value: Coding {
            'system' : 'urn:oid:2.16.840.1.113883.6.238',
            'code' : '2028-9',
            'display' : 'Asian'
          }
        },
        Extension: {
          url: 'text',
          value: 'Mixed'
        }
      }
    },
    Extension {
      url : 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-birthsex',
      value : 'F'
    }
  },
  identifier: {
    Identifier {
      use: 'usual',
      type: CodeableConcept {
        coding: {
          Coding {
            system: 'http://terminology.hl7.org/CodeSystem/v2-0203',
            code: 'MR',
            display: 'Medical Record Number'
          }
        },
        text: 'Medical Record Number'
      },
      system: 'http://hospital.smarthealthit.org',
      value: '1032702'
    }
  },
  active: true,
  name: {
    HumanName {
      family: 'Shaw',
      given: {
        'Amy',
        'V.'
      },
      period: Period {
        start: @2016-12-06,
        end: @2020-07-22
      }
    },
    HumanName {
      family: 'Baxter',
      given: {
        'Amy',
        'V.'
      },
      suffix: 'PharmD',
      period: Period {
        start: @2020-07-22
      }
    }
  },
  telecom: {
    ContactPoint {
      system: 'phone',
      value: '555-555-5555',
      use: 'home'
    },
    ContactPoint {
      system: 'email',
      value: 'amy.shaw@example.com'
    }
  },
  gender: 'female',
  birthDate: @1987-02-20,
  address: {
    Address {
      line: {
        '49 Meadow St'
      },
      city: 'Mounds',
      state: 'OK'
      postalCode: '74047',
      country: 'US',
      period: Period {
        start: @2016-12-06,
        end: @2020-07-22
      }
    },
    Address {
      line: {
        '183 Mountain View St'
      },
      city: 'Mounds',
      state: 'OK',
      postalCode: '74048',
      country: 'US',
      period: Period {
        start: @2020-07-22
      }
    }
  }
}
```

Construction of an Observation example (based on [US Core Hemoglobin Example](https://hl7.org/fhir/us/core/Observation-hemoglobin.html)):

```fhirpath
Observation {
  id: 'hemoglobin',
  meta: {
    extension: {
      Extension {
        url: 'http://hl7.org/fhir/StructureDefinition/instance-name',
        value: 'Hemoglobin Example'
      },
      Extension {
        url: 'http://hl7.org/fhir/StructureDefinition/instance-description',
        value: 'This is a hemoglobin example for the *US Core Observation Lab Profile*.'
      }
    },
    profile: {
      'http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-lab'
    }
  },
  status: 'final',
  category: {
    CodeableConcept {
      coding: {
        Coding {
          system: 'http://terminology.hl7.org/CodeSystem/observation-category',
          code: 'laboratory',
          display: 'Laboratory'
        }
      },
      text: 'Laboratory'
    }
  },
  code: CodeableConcept {
    coding: {
      Coding {
        system: 'http://loinc.org',
        code: '718-7',
        display: 'Hgb Bld-mCnc'
      }
    },
    text: 'Hgb Bld-mCnc'
  },
  subject: Reference {
    reference: 'Patient/example',
    display: 'Amy Shaw'
  },
  effective: @2005-07-05,
  value: Quantity {
    value: 17.0,
    unit: 'g/dL',
    code: 'g/dL',
    system: 'http://unitsofmeasure.org'
  },
  referenceRange: {
    {
      low: Quantity {
        value: 16.5,
        unit: 'g/dL',
        code: 'g/dL',
        system: 'http://unitsofmeasure.org'
      },
      high: Quantity {
        value: 21.5,
        unit: 'g/dL',
        code: 'g/dL',
        system: 'http://unitsofmeasure.org'
      },
      appliesTo: {
        CodeableConcept {
          coding: {
            Coding {
              system: 'http://terminology.hl7.org/CodeSystem/referencerange-meaning',
              code: 'normal',
              display: 'Normal Range'
            }
          },
          text: 'Normal Range'
        }
      }
    }
  }
}
```
