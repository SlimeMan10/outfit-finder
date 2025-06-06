# Accessibility Audit Changes

## Audit Group
group 17

## Audit Findings
- Some color combinations didn't pass WCAG standards (e.g., grey on white)
- Screen reader identified missing semantics in the app UI
- Unclear or missing form labels
- Specific color contrast ratios (1.27:1 and 2.16:1) for temperature display failed WCAG AA/AAA for normal and large text, as well as UI components.
- The temperature box (yellow background with colored text) was specifically called out for low contrast.
- The audit group recommended adding a border/bar around the temperature box to improve contrast.

### Notable guidelines violated:
- **3.3.2** (form labels)
- **1.4.3** (color contrast)
- **1.1.1** (non-text content)

## Implemented Changes
- Added form labels and UI signifiers to aid navigation
- Improved color contrast where possible
- Used accessibility tools to verify improvements
- **Added a visible border around the temperature box to meet WCAG contrast standards**

## Rejected Changes
[Document any audit recommendations that were not implemented, with justification]

## Future Improvements
- Continue to test and improve color contrast
- Further enhance semantic labeling for screen readers
- Making it so that you can reuse articles of clothing (like a search bar that filters by word) so that if you are already adding the same thing we can reduce the number of items in Isar

Then making it so that users can add their own colors 