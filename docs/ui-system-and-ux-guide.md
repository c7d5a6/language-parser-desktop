# Language Parser Desktop UI System and UX Guide

## Purpose

This project uses a custom text-first visual language (ASCII-like tables, dashes, and symbols) rendered with Flutter widgets.
This guide documents:

- how current UI is built
- reusable UI patterns
- rules for creating new components in this style
- UX review and improvements for better flow and usability

---

## 1) Core UI Philosophy

The UI is a **terminal-inspired structured canvas**:

- Layout is built with `Table`, `TableRow`, fixed-width columns, and flex filler columns.
- Borders are text characters (`|`, `+`, `-`, `*`, brackets) rendered through `DBorder`.
- Interactive controls are text tokens (`[ + ]`, `SAVE`, `x`, `e`) rendered via `TButton`.
- Typography is monospaced (`Cousine`) with tabular figures to keep visual alignment stable.
- Spacing and widths are measured in **character units** (`characterWidth`) from `TextMeasureProvider`.

This gives strong visual consistency, but requires strict construction rules to stay usable.

---

## 2) Style Tokens and Foundations

Primary references:

- `lib/util/constants.dart`
- `lib/util/layout.dart`
- `lib/text_measure_provider.dart`
- `lib/main.dart`

### Color semantics (current)

- `primary*`: primary action / selected tab accents
- `green*`: positive action (`SAVE`, add, enabled)
- `red*`: destructive (`x`, cancel-ish behavior)
- `yellow*`: edit/warning state
- `grey*`: neutral / inactive
- `selectedBackgroundColor`: selected/hovered row emphasis
- `stripedRowBackgroundColor`: alternating table rows

### Typography rules

- Use `LPFont.defaultTextStyle` for normal content.
- Use `LPFont.borderFontStyle` only for border glyphs.
- Keep text scale to one visual rhythm (same size/line-height family).

### Measurement rules

- Width decisions should be character-based (`N * cWidth`) when alignment matters.
- Use `FlexColumnWidth(1)` only for stretch/fill segments.

---

## 3) Existing UI Patterns

### A) ASCII container pattern

Used across tabs, lists, search rows, and detail panes.

Pattern:

1. Top edge (`+` + horizontal dash)
2. Content row(s) with side borders (`|`)
3. Bottom edge (`+` + horizontal dash)

Building blocks:

- `DBorder` for glyph characters
- `HDash`, `LDash`, `VTableDashes` for repeated borders

### B) Text-button command pattern

Used in `TButton`, rule actions, row actions, navigation tabs:

- one action per short token (`SAVE`, `EDIT`, `x`, `[ + ]`)
- hover color indicates affordance
- disabled state relies mostly on color/no-op behavior

### C) Two-pane editor pattern

Used in declension screens:

- Left: list / chooser (`RulesList`)
- Right: details and editors (`RuleDetailsColumn`, `SoundChangesTable`)
- State transitions: view mode -> edit mode -> save/cancel

### D) Dense row operation pattern

Used in sound change rows:

- per-row actions (`e`, `x`)
- optional full-table edit mode with multiline editor
- striped/hover backgrounds improve scanability

### E) Compact tab system

`Tabs` displays full label for active tab and short label for inactive tabs, with tooltip fallback.

---

## 4) Guidelines for Building New Components

### 4.1 Structure first, then interaction

When adding a component, design in this order:

1. table skeleton (borders and stable columns)
2. content rows
3. command row (`SAVE` / `CANCEL` / `EDIT`)
4. hover/selected/disabled states
5. empty/loading/error rows

### 4.2 Use shared primitives (do not invent local variants)

Prefer:

- `DBorder` for border characters
- `TButton` for actions
- `TTextField` / `TDropdownField` for inputs
- `LPColor` / `LPFont` tokens

Avoid:

- raw `TextButton` for in-app screens (unless explicitly different shell area)
- ad-hoc text styles per feature
- arbitrary pixel widths where character widths are expected

### 4.3 Column design rules

- Keep action columns fixed and narrow.
- Keep value/input column flexible.
- For mixed static/dynamic tables, reserve one flex filler column at end.
- Keep row heights stable to avoid layout jumps while editing.

