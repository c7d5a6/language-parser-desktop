# Declensions

This tab configures declension patterns for the selected language and class. It combines three columns:
Classes, Used for Declension, and Enabled Declensions.

## Classes

Lists classes from [Grammar/Word Classes](../grammar/word-classes.md) that are either:

- enabled for the language in [Languages/Word Classes](word-classes.md), or
- already used by existing declensions.

Colors:

- Blue: Selected class.
- Bright gray: Class enabled in language and used by declensions.
- Red: Class used by declensions, but currently not enabled in language.
- Gray: Class not used by declensions.

## USED FOR DECLENSION

Lists categories from [Grammar/Grammatical Categories](../grammar/grammatical-categories.md).

For the selected class, checkbox toggles whether category participates in declension matrix.

Checkbox states:

- Green `[o]`: Category is enabled for declension generation.
- Gray `[x]`: Category is not enabled.
- Disabled: No class selected.

## ENABLED DECLENSIONS

Shows combinations generated from enabled category values for selected class.

Each row:

- `[x]` (gray): combination exists in matrix, but declension is not saved yet.
- `[o]` (green): declension exists and is active.
- `[o]` (red): declension exists, but is deprecated (values no longer match active matrix).

Name button:

- Click a used declension name to select it.
- Selected declension is highlighted in blue.
- `*` prefix marks a main declension.

When a declension is selected, details panel appears below the table.
