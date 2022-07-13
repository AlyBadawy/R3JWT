/* eslint-disable no-undef */
/* eslint-disable @typescript-eslint/naming-convention */

/** @type {import('ts-jest/dist/types').InitialOptionsTsJest} */

module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'jsdom',
  globals: {
    'ts-jest': {
      tsconfig: './tsconfig.json',
    },
  },
  setupFilesAfterEnv: ['./react-src/jest/jest.setup.ts'],
};
