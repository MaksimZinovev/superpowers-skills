# Playwright Testing Detailed Reference

## Test Structure Requirements

1. **Always use test.step()** for organizing test actions into clear, logical phases
2. **Structure tests with Setup, Action, and Verification phases**
3. **Use descriptive, user-focused test names** that clearly state the expected outcome
4. **Implement proper waits and assertions** using Playwright's built-in mechanisms
5. **Include visual-only tests** - for each page, at least one test that checks only the visual aspect without interacting with the page
6. **Cover both positive and negative scenarios** with meaningful assertions
7. **Follow single responsibility principle** - one scenario per test

## Test File Organization

- **Imports**: Start with `import { test, expect } from '@playwright/test';`
- **Organization**: Group related tests for a feature under a `test.describe()` block
- **Hooks**: Use `beforeEach` for setup actions common to all tests in a `describe` block (e.g., navigating to a page)
- **Titles**: Follow clear naming convention, such as `feature - specific action or scenario`
- **Location**: Store all test files in the `tests/` directory
- **Naming**: Use `<feature-or-page>.spec.ts` format (e.g., `login.spec.ts`, `search.spec.ts`)
- **Scope**: Aim for one test file per major application feature or page

## Assertion Best Practices

| Purpose | Best Assertion | Example |
|---------|----------------|---------|
| **UI Structure** | `toMatchAriaSnapshot()` | `await expect(page.locator('.header')).toMatchAriaSnapshot();` |
| **Element Counts** | `toHaveCount()` | `await expect(page.locator('.item')).toHaveCount(3);` |
| **Text Content** | `toHaveText()` for exact, `toContainText()` for partial | `await expect(page.locator('.title')).toHaveText('Welcome');` |
| **Navigation** | `toHaveURL()` | `await expect(page).toHaveURL(/dashboard/);` |
| **Visibility** | `toBeVisible()` (only for visibility changes) | `await expect(page.locator('.modal')).toBeVisible();` |
| **Presence** | `toBeAttached()` | `await expect(page.locator('.dynamic')).toBeAttached();` |

## Filtering Locators Approach

When dealing with strict mode violations, use the "filtering locators" approach that prioritizes user-facing attributes and explicit contracts:

**Step-by-step approach:**
1. Use 'naive' approach with getByRole(), getByLabel(), getByText() following best practices
2. Target nearest parent element with filtering
3. Combine results to get unique locator
4. Verify by running the test
5. As last resort, use .first(), .last(), or .nth() methods

**Practical Example - SCOOLENDAR element:**

```typescript
// Step 1: Use 'naive' approach prioritizing user-facing attributes
page.getByText("SCOOLENDAR")

// Step 2: Target nearest parent element
page.locator('section').filter({hasText: /smart and cool calendar/i})

// Step 3: Combine results for unique locator
page.locator('section').filter({hasText: /smart and cool calendar/i}).getByText("SCOOLENDAR")

// Step 4: Verify by running the test
await expect(page.locator('section')
  .filter({hasText: /smart and cool calendar/i})
  .getByText("SCOOLENDAR")).toBeVisible();

// Step 5: If filtering fails, read the guide and follow recommendations
```

**Common strict mode violation fixes:**
```typescript
// ❌ BAD: Ambiguous selector, resolves to 2 elements
await expect(page.locator('p:has-text("SCOOLENDAR")')).toBeVisible();

// ❌ BAD: Relies on DOM structure
await expect(page.locator('p.home_header_title:has-text("SCOOLENDAR")')).toBeVisible();

// ❌ BAD: .first() is not robust - order can change
await expect(page.locator('p:has-text("SCOOLENDAR")').first()).toBeVisible();

// ✅ GOOD: Filtering locators approach
await expect(page.locator('section')
  .filter({hasText: /smart and cool calendar/i})
  .getByText("SCOOLENDAR")).toBeVisible();
```

**Official documentation:**
- [Playwright Locators Guide](https://playwright.dev/docs/locators#locating-elements)
- [Playwright Locators Quick Guide](https://playwright.dev/docs/locators#quick-guide)

## MCP Usage Guidelines

### When to Use MCP Browser Tools

**Use MCP for:**
- **Page structure discovery** - Before writing any test
- **Element validation** - Verify selectors actually exist
- **Complex interaction testing** - Multi-step flows that are hard to script
- **Dynamic content behavior** - See how elements load/change
- **Visual testing** - Screenshots and layout verification

**Don't use MCP for:**
- Simple static pages with known structure
- Performance-critical test suites
- When direct Playwright API is sufficient

### MCP Workflow Pattern

```typescript
// 1. Discovery Phase (use MCP)
await mcp__playwright__browser_navigate('https://scoolendar.com/');
await mcp__playwright__browser_snapshot();
// Document findings: preloader, form labels, navigation structure

// 2. Test Creation Phase (use Playwright API)
test('should handle registration form tc-005', async ({ page }) => {
  await test.step('Navigate to registration', async () => {
    await page.goto('https://scoolendar.com/');
    await page.getByRole('link', { name: 'Get Started Now' }).click();
  });

  await test.step('Verify form fields', async () => {
    await expect(page.getByLabel('First name')).toBeVisible();
    // Only test ONE field per atomic test
  });
});

// 3. Validation Phase (use MCP if test fails)
if (testFails) {
  await mcp__playwright__browser_navigate('https://scoolendar.com/register');
  await mcp__playwright__browser_snapshot();
  // Debug why selector doesn't match
}
```

### MCP Commands Reference

| MCP Command | When to Use | What it Returns |
|-------------|-------------|-----------------|
| `mcp__playwright__browser_navigate()` | Initial page exploration | Page load status |
| `mcp__playwright__browser_snapshot()` | Element discovery | Accessibility tree |
| `mcp__playwright__browser_click()` | Complex interaction testing | Action result |
| `mcp__playwright__browser_take_screenshot()` | Visual validation | Screenshot file |

## Code Quality Standards

- **Write clean, readable TypeScript code** following the project's formatting standards
- **Use meaningful variable names** and add comments when necessary
- **Include proper error handling** and retry mechanisms where needed
- **Ensure tests are independent** and can run in any order
- **Follow accessibility best practices** in selector choices
- **Use auto-retrying web-first assertions** - start with `await` keyword
- **Avoid hard-coded waits** - rely on Playwright's built-in auto-waiting mechanisms
- **Use descriptive test and step titles** (all lowercase) that clearly state the intent