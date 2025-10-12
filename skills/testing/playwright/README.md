# Playwright Atomic Test Generator

A command-line tool for generating atomic test templates following the one-action-per-test principle with proper test.step() structure.

## Quick Start

```bash
# Make sure the script is executable
chmod +x atomic-test-generator

# Generate a single test
./atomic-test-generator --feature login --action "user authentication"

# Generate multiple tests
./atomic-test-generator -f navigation -a "menu navigation" -c 3

# Generate tests in specific directory
./atomic-test-generator --feature search --action "product search" --count 2 --output ./tests/search
```

## Features

- ✅ Atomic test structure (one action per test)
- ✅ Proper test.step() organization (Setup/Action/Verification)
- ✅ Auto-generated test case IDs (tc-001, tc-002, etc.)
- ✅ Descriptive file naming (feature-action.spec.ts)
- ✅ TypeScript/Playwright syntax support
- ✅ CLI interface with helpful documentation
- ✅ Colored output for better readability
- ✅ Error handling and validation

## Generated Test Structure

```typescript
import { test, expect } from '@playwright/test';

test.describe('feature-area', () => {
  test('should perform action with expected outcome tc-001', async ({ page }) => {
    await test.step('Setup: Navigate to page', async () => {
      await page.goto('https://example.com');
    });

    await test.step('Action: Perform user interaction', async () => {
      // TODO: Add specific interaction
    });

    await test.step('Verification: Check expected result', async () => {
      // TODO: Add specific assertion
    });
  });
});
```

## Command Line Options

- `-f, --feature <name>` - Feature area name (required)
- `-a, --action <description>` - Action description for test case (required)
- `-c, --count <number>` - Number of test cases to generate (default: 1)
- `-o, --output <dir>` - Output directory (default: current directory)
- `-h, --help` - Show help message

## Examples

```bash
# Single test for login functionality
./atomic-test-generator --feature login --action "user login with valid credentials"

# Multiple search tests
./atomic-test-generator -f search -a "product search" -c 3

# Tests in specific directory
./atomic-test-generator --feature checkout --action "payment processing" --output ./tests/e2e/checkout
```

## File Naming Convention

Files are generated using the pattern: `<feature>-<action>.spec.ts`

- Spaces and special characters are converted to hyphens
- For multiple tests: `<feature>-<action>-1.spec.ts`, `<feature>-<action>-2.spec.ts`, etc.

## Next Steps After Generation

1. Update the `page.goto()` URL to your target application
2. Replace TODO comments with actual test implementation
3. Add specific assertions for your test scenario
4. Configure test data and test environment