### 4.4 Interaction rules

- Each destructive action should require confirmation or easy undo.
- Every disabled action should have a visible reason nearby.
- Use explicit labels when action meaning is not universal (`x` can mean cancel or delete).
- Keep keyboard path possible for all core actions (tab focus + enter).

### 4.5 State handling rules

Each editor component should model:

- `view`
- `edit`
- `saving`
- `error`
- `empty`

At minimum, show inline status when save fails or data reloads.

### 4.6 Accessibility/readability rules

- Keep color as a secondary signal, not the only one.
- Pair icon-like tokens (`x`, `e`) with tooltip or expanded label.
- Maintain enough contrast in inactive text.

---

## 5) Suggested Component Template

Use this checklist when creating a new feature panel:

1. `Table` frame with border primitives
2. Header row via `LPhHeader` (or equivalent project header widget)
3. Content rows using shared inputs/buttons
4. Optional striped data rows for lists
5. Footer command row with primary/secondary actions
6. Empty-state row (no data)
7. Error row (save or load failure)

---

## 6) UX Review of Current Implementation (Focus: UX, not visual style)

The current system is distinctive and coherent. The biggest UX opportunities are around discoverability, feedback, and action safety.

### High impact improvements

1. **Clarify compact action tokens**
   - Current `x`, `e`, and bracketed commands are fast for experts but harder for new users.
   - Improve with tooltips and/or expanded labels on hover or in first-run mode.

2. **Add explicit feedback for save/delete operations**
   - Many actions silently commit (`onSave`, delete row, toggle enable).
   - Add inline status lines like `Saved`, `Failed: <reason>`, `Deleted`.

3. **Protect destructive actions**
   - Row delete (`x`) currently executes immediately.
   - Add confirm prompt or undo toast for accidental clicks.

4. **Strengthen keyboard-first navigation**
   - The app style suggests keyboard-heavy usage, but controls are mostly mouse-hover driven.
   - Add focus states, enter-to-activate, and hotkeys for common commands (`save`, `edit`, `add`).

5. **Improve empty and null-selection states**
   - Some panes render minimal/blank output when nothing is selected.
   - Add guidance rows: `Select a rule to edit`, `No sound changes yet`, `Press [ + ] to create`.

### Medium impact improvements

1. **Unify screen shell behavior**
   - `OpenFileScreen` uses standard `TextButton` style while core app uses custom primitives.
   - Align initial flow to same command language so users don't context-switch early.

2. **Add validation hints near fields**
   - Save disable is useful, but users need reason text (`Rule name required`).

3. **Reduce cognitive load in dense tables**
   - In complex panes (declension rules + sound changes), consider progressive disclosure:
     - collapsed secondary sections by default
     - show details only after primary selection

4. **Standardize command naming**
   - Use consistent verbs (`EDIT`, `DELETE`, `CANCEL`, `SAVE`) across features.
   - Avoid mixed symbol-only and text-only controls for similar operations.

### Lower effort quick wins

1. Add tooltips to every symbol-only action.
2. Add one-line inline status area below command rows.
3. Add confirmation for delete actions.
4. Add placeholder/empty guidance in right-side detail panes.
5. Add consistent `Esc = cancel` where edit mode exists.

---

## 7) Recommended Near-Term UX Roadmap

### Phase 1 (fast)

- Tooltips for compact commands
- Inline save/delete feedback
- Delete confirmation
- Empty-state helper text

### Phase 2 (medium)

- Keyboard navigation and shortcuts
- Validation help text + error states
- Standardize action labels and behavior

### Phase 3 (structural)

- Shared interaction/state wrapper for editor panels
- Reusable status + command bar component
- Unified onboarding/first-run hints for the ASCII interaction model

---

## 8) Definition of Done for New UI Components

A new component is considered complete when it:

- follows character-grid table layout rules
- uses shared primitives and style tokens
- supports clear view/edit/save/cancel flow
- provides feedback for success/failure
- handles empty and error states explicitly
- avoids unsafe destructive actions without confirmation/undo
- includes tooltips/help for non-obvious symbol commands

