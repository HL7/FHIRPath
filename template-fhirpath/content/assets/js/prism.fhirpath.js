/** prism.fhirpath.js */
// Script to perform syntax highlighting of the FHIRPath grammar
// https://prismjs.com/extending.html#language-definitions
Prism.languages["fhirpath"] = {
  property: {
    pattern: /(^|[^\\])`(?:\\.|[^\\`\r\n])*`(?=\s*:)/,
    lookbehind: true,
    greedy: true,
  },
  string: {
    pattern: /(^|[^\\])'(?:\\.|[^\\'\r\n])*'(?!\s*:)/,
    lookbehind: true,
    greedy: true,
  },
  comment: {
    pattern: /\/\/.*|\/\*[\s\S]*?(?:\*\/|$)/,
    greedy: true,
  },
  number: /-?\b\d+(?:\.\d+)?(?:e[+-]?\d+)?\b/i,
  punctuation: /[{}[\],]/,
  operator: /:/,
  boolean: /\b(?:false|true)\b/,
  null: {
    pattern: /\bnull\b/,
    alias: "keyword",
  },
};
