# System Overview

Language Parser Desktop is a Flutter desktop app for constructing and describing languages. You define a shared grammar catalog (word classes, grammatical categories), then enable and specialize those pieces per language: phoneme inventory, morphology (declensions and rules with sound changes), and a lexicon.

Work is stored in a local SQLite file. The app opens or creates that file first; everything else is scoped to it.

## What you do in the app

| Area | Purpose |
| --- | --- |
| **Grammar** | Global catalog: parts of speech and grammatical categories (case, gender, tense, …) with their values. |
| **Languages** | Per-language configuration: identity, phonetics, which classes/categories apply, declension matrices and inflection rules, orthography (stub). |
| **Evolution** | Experimental playground for phonological rules via the native `libph` library (apply a rule, inspect distinctive features). |
| **Words** | Lexicon: add words and browse/search them, filtered by language and word class. |

A typical workflow:

1. Define word classes and grammatical categories in **Grammar**.
2. Create a language in **Languages**, then enable classes and category values for it.
3. Choose which categories participate in declension for a class, generate the combination matrix, and attach inflection rules (word pattern + ordered sound-change lines).
4. Add words in **Words**; phoneme usage is derived from the lexicon plus an explicit phoneme inventory.

## Tech stack

- **UI:** Flutter (Material 3, dark theme), monospaced Cousine, character-grid layout.
- **Persistence:** SQLite via `sqlite3` (Dart), one file per project, numbered SQL migrations in `assets/db/migrations/`.
- **Phonology engine:** native shared library `assets/libph_lib.so`, called through Dart FFI (`PhonologicalRules`). Linux only today.
- **Search:** SQLite FTS5 trigram index over `word_tbl`.

There is no backend. The process owns the database file for the session.

## Architecture

Layers, top to bottom:

```
UI (lib/features, lib/components)
        │
        ▼
ServiceProvider  →  ServiceManager  →  domain services
        │
        ▼
RepositoryManager  →  repositories  →  SQLite
        │
        └── PhonologicalRules  →  libph (FFI)
```

- **Features** are screens. They obtain `ServiceManager` from `ServiceProvider` (an `InheritedWidget`) and do not open the database themselves.
- **Services** encode use cases and join several repositories (e.g. building a declension matrix, validating sound-change strings).
- **Repositories** own SQL, mapping to entity classes, and a cache-invalidation hook so widgets can refresh after writes.
- **Entities** are plain Dart models plus table name constants.

Startup (`lib/main.dart`):

1. Show **Open file** until the user creates or picks a SQLite path.
2. `RepositoryManager.openDatabase` opens the file, runs pending migrations, enables foreign keys, and constructs repositories.
3. `ServiceManager` is built on that manager (including `PhonologicalRules`).
4. The main `App` is wrapped in `TextMeasureProvider` (character width for the ASCII layout) and `ServiceProvider`.

UI state is local to widgets. Persistence changes notify listeners through repository **invalidators** (`Invalidator` + `RepositoryCache`): after a write, registered widgets `invalidate()` and reload.

## Domain model

Shared catalog (Grammar):

- **Word class (POS)** — noun, verb, adjective, … Seeded with a default list; users can add more. Table: `pos_tbl`.
- **Grammatical category** — Case, Gender, Number, Tense, Aspect, Mood (seeded). Table: `grammatical_category_tbl`.
- **Category value** — e.g. Nominative, Plural. Unique name, belongs to one category. Table: `grammatical_category_value_tbl`.

Per language:

- **Language** — display name, optional native name and comment. Table: `language_tbl`.
- **Language phoneme** — explicit IPA inventory for the language. Table: `language_phoneme_tbl`.
- **POS ↔ language** — which classes are enabled. Table: `pos_lang_connection_tbl`.
- **POS × category ↔ language** — which categories apply to which class in that language. Table: `pos_category_lang_connection_tbl`.
- **Category value ↔ language** — which values are enabled. Table: `category_value_lang_connection_tbl`.

Morphology:

- **Declension-category link** — which categories form the declension matrix for a (language, POS) pair. Table: `declension_category_pos_lang_connection_tbl`.
- **Declension** — one cell in that matrix: a set of category values, optional “main” flag. Tables: `declension_tbl`, `declension_value_connection_tbl`.
- **Declension rule** — named rule on a declension: optional word-pattern filter, enable flag, links to extra GC values, ordered sound-change strings. Tables: `declension_rule_tbl`, `declension_rule_gc_value_connection_tbl`, `declension_rule_sound_change_tbl`.

