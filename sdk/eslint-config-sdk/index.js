const js = require("@eslint/js");
const prettier = require("eslint-config-prettier/flat");
const simpleImportSort = require("eslint-plugin-simple-import-sort");
const globals = require("globals");
const tseslint = require("typescript-eslint");

/** shared ESLint flat config; use it as `module.exports = require("eslint-config-sdk");` in eslint.config.js */
module.exports = [
  {
    ignores: [".next/**", "coverage/**", "dist/**", "e2e-test-report/**", "jest.config.js", "node_modules/**"],
  },
  js.configs.recommended,
  ...tseslint.configs.recommended,
  prettier,
  {
    languageOptions: {
      ecmaVersion: "latest",
      sourceType: "module",
      globals: {
        ...globals.es2021,
        ...globals.jest,
        ...globals.node,
      },
    },
    plugins: {
      "simple-import-sort": simpleImportSort,
    },
    rules: {
      "simple-import-sort/imports": "error",
      "simple-import-sort/exports": "error",
    },
  },
];
