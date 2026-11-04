# asmeconf-typst

A Typst port of the [asmeconf](https://ctan.org/pkg/asmeconf) LaTeX class (v1.47) for ASME conference papers.
`asmeconf-template.typ` reproduces the class's `asmeconf-template.tex`, so its PDF can be compared page by page with the
`asmeconf-template.pdf` in the [CTAN distribution](https://ctan.org/pkg/asmeconf).

For a new paper, copy `asmeconf.typ`, both `.csl` files and `fonts/` into the paper's repository.

## Files

| File | Purpose |
|---|---|
| `asmeconf.typ` | The template (page layout, title block, headings, captions, footers, nomenclature, appendix) |
| `asmeconf.csl` | ASME reference style, modelled on `asmeconf.bst` (used when `strict: false`) |
| `asmeconf-strict.csl` | Same, with ASME's serial comma before "and" (used when `strict: true`) |
| `asmeconf-template.typ` | Example paper (port of `asmeconf-template.tex`; the text still describes the LaTeX class) |
| `asmeconf-sample-typst.bib` | Copy of `asmeconf-sample.bib` adapted for Typst (see the header of the file) |
| `fonts/` | TeX Gyre Termes/Heros/Termes Math, Inconsolatazi4, Lete Sans Math, Liberation Serif/Sans/Mono (see `fonts/README.md`) |
| `sample-figure-*.pdf`, `*.svg` | Example figures (SVG copies are needed for PDF/A output) |

## Compiling

Requires Typst ≥ 0.14 (developed with 0.15.1, installed with `cargo install --locked typst-cli`).

```sh
typst compile --font-path fonts asmeconf-template.typ
typst watch   --font-path fonts asmeconf-template.typ     # recompile on save
```

The first compile downloads the `equate` package (per-line numbers in aligned equations), which the example uses.

PDF/A (`--pdf-standard a-3u`) works, but Typst cannot embed PDF figures in PDF/A mode. Use SVG figures instead
(`pdftocairo -svg fig.pdf fig.svg`).

## Usage

```typst
#import "asmeconf.typ": *

#show: asmeconf.with(
  conf-name: [Proceedings of the ASME 2027 \ International Mechanical Engineering Congress and Exposition],
  conf-acronym: [IMECE2027],
  conf-date: [November 2027],
  conf-city: [City, ST],
  paper-no: [IMECE2027-XXXX],
  title: [Paper Title: Subtitle With #nocase[mm] Units],
  authors: (
    (name: [First Author], affil: 1, corresponding: true),
    (name: [Second Author], affil: (1, 2), joint-first: true),
  ),
  affiliations: ("1": [University, City, State], "2": [Company, City, Country]),
  corresponding-email: [first\@uni.edu],
  abstract: [...],
  keywords: ([keyword one], [keyword two]),
)

#nomenclature([Roman letters], ($k$, [Thermal conductivity]), ...)

= Introduction
...
#bibliography("refs.bib")

#show: appendix
= First Appendix
```

### `strict`: LaTeX look or exact ASME specification

| | `strict: false` (default) | `strict: true` |
|---|---|---|
| Goal | Same output as the asmeconf LaTeX template | ASME's written specification, to the letter |
| Fonts (`fonts: auto`) | TeX Gyre Termes / Heros, Inconsolata | Times New Roman / Arial / Courier New, falling back to the metric-identical Liberation fonts |
| Header, authors, headings | 9.1 pt (Helvetica scaled 0.91, as asmeconf) | 10 pt |
| Title / paper number | 10 pt / 14.6 pt | 11 pt / 16 pt |
| Links and citations | coloured if `colorlinks: true` | always black (`colorlinks` ignored) |
| Punctuation at line ends | may hang ~2 pt into the margin (like microtype) | stays inside the text block |
| 3+ authors in references | "A, B and C" (as `asmeconf.bst`) | "A, B, and C" (ASME: "use series commas") |
| Corresponding-author mark | math asterisk ∗ | plain * |

Body text (10 pt), margins, columns, captions, and all other layout are identical in both modes. An explicit
`fonts:` argument overrides the automatic choice, and the sans-serif sizes stay nominal in strict mode either way.
With strict mode, Typst warns "unknown font family: arial" when the Microsoft fonts are not installed; the
Liberation fallback is then used.

The reference style is chosen by the template, so call `#bibliography("refs.bib")` without a `style:` argument.

### Options (equivalents of the asmeconf class options)

| Typst argument | LaTeX option |
|---|---|
| `colorlinks: true` | `[colorlinks]` (turn off for the final ASME submission: all text must be black) |
| `lineno: true` | `[lineno]` |
| `grid: true` | `[grid]` |
| `head: false` | `[nohead]` |
| `footer: "none" / "govt" / "govtsome" / "contractor"` | `[nofoot]`, `[govt]`, `[govtsome]`, `[contractor]` |
| `unboldcaption: true` | `[unboldcaption]` |
| `strict: true` | (none) exact ASME spec, see above |
| `fonts: "texgyre"`, `"liberation"`, `"msfonts"` | TeX Gyre (asmeconf), Times New Roman/Arial metric clones, or the real MS fonts if installed |
| `version-note: [...]` | `\versionfootnote{...}` |

### Helpers

- `nocase[...]`: keep text lowercase in the title and level-1 headings (`\NoCaseChange`). Math, citations and references are never uppercased.
- `paragraph-heading[...]`: run-in unnumbered sub-subsection heading (`\subsubsection*`).
- `noindent[...]`: paragraph that continues after a display equation or quote without an indent.
- `nomenclature(...)`: nomenclature list; content items are subheadings, `(symbol, meaning)` pairs are entries.
- `appendix`: `#show: appendix` switches numbering to A, B, C (supplement "Appendix").
- `foreign(lang)[...]`: passage in another language.
- References: `@fig:x` → "Fig. 1", `@fig:x[Figure]` at the start of a sentence, `@eq` → "Eq. (1)", `@sec` → "Sect. 2".

## Differences from the LaTeX output

- **Fonts:** TeX Gyre Termes replaces TeX Gyre Termes X (newtx), and TeX Gyre Termes Math replaces newtxmath, so maths glyphs differ slightly. Sans-serif is scaled by 0.91, as in asmeconf; use `strict: true` for nominal Arial sizes.
- **Line breaking** differs slightly (no microtype), so page breaks do not line up exactly.
- **No automatic last-page column balancing** (`[balance]`); add `#colbreak()` by hand if needed.
- **Multline equations:** numbered on the last line via `#<equate:revoke>` on earlier lines.
- **Run-in sub-subsection headings** are produced with `paragraph-heading` and do not appear in PDF bookmarks.
- **Sequential footnote marks** need a manual `#super[,]` between them.
- **Bibliography (Hayagriva/CSL) quirks**, handled in `asmeconf-sample-typst.bib`. Apply the same fixes in your own `.bib`:
  - `urldate` must be ISO (`2025-03-14`);
  - put conference dates in `venue` (date ranges keep only the end date);
  - `@online` `version` → `note = {Version x}`;
  - article numbers: `pages = {⁠052701}`, with an invisible U+2060 prefix so the leading zero is kept;
  - `{{John Wiley and Sons}}` braced;
  - use the U+2010 hyphen in report numbers like `DETC2005‐99532`;
  - LaTeX macros (`\texttt`, `\TeX`) are not interpreted.
- **Thesis types:** PhD and master's theses print "Doctoral dissertation" / "Master's thesis" unless `type = {Ph.D. Thesis}` is given.

## Licence

The template, reference styles, example paper and sample files are under the MIT licence in `LICENSE`, including the
parts derived from the asmeconf class by John H. Lienhard. The fonts in `fonts/` have their own licences; see
`fonts/README.md`.

This project is not affiliated with or endorsed by ASME.
