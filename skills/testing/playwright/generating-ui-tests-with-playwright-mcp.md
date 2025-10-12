---
name: Playwright Atomic Testing
description: Atomic approach to reliable UI test creation - explore, validate, build incrementally
when_to_use: When tests fail with strict mode violations, agents make wrong assumptions about page structure, tests are too complex and hard to maintain, registration forms or dynamic content cause timeouts, multiple test steps make debugging difficult
version: 1.0.0
languages: [typescript, javascript]
dependencies: [@playwright/test, playwright MCP server, atomic-test-generator]
---

# Playwright Atomic Testing

## Overview

**Atomic test creation beats comprehensive complexity.** Build incrementally: 1-2 actions/assertions per test, verify each works, never assume page structure without exploration.

## When to Use

**Use when:**
- Tests fail with "strict mode violation" errors
- Registration forms have unexpected labels/structure
- Navigation elements need complex workarounds
- Tests timeout waiting for assumed elements
- Multiple test steps make debugging impossible
- Tests use `page.goto()` repeatedly to reset state

**Don't use when:**
- Simple static pages with known structure
- Tests already passing reliably
- No MCP server available

## Core Pattern

**Before (Agent Under Pressure):**
```typescript
// ❌ Complex test with assumptions
test("should validate home page navigation and functionality", async ({ page }) => {
  await page.goto("https://scoolendar.com/");
  // 20+ lines of complex interactions
  await expect(page.getByLabel("First name")).toBeVisible(); // FAILS - wrong assumption
});
```

**After (Atomic Approach):**
```typescript
// ✅ Single action, single assertion
test("should navigate to home page tc-001", async ({ page }) => {
  await test.step("Navigate and verify URL", async () => {
    await page.goto("https://scoolendar.com/");
    await expect(page).toHaveURL(/scoolendar\.com/);
  });
});
```

## Quick Reference

| Situation | Atomic Approach | Common Pitfall |
|-----------|----------------|----------------|
| **Page exploration** | Use MCP to discover structure first | Assume elements exist |
| **Form testing** | Test one field per test | Test entire form at once |
| **Navigation** | One click per test, verify URL | Complex multi-step flows |
| **Strict violations** | Use filtering locators approach | Use ambiguous selectors |
| **Timeout issues** | Add specific waits for dynamic content | Use arbitrary timeouts |
| **Test scaffolding** | Use atomic-test-generator script | Manual template creation |

## Implementation

### Step 1: Explore Before Testing
Use MCP to understand page structure before writing any tests. Document actual elements found.

### Step 2: Create Minimal Viable Test
Start with absolute minimum - navigate and verify basic functionality. Run test after each change.

**Quick Start:** Use the atomic-test-generator tool to scaffold proper test structure:
```bash
./atomic-test-generator --feature <feature-name> --action "<action-description>"
```
This creates atomic test templates with proper test.step() organization and tc-XXX IDs.

### Step 3: Build Incrementally
Add ONE action/assertion at a time. Stop after 2 failures or 1 minute of troubleshooting.

### Step 4: Handle Strict Mode Violations
Use filtering locators approach. Create unique selectors by combining parent element filtering with text-based selection.

### Step 5: Use Web-First Assertions
Prioritize `getByRole()`, `getByLabel()`, `getByText()` over CSS selectors. Use auto-retrying assertions, not hard-coded waits.

**Tool: Atomic Test Generator**
Use the `atomic-test-generator` script to quickly scaffold atomic test templates:
```bash
# Generate single test
./atomic-test-generator --feature login --action "user authentication"

# Generate multiple tests
./atomic-test-generator -f navigation -a "menu navigation" -c 3

# Generate tests in specific directory
./atomic-test-generator --feature search --action "product search" --count 2 --output ./tests/search
```

**See `/Users/maksim/.config/superpowers/skills/testing/playwright/detailed-reference.md` for complete code examples and best practices.**

## Common Mistakes

| Mistake | Why it happens | Fix |
|---------|----------------|-----|
| **Assuming form labels** | "First name" seems standard | Use MCP to verify actual labels |
| **Complex workarounds** | Navigation toggle doesn't work | Test simple interactions first |
| **Not using filtering()** | Causes strict mode violation | Use filtering locators approach |
| **Repeated page.goto()** | Easy state reset | Use test isolation instead |
| **Long test steps** | "Comprehensive" mindset | One specific action per step |
| **Manual templates** | Creating boilerplate repeatedly | Use atomic-test-generator script |

## Red Flags - STOP and Start Over

- Writing "comprehensive test" with multiple scenarios
- Using `page.goto()` to reset state between test steps
- Creating complex fallback logic for element selection
- Assuming form labels without MCP exploration
- Writing tests with more than 2 actions/assertions per step

**All of these mean: Delete the test. Start over with atomic approach.**

## Rationalization Counter

| Excuse | Reality | Atomic Approach |
|--------|---------|-----------------|
| "I need comprehensive test coverage" | Complex tests hide failures and are impossible to debug | Build coverage incrementally: one working test at a time |
| "First name is standard label" | Pages have custom implementations - verify with MCP first | Use MCP to explore actual form structure before testing |
| "Tests pass locally, fail in CI" | Different load times and race conditions | Handle dynamic content explicitly with proper waits |
| "Strict mode violation is just a warning" | It's a test failure - multiple elements match your selector | Use filtering locators approach to create unique selectors |
| "Creating templates manually is faster" | Manual creation leads to inconsistent structure and missed steps | Use atomic-test-generator for consistent, proper structure |

## Skill Creation Checklist (TDD Adapted)

**IMPORTANT: Use TodoWrite to create todos for EACH checklist item below.**

**RED Phase - Write Failing Test:**
- [x] Create pressure scenarios (3+ combined pressures for discipline skills)
- [x] Run scenarios WITHOUT skill - document baseline behavior verbatim
- [x] Identify patterns in rationalizations/failures

**GREEN Phase - Write Minimal Skill:**
- [ ] Name describes what you DO or core insight
- [ ] YAML frontmatter with rich when_to_use (include symptoms!)
- [ ] Keywords throughout for search (errors, symptoms, tools)
- [ ] Clear overview with core principle
- [ ] Address specific baseline failures identified in RED
- [ ] Code inline OR @link to separate file
- [ ] One excellent example (not multi-language)
- [ ] Run scenarios WITH skill - verify agents now comply

**REFACTOR Phase - Close Loopholes:**
- [ ] Identify NEW rationalizations from testing
- [ ] Add explicit counters (if discipline skill)
- [ ] Build rationalization table from all test iterations
- [ ] Create red flags list
- [ ] Re-test until bulletproof

**Quality Checks:**
- [ ] Small flowchart only if decision non-obvious
- [ ] Quick reference table
- [ ] Common mistakes section
- [ ] No narrative storytelling
- [ ] Supporting files only for tools or heavy reference

**Deployment:**
- [ ] Commit skill to git and push to your fork (if configured)
- [ ] Consider contributing back via PR (if broadly useful)

## Real-World Impact

**Before skill:** 2 failed tests, strict mode violations, timeouts
- 245 lines of complex test code
- Multiple assumptions about page structure
- Tests failing after 9.6s and 3.1s

**After skill:** Individual passing tests, reliable assertions
- 15-20 lines per focused test
- Verified element structure
- Atomic debugging, faster feedback