Lexicon:

- **Word** — IPA (or phonetic) form, language, POS, comment, forgotten flag, source type (`NEW`). Table: `word_tbl`, mirrored into `fts5_word`.

`DeclensionService.getDeclensions` computes the Cartesian product of enabled category values for a (language, POS) pair and overlays saved declensions. Combinations that no longer match the live matrix are marked deprecated.

## UI structure

The chrome is a terminal-style canvas: monospaced text, ASCII borders (`DBorder`, `HDash`, `VDash`, …), and text tokens as buttons (`TButton`). Widths are multiples of measured character width (`TextMeasureProvider`). See `docs/ui-system-and-ux-guide.md` for construction rules.

Main tabs (`lib/app.dart`):

| Tab | Widget | Contents |
| --- | --- | --- |
| Grammar | `Grammar` | Word Classes, Grammatical Categories |
| Languages | `Languages` | Language list + per-language tabs |
| Evolution | `TempSoundChhh` | Rule / input / distinctive-features tester |
| Words | `Words` | Add New, List (paginated FTS search) |

Language detail tabs (`LanguageContentTabs`): Description, Phonetics (pulmonic consonant chart + inventory vs. attested sounds), Word Classes, Grammatical Categories, Declensions (matrix + rule editor with sound-change list), Orthography (placeholder).

End-user tab behavior is documented under `docs/docs/`.

## Persistence

Migrations live in `assets/db/migrations/` as `{n}_{name}.sql`. `migrate()` in `lib/util/sqlite.dart` applies any file whose number is greater than `PRAGMA user_version`, in a transaction.

Current sequence:

1. `language`
2. `pos` (seeded classes)
3. `word`
4. `word_fts_idx` (FTS5 + triggers)
5. `language_phoneme`
6. `grammatical_category` (seeded)
7. `grammatical_category_value`
8. `pos_lang_connection`
9. `pos_category_lang_connection`
10. `category_value_lang_connection`
11. `declension_category_pos_lang_connection`
12. `declension` (+ value connections)
13. `declension_rule` (+ GC-value links + sound-change lines)

Foreign keys are on. Deletes are mostly `RESTRICT` so catalog items in use cannot be dropped silently; some child rows `CASCADE` with their parent declension.

## Phonology and sound changes

Two related pieces:

1. **Dart distinctive-feature model** (`lib/enums/feature.dart`, `lib/sound_changes/phoneme.dart`, lexers). Phonemes are sets of ± features (manner, place, laryngeal, vowel height, …) with bitmasks for matching. Used for IPA inventory logic and (historically) a Dart sound-change lexer.

2. **Native rule engine** (`lib/services/phonological_rules.dart` → `libph_lib.so`). Exposed as `version`, `distinctiveFeatures`, `createRule` / `applyRule`, and `validateRule`. Declension sound-change lines are stored as text and validated with `validateRule`. The Evolution tab applies a rule string (e.g. `t > d / V_V`) to an input form.

Declension rule sound changes are edited as a list or as a multi-line block; empty lines are dropped on save.

## Directory map

```
lib/
  main.dart, app.dart, service_provider.dart
  features/          screens (grammar, language, word, evolution, open-file)
  components/        shared ASCII UI (borders, tabs, buttons, sound-change editor)
  services/          ServiceManager + domain services + FFI wrapper
  persistence/
    entities/        models
    repositories/    SQL + Invalidator cache
    repository_manager.dart
  sound_changes/     phoneme types and lexers
  enums/             distinctive features
  util/              layout, colors, SQLite migrate, IPA helpers
assets/
  db/migrations/     schema evolution
  libph_lib.so       phonological engine
  fonts/             Cousine
docs/                VuePress site + UI guide
test/                repository, service, migration, sound-change tests
```

## Services

| Service | Responsibility |
| --- | --- |
| `LanguageService` | CRUD languages; phoneme inventory; attested vs. selected phonemes from the lexicon |
| `PosService` | Word classes; enable class per language; class × category per language |
| `GCService` | Categories and values; enable values per language; category × class links |
| `DeclensionService` | Matrix, declensions, rules, GC links, sound-change lines, rule validation |
| `WordService` | Save words; paginated FTS search |
| `PhonologicalRules` | FFI to `libph` |

## Tests

Under `test/`: repository CRUD and connections, language service, schema migrations, phoneme/lexer/sound-change behavior, and feature bitmasks. Tests use an in-memory or temp SQLite database (`test/persistence/database.dart`).
