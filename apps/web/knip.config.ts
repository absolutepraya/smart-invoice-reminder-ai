import type { KnipConfig } from 'knip'

const config: KnipConfig = {
  $schema: 'https://unpkg.com/knip@5/schema.json',

  ignoreExportsUsedInFile: true,
  includeEntryExports: false,

  ignore: [
    '**/*.d.ts',
    '**/dist/**',
    '**/build/**',
    '**/node_modules/**',
    '**/coverage/**',
    'src/routeTree.gen.ts',
  ],

  entry: [
    'src/main.tsx!',
    'src/routes/**/*.tsx!',
  ],

  project: [
    'src/**/*.{ts,tsx}',
    '!src/**/*.test.{ts,tsx}',
    '!src/**/*.spec.{ts,tsx}',
  ],

  vitest: true,

  paths: {
    '@/*': ['./src/*'],
  },

  rules: {
    files: 'error',
    dependencies: 'error',
    devDependencies: 'error',
    optionalPeerDependencies: 'off',
    unlisted: 'error',
    binaries: 'error',
    unresolved: 'error',
    exports: 'error',
    types: 'error',
    nsExports: 'error',
    nsTypes: 'error',
    duplicates: 'error',
  },
}

export default config
