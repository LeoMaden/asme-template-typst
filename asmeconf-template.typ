// asmeconf-template.typ — example ASME conference paper using asmeconf.typ
//
// A Typst port of asmeconf-template.tex (asmeconf v1.47, J. H. Lienhard).
// The text is kept from the LaTeX original so the two PDFs can be compared
// page by page; it therefore still describes the LaTeX class in places.
//
// Compile with:
//     typst compile --font-path fonts asmeconf-template.typ
// For archival PDF/A:
//     typst compile --font-path fonts --pdf-standard a-3u asmeconf-template.typ

#import "asmeconf.typ": *
#import "@preview/equate:0.3.3": equate

// Logos used in this document
#let TeX = box[T#h(-0.1667em)#box(move(dy: 0.215em)[E])#h(-0.125em)X]
#let LaTeX = box[L#h(-0.36em)#box(move(dy: -0.21em, text(size: 0.7em)[A]))#h(-0.15em)#TeX]
#let pdfTeX = [pdf#TeX]
#let LuaLaTeX = [Lua#LaTeX]
#let BibTeX = [Bib#TeX]

// Decimal-aligned table cell (replacement for the dcolumn package)
#let dec(int, frac, sep: ".", w: 2em) = [#box(width: w, align(right, int))#sep#box(width: w, align(left, frac))]

#show: asmeconf.with(
  // Change these fields to the right content for your conference.
  conf-name: [Proceedings of the ASME 2025 \ International Mechanical Engineering Congress and Exposition],
  conf-acronym: [IMECE2025],
  conf-date: [November 16–20, 2025],
  conf-city: [Memphis, TN],
  paper-no: [IMECE2025-XXXX],

  // Units of measure and other lowercase terms in the title go inside #nocase[..].
  title: [A LaTeX Template for ASME Conference Papers: #nocase(`asmeconf.cls`)],

  authors: (
    (name: [John H. Lienhard], affil: 1, joint-first: true, corresponding: true),
    (name: [Luis Hernández], affil: 2, joint-first: true),
    (name: [Maria Silva], affil: 3),
    (name: [Henry Tudor], affil: 4),
    (name: [Catherine Parr], affil: 4, corresponding: true),
  ),
  corresponding-email: [lienhard\@mit.edu, kate\@thepalace.gov],
  affiliations: (
    "1": [Massachusetts Institute of Technology, Cambridge, MA],
    "2": [Institution or Company Name, City, State],
    "3": [Institution or Company Name, City, Province, Canada],
    "4": [Hampton Court Palace, Richmond, England],
  ),

  // Delete before final submission.
  version-note: [Documentation for `asmeconf.cls`: Version 1.47, #datetime.today().display("[month repr:long] [day padding:none], [year]").],

  keywords: ([ASME conference paper], [#LaTeX Template], [#BibTeX]),

  // Abstract should be 200 words or less
  abstract: [
    This paper is an example of and a #text(style: "normal", LaTeX) template for typesetting ASME conference papers using the `asmeconf` class. This #text(style: "normal", LaTeX) template follows ASME guidelines for margins, fonts, headings, captions, and reference formats as of 2025. The class should be used with the #text(style: "normal")[`asmeconf.bst` #BibTeX] style for reference formatting, which is part of this distribution. The template produces pdfs that contain hyperlinks, bookmarks, and metadata; and references can include the DOI and URL fields. Links may be colored, for online use, or black, for publication. The class enables inline author names, following ASME's current style, but can also produce the traditional grid style. Options include line numbering, final column balancing, various math options, government copyright, and archivability (PDF/A). In addition, section headers may contain mathematics, references, citations, and footnotes. The class is compatible with #text(style: "normal", pdfTeX) or #text(style: "normal", LuaLaTeX).
  ],

  pdf-author: "John H. Lienhard",
  pdf-title: "ASME Conference Paper LaTeX Template",
  pdf-keywords: ("ASME conference paper", "LaTeX template", "BibTeX style"),

  // Options
  colorlinks: true,     // remove before final submission to ASME (black text for printing)
  lineno: false,
  grid: false,
  footer: "asme",       // "none", "govt", "govtsome", "contractor"
  strict: false,        // true: exact ASME spec (Arial/Times New Roman at nominal sizes, black text)
  fonts: auto,          // or "texgyre", "liberation", "msfonts"
)

// Numbered lines in aligned equations (like amsmath align)
#show: equate.with(breakable: true, sub-numbering: false)

// ===== NOMENCLATURE (OPTIONAL) ==============================================

#nomenclature(
  [Roman letters],
  ($k$, [Thermal conductivity [W m$""^(-1)$ K$""^(-1)$]]),
  ($arrow(q)$, [Heat flux vector [W m$""^(-2)$]]),
  [Greek letters],
  ($alpha$, [Thermal diffusivity [m$""^2$ s$""^(-1)$]]),
  ($nu$, [Kinematic viscosity [m$""^2$ s$""^(-1)$]]),
  [Dimensionless groups],
  ([Pr], [Prandtl number, $nu\/alpha$]),
  ([Sc], [Schmidt number, $nu\/cal(D)_(1,2)$]),
  [Superscripts and subscripts],
  ([b], [bulk value]),
  ($infinity$, [free stream value]),
)

// ===== BODY OF PAPER ========================================================

= Introduction

The #link("https://ctan.org/pkg/asmeconf")[`asmeconf`] class typesets papers with margins, fonts, headings, captions, and reference formats that follow the specifications for conference papers of the American Society of Mechanical Engineers (ASME). The `asmeconf` class will set internal and external hyperlinks, and the pdf file will contain bookmarks and metadata. Many other useful features have been incorporated. This class is not a publication of ASME, but the author has published in ASME conferences since 1983.

The `.tex` file may be written using standard #LaTeX commands, although some class-specific initial commands are needed to format the blocks containing the author[s], title, and abstract. This class loads a number of other packages, all of which are contained in up-to-date versions of #link("https://www.tug.org/texlive/")[#TeX Live], #link("http://www.tug.org/mactex/")[Mac#TeX], and similar platforms. If you get an error message about a missing package, you can download that package at no cost from CTAN (#link("https://ctan.org")[ctan.org]).

== Essential Initial Commands

To begin, fill in the fields to be completed at top of the `asmeconf-template.tex` file. These fields include the headers for your conference and your paper number. The metadata you provide will be placed into the pdf file itself.
The title should be placed into `\title{..}`.

Put author names into the `\SetAuthors{name, name,...}` command in the desired order; follow the syntax illustrated `asmeconf-template.tex` file. Put each distinct address sequentially into a separate `\SetAffiliation{n}{address}`, where $n = 1, 2, dots$ Tag each author with an affiliation by putting `\affil{n}` after that author's name inside the `\SetAuthors{..` command.

Keep author addresses short. List the author institution, and the City, State (US authors), City, Province, Canada (Canadian authors), or City, Country (other international authors).

One author (or more) may be designated as the corresponding author by placing `\CorrespondingAuthor{email}` after `\affil{n}`. Two or more authors may be joint first authors by putting `\JointFirstAuthor` after `\affil{n}`.

After setting up the headers, authors, and title, issue the `\maketitle` command.

The abstract text must be placed into `\begin{abstract}` … `\end{abstract}`. The abstract will automatically be italicized. Keywords may be included using the `\keywords{..}` command. The `keyword` command _must_ be issued before the abstract environment.

= Referring to Citations, Figures, and Equations

Citations are automatically numbered @ning2002. They should be inserted in the text using a `\cite{ref}` command~@gibson2008 @stevens1999. The citations will be automatically sorted and compressed if they are given in a set @stevens1999 @ning2002 @gibson2008 @wions2005 @smith2002 @watson1982.
A specific reference may be named with an abbreviation, as in Ref.~@watson1982.
See the `asmeconf-sample.bib` file and @sec:references for examples of entering references.

For ASME conference papers, the labels Equation and Figure should be abbreviated when they do not start a sentence, as in @eqn:dw and @fig:1. @fig:1[Figure] is spelled out when it starts a sentence. @eqn:dw[Equation] is spelled out when it starts a sentence.

Equations are typeset in the usual way and will be automatically numbered. The class file loads the `amsmath` and `mathtools` packages. Further, the `newtxmath` package used for the math fonts includes many additional math features (see @sec:moremath).
$ arrow(q) = -k nabla T $ <eqn:fourier>

ASME prefers SI units. (U.S. style units may follow in parentheses.) Be sure to put all symbols into the nomenclature list, including their units.

// captions go below figures
#figure(
  image("sample-figure-1.pdf", width: 100%, alt: "Linearization error in radiant flux"),
  caption: [Caption with math, eqn.~#ref(<eqn:fourier>, supplement: none), $Delta T\/T_m$ vs. $Delta T\/T_1$~@lienhard2019],
) <fig:1>

// Use title case for subsections and subsubsections (first letter of words capitalized)

= Section Headings and Captions

ASME requires that section headings and captions be set in an uppercase, sans serif font. The class will do this automatically. You can place `\cite{..}`, `\ref{..}`, `\label{..}`, and mathematics into headings and captions directly, as you would in the main text. Do not enclose them braces, e.g. `{\cite{..}}`, which will cause errors. You can place `\footnote{..}` into headings, but not into captions.#footnote[See `tex-stackexchange` for various approaches to footnotes in captions, if they seem necessary. For footnotes in tables, use the `tablefootnote` package.]#super[,]#footnote[Sequential footnotes are automatically separated by a comma.]

Text in section headings and captions will not be capitalized if enclosed in a `\NoCaseChange{..}` command.

Sections may either be numbered or left unnumbered.

Simple mathematical expressions can be used in either captions or section headings. For a section heading that includes more complicated math (and macros), you may use the optional argument of `\section[..]{..}` to create a pdf bookmark without losing characters or producing warnings or errors. See the `asmeconf-template.tex` source file for examples of this procedure. These bookmarks should usually be text expressions, although some math is supported.

To eliminate boldface type in caption text and math, use the class option `[unboldcaption]`. To prevent sans-serif math, put `\NoCaseChange{\mathversion{normal}}` in the caption.

== Subsection and Sub-subsection Headings

Subsections and sub-subsection headings should be entered in title case, with the first letter of primary words capitalized. Sub-subsections (i.e., paragraphs) are never numbered.

// Captions go above tables (set automatically)
#let toprule = table.hline(stroke: 0.08em)
#let midrule = table.hline(stroke: 0.05em)
#let bottomrule = table.hline(stroke: 0.08em)

#figure(
  placement: top,
  caption: [A simple table],
  table(
    columns: 3,
    align: (left, left, right),
    toprule,
    table.header[Experiment][$u$ [m/s]][$T$ [°C]],
    midrule,
    [Run 11], [12.5], [103.4],
    [Run 12], [24], [68.3],
    bottomrule,
  ),
) <tab:1>

// note column set as a 3 cm wide paragraph with 1 em hanging indentation;
// numbers aligned on "." and on "," with the dec() helper defined above
#figure(
  placement: top,
  caption: [Table with more complicated columns],
  table(
    columns: (3cm + 12pt, auto, auto),
    column-gutter: (0pt, 0.5cm),
    align: (left, center, center),
    toprule,
    table.header[Experiment][$u$ [m/s]][$T$ [°C]],
    midrule,
    ..(
      ([The first test we ran this morning], dec[124][3], dec(sep: ",")[68][3]),
      ([The second test we ran this morning], dec[82][50], dec(sep: ",")[103][46]),
      ([Our competitor's test], dec[72][321], dec(sep: ",")[141][384]),
    ).map(((a, b, c)) => (par(hanging-indent: 1em, a), b, c)).flatten(),
    bottomrule,
  ),
) <tab:2>

// two-column table
#figure(
  scope: "parent",
  placement: top,
  caption: [A table spanning two columns],
  box(width: 80%, table(
    columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
    align: center,
    column-gutter: (0pt, 0pt, 3em, 0pt, 0pt),
    toprule,
    table.header[$x$][$"erf"(x)$][$"erfc"(x)$][$x$][$"erf"(x)$][$"erfc"(x)$],
    midrule,
    [0.00], [0.00000], [1.00000], [1.10], [0.88021], [0.11980],
    [0.05], [0.05637], [0.94363], [1.20], [0.91031], [0.08969],
    [0.10], [0.11246], [0.88754], [1.30], [0.93401], [0.06599],
    [0.15], [0.16800], [0.83200], [1.40], [0.95229], [0.04771],
    [0.20], [0.22270], [0.77730], [1.50], [0.96611], [0.03389],
    [0.30], [0.32863], [0.67137], [1.60], [0.97635], [0.02365],
    [0.40], [0.42839], [0.57161], [1.70], [0.98379], [0.01621],
    [0.50], [0.52050], [0.47950], [1.80], [0.98909], [0.01091],
    [0.60], [0.60386], [0.39614], [1.82#box(width: 0pt, align(left)[14])], [0.99000], [0.01000],
    [0.70], [0.67780], [0.32220], [1.90], [0.99279], [0.00721],
    [0.80], [0.74210], [0.25790], [2.00], [0.99532], [0.00468],
    [0.90], [0.79691], [0.20309], [2.50], [0.99959], [0.00041],
    [1.00], [0.84270], [0.15730], [3.00], [0.99998], [0.00002],
    bottomrule,
  )),
) <tab:3>

= Tables and Figures

Table #ref(<tab:1>, supplement: none) is an example of a simple table. Table captions should be placed above tables.
The class loads the `booktabs` package (used for horizontal rules in Tables #ref(<tab:1>, supplement: none) and #ref(<tab:2>, supplement: none)), and the `array` and `dcolumn` packages which provide extended capabilities for columns in the `tabular` environment (see @tab:2). Table #ref(<tab:3>, supplement: none) is an example of a table that spans two columns. Two column tables (and figures) will always float to the top of a later page.

Figure captions go below figures. @fig:2[Figure] is an example of a figure that spans two columns and includes subfigures. The text in figures (and tables) should be no smaller than 6~point type. Images in figures are handled by the standard `graphicx` package.

Landscape figures and tables may be produced at full-page size by putting `\usepackage[figuresright]{rotating}` in your `.tex` file's preamble and using the `sidewaystable*` and `sidewaysfigure*` environments~@fairbairns.

= Reference Formatting with #nocase(`asmeconf.bst`)#footnote[To prevent capitalization of text in a section heading or caption, such as an SI unit, enclose it in a `\NoCaseChange` command. As of the July 2022 release of #LaTeX, commands used in a heading or caption may be protected globally by putting this in the preamble: `\AddToNoCaseChangeList{\MyCommand}`] <sec:references>

The `asmeconf.bst` #BibTeX style follows the reference styles shown on ASME's conference web site in 2025.#footnote[`asmeconf.bst` is intended as a replacement for the old `asmems4.bst`, which does not follow ASME's current reference formats or support DOI and URL.]
Examples for these and many other cases are given in the `asmeconf-sample.bib` file, which is part of this distribution. Citations and references are managed by the standard `natbib` package. Nevertheless, a few comments are necessary.

// sub-subsections should *not* be numbered according to ASME's style
#paragraph-heading[DOI, URL, and eprint] Include DOI numbers when they are available. URL's may alternatively be given. ASME requests that URLs point to a document's abstract.

Basic support for `eprint` numbers is also included, generating a url at the end of the citation. The `archive` type may be specified using the macros `arxiv, googlebooks, hdl, jstore, oclc`, or `pubmed` (e.g., `archive=hdl`, _without_ braces). Both `eprint` and `archive` fields _must_ be given. Other root urls may be invoked using `archive = {https://another.url.org/}`.

#paragraph-heading[Online Sources] A bibliography entry `@online{..` is included for citation of online sources, such as web pages. A `url` or `eprint` with `archive` must be included. See the examples of use in the `asmeconf-sample.bib` file.

#paragraph-heading[Date Accessed] The `urldate={..}` field may be used to provide the date on which a given url was accessed. By default, the text printed will be #raw("Accessed `date',"). The word "Accessed" may be changed using the `urltype={..}` field.

#paragraph-heading[Conference Location and Date] To specify the city and date of a conference, you can use `venue={..}` and `eventdate={..}` with the entries `@inproceeedings{..` and `@proceeedings{..`

#paragraph-heading[Capitalization of Titles] ASME's bibliography style requires that document titles be in title case. The first letters of principal words are capitalized. Do this in the `.bib` file.

// two-column figure with subfigures
#figure(
  scope: "parent",
  placement: top,
  grid(
    columns: (1fr, 1fr),
    column-gutter: 0.38in,
    align: bottom,
    figure(
      kind: "subfigure", supplement: none, numbering: "a",
      image("sample-figure-2a.pdf", width: 90%, alt: "Nusselt number data for isothermal wall"),
      caption: [Uniform temperature wall],
    ),
    figure(
      kind: "subfigure", supplement: none, numbering: "a",
      image("sample-figure-2b.pdf", width: 92.7%, alt: "Nusselt number data for uniform heat flux wall"),
      caption: [Uniform heat flux wall with unheated starting length],
    ),
  ),
  caption: [A figure with two subfigures~@lienhard2020],
) <fig:2>

// Complicated math may be used directly in headings; the PDF bookmark is derived automatically.
= More on math: $arrow(upright(u)) dot arrow(omega) = 0$ <sec:moremath>

In most cases, the need for a wide equation can be eliminated by using one of the multiline equation environments defined by
`amsmath`, such as `align`, `split`, or `multline`~@amsmath. The following equation is set with the
`multline` environment:
$
  partial / (partial t) [rho (e + lr(|arrow(u)|)^2 slash 2)] + nabla dot [rho (h + lr(|arrow(u)|)^2 slash 2) arrow(u)] & #<equate:revoke> \
  #h(2em) = -nabla dot arrow(q) + rho arrow(u) dot arrow(g) + partial / (partial x_j) (d_(j i) u_i) + dot(Q)_v &
$ <eqn:energy>
#noindent[An example using `align` appears in @appendix:a.]

An experimental package for setting equations that span two columns, `asmewide.sty`, can be loaded as well, but that code may require hand-fitting around figures, tables, and page breaks. See the examples in~@lienhard2022. An alternative solution may be to set large equations into two-column-wide tables or figures.

Math italics are used for Roman and Greek letters by default. If you want an upright letter in math, you can use the relevant math alphabet, e.g., `\mathrm, \mathbf, \mathsf`:
$
  arrow(F) = m arrow(a) quad "or" quad arrow(upright(F)) = m arrow(upright(a)) quad "or" quad bold(upright(F)) = m bold(upright(a)) quad "or" quad arrow(sans(F)) = m arrow(sans(a))
$ <eqn:dw>

== The #nocase(`newtxmath`) and #nocase(`unicode-math`) Packages~@sharpe1 @robertson2023
The `newtxmath` package, loaded by default with #pdfTeX, includes many options for mathematics, most of which can be called as options to `\documentclass`. For example, the `upint` option selects upright integral signs (rather than slanted integral signs):
#quote(block: true)[`\documentclass[upint]{asmeconf}`.]
#noindent[The option `subscriptcorrection` improves the spacing of math subscripts. Math options are discussed further in the `asmeconf-template.tex` file. The `newtxmath` package is also loaded with the `[nofontspec]` option.]

To get additional symbols in bold math with #pdfTeX, use `\bm{..}` from the `bm` package, which is loaded by the class.

If using #LuaLaTeX, the math features of `unicode-math` are available. These include commands to select a boldface, upright symbol, `\symbfup{..}` or `\mathbfup{..}`, to select boldface fraktur
symbol, `\symbffrak{..}` or `\mathbffrak{..}`, and so on. See the documentation of `unicode-math` for details~@robertson2023.

The `[upint]` option also works under #LuaLaTeX.

For longer passages of bold math, you can use `{\mathversion{bold}..}` with either #pdfTeX or #LuaLaTeX:
`{\mathversion{bold} $A\otimes\mathfrak{F}$ }` gives $bold(A) times.o bold(frak(F))$. Note that the math version must be changed _before_ starting math mode.

== Sans-Serif Greek Letters
The class file also provides upright sans-serif Greek letters with `\sfalpha` and similar expressions (e.g., #{show math.equation: set text(font: "Lete Sans Math"); $upright(alpha), upright(beta), upright(gamma), upright(delta) dots$}), in case they are needed.

Under #pdfTeX boldface, upright, sans-serif Greek letters can be obtained with `\bm{\sfalpha}`, etc. The `newtx` package also includes options that affect whether Greek letters are upright or slanted (see that package's documentation for details).

Under #LuaLaTeX, boldface, sans-serif, upright Greek can be obtained with `\sfbfalpha`, etc., or by using `\symbfsfup{\alpha}`. In the first case, the glyphs are drawn from the Lete Sans Math font, while in the second case, the glyphs are from the TeX Gyre Termes Math font. Why are two different fonts being used? Unicode does not include medium-weight, upright, sans-serif Greek as a component of a serif font (like Termes), although it does include both upright and italic boldface Greek. However, in a sans-serif font (like Lete), Greek letters are sans-serif by default, including medium weight. (You can also invoke `\symbfsfit{\alpha}` for boldface, sans-serif, slanted type.)

#paragraph-heading[Sans-serif Math Versions] Two additional math versions, `sansbold` and `sans` are available in `asmeconf`. The former is used by default in captions and section headings. The latter is available in case you find a use for it. In #LuaLaTeX, both versions use the Lete Sans Math fonts. In #pdfTeX, the glyphs are from the `newtxsf` package.

== Controlling Calligraphic, Script, Fraktur, or BB Fonts
With #pdfTeX, the `[mathalpha]` package may be loaded in the preamble~@sharpe2.#footnote[As of v1.41, the `[mathalfa]` class option has been dropped.] This package supports variety of font for calligraphic, fraktur, script, and blackboard bold fonts. For example,
#align(center, `\usepackage[cal=euler,frak=boondox]{mathalpha}`)
#noindent[selects the Euler font for `\mathcal` and the Boondox font for `\mathfrak`. Refer to the `mathalpha` documentation for details~@sharpe2. The `[nofontspec]` option also supports `mathalpha`.]

Under #LuaLaTeX, the `unicode-math` `range` function can be used to select such fonts~@robertson2023. For example, the following code in the preamble would select the Euler Math font for calligraphic, script, fraktur, and blackboard bold fonts:
#quote(block: true)[
  #set par(justify: false)
  `\setmathfont{Euler-Math}[` \
  ` range={cal,scr,frak,bb},` \
  ` Extension=.otf,Scale=MatchUppercase]`
]

= Additional Options for #nocase(`asmeconf.cls`)
The class accepts a number of options in addition to those already described. These options are discussed next.

== Colored Hyperlinks
ASME requires that all text be *in black* when the paper is submitted for publication. For other uses, authors may
obtain colored hyperlinks with the [`colorlinks`] option.

== Final Column Balancing
The option `[balance]` invokes the the `flushend` package~@tolusis.
This package will attempt to give equal height to the two columns on the last page. The performance of this package is sometimes inconsistent (with odd page layout or, very rarely, errors), so use this option with caution.

== Grid-Style Author Block
The option `[grid]` invokes ASME's grid-style arrangement of author names. In the `\SetAuthors{..}` command, individual author's names are recognized by the commas that separate them. (To include a comma _in_ a name, enclose the name in braces.) Line breaks (`\\`) may be inserted into the address of `\SetAffiliation{n}{address}` as needed.

Note that ASME interprets the author order in the grid style by reading names from left-to-right in the top row, then left-to-right in each subsequent row.

== Line Numbers
The option `[lineno]` invokes the the `lineno` package~@bottcher. This option will produce line numbers in the margins. You must run #LaTeX _twice_ for proper placement of the numbers. Tables, captions, and footnotes will not be numbered. Line numbers can be helpful for review and editing, but should not be used in your final manuscript. See the documentation of the `lineno` package for further commands to control line numbering.

The `lineno` package is not compatible with the `flushend` package that makes final short columns the same height. Balancing is automatically disabled when this option is called.

== Changing the Copyright Footer
The option `[nofoot]` will omit the ASME copyright from the page footer. The option `[govt]` will produce a copyright notice for authors who are employees of the U. S. Government.
The option `[contractor]` will produce a copyright
notice for authors who are employed by a U. S. Government contractor.
The option `[somegovt]` gives a copyright notice for the case when only some authors are employees of the U. S. Government.

The footers are generated with the `fancyhdr` package~@oostrum and can be changed using the commands of that package. Only the default arrangement matches ASME's style, however.

In addition, the conference header on the title page can be omitted using the option `[nohead]`.

== Archivability: PDF/A
In June 2022, the #LaTeX\3 team added support for PDF/A to the #LaTeX kernel through the command `\DocumentMetadata{..}`. This approach works with _both_ #pdfTeX and #LuaLaTeX. Note that accessible conformance~(`a` or `UA-2` level, a.k.a. "well-tagged PDF") is still under development by the #LaTeX\3 team.

As of `asmeconf` v1.41, the legacy options `[pdf-a]`, `[pdfapart=]`, and `[pdfaconformance=]` have been dropped.

== Typewriter Font Options
This font is the sans-serif `inconsolata`. By default, the word spacing is variable, but option `[mono]` switches to monospacing. A slashed zero is the default; option `[var0]` removes the slash. Option `[hyphenate]` enables hyphenation. (The hyphenation option is not available under #LuaLaTeX with `fontspec`.)

== Support for Other Languages
This package can be adapted to incorporate (or entirely use) languages other than English. See @appendix:c for details.

= Nomenclature Environment
A nomenclature environment is included, as illustrated just after the abstract. Each item in the nomenclature list is entered as `\entry{symbol}{meaning}`. Optional subheadings can be included as well: `\EntryHeading{Roman letters}`. The environment includes an optional argument for changing the space between symbols and definitions,
`\begin{nomenclature}[Xcm]`, where X is a number and cm can be replaced by any LaTeX dimensional unit: pt, in, ex, em, pc, etc. The default value is~2~em.

The title of the nomenclature can be also changed, e.g. `\renewcommand*{\nomname}{List of Symbols}`.

= Conclusion
Provide a brief conclusion (3 to 4 lines).

#heading(numbering: none)[Acknowledgments]
Place any acknowledgments here.

// ===== REFERENCES ===========================================================
// full: true lists every entry in the .bib file (like \nocite{*}); delete it for normal use.
// The reference style is set by the template (asmeconf.csl, or asmeconf-strict.csl with strict: true).
#bibliography("asmeconf-sample-typst.bib", full: true)

// ===== APPENDICES ===========================================================
#show: appendix

= The vector product $arrow(A) times arrow(B)$ <appendix:a>

This brief illustration of an appendix shows the numbering of the appendix and equations. Equations are numbered
consecutively, following those in the paper. Consider $rho eq.not "fn"(p)$:
$
  (d Gamma) / (d t) & = d / (d t) integral_cal(C) bold(upright(u)) dot d bold(upright(r)) \
  & = integral_cal(C) (D bold(upright(u))) / (D t) dot d bold(upright(r)) + underbrace(integral_cal(C) bold(upright(u)) dot d lr(( (d bold(upright(r))) / (d t) )), = 0) \
  & = integral.double_cal(S) nabla times (D bold(upright(u))) / (D t) dot d bold(upright(A)) \
  & = integral.double_cal(S) nabla p times nabla (1 / rho) dot d bold(upright(A))
$

= Use with #nocase[LuaLaTeX] <appendix:b>

The #LuaLaTeX engine is useful with `asmeconf` in at least three situations:

/ Executing lua code directly in your #LaTeX file.: With lua code, complicated functions can be plotted or numerical integration can be executed. An example file in the distribution demonstrates this capability~@lienhard2025. In this situation, you can use the class option `[nofontspec]` to stay with the `newtx` fonts. (This setting does not support non-Latin alphabets.)

/ Using complex alphabets.: With #pdfTeX, `asmeconf` supports Latin alphabets, as well as Cyrillic, Greek, and Vietnamese. With #LuaLaTeX with the `fontspec` package you can use non-Latin fonts available on your computer if you call the `[loadscripts]` option.#footnote[For Latin scripts (including English) under #LuaLaTeX, you _must_ have these OpenType fonts (`.otf`) installed (all are in TeX Live and will be present if your installation is complete and up-to-date): TeX Gyre Termes X, TeX Gyre Termes Math, TeX Gyre Heros, Inconsolatazi4, LeteSansMath, STIX Two Math. For Greek and Russian, the Noto Serif, Sans, and Mono TrueType fonts (`.ttf`) are used, and other Noto fonts are used for south and east Asian scripts. The Noto fonts are *not* currently in TeX Live (go here: #link("https://github.com/googlefonts/noto-fonts")[github.com/googlefonts/noto-fonts]).]#super[,]#footnote[The `[loadscripts]` option was added in v1.42 of `asmeconf`, in order to reduce compilation time when non-Latin scripts are not needed.] For Japanese in particular, use the class option `[japanese]`. See the example file in this distribution for more details~@lienhard2021.

/ Accessibility and Well-tagged PDF.: As of the November 2025 release of #LaTeX, the `asmeconf` class can produce PDF files that meet the machine-testable requirements of the PDF/UA-2 and WTPDF 1.0 accessibility standards and the PDF/A-4f archivability standard. For this, run #LuaLaTeX and choose the following settings:
  ```
  \DocumentMetadata{
     pdfversion = 2.0, % default setting
     pdfstandard = { ua-2 , a-4f },
     tagging-setup={math/setup=mathml-SE},
     tagging = on }
  ```
  Note that figure files must be compatible with the standard (e.g., provided as PDF/A-3u or jpg), and that subcaptions _are not_ compatible with the standard. Not all language options are compatible with tagging.

  Tagged PDF files can render accurately as HTML files (see #link("https://ngpdf.com")[ngpdf.com]). Since version 1.44, `asmeconf` has included a CSS style sheet to control web appearance, `asmeconf-style.css`.

For clarity, `fontspec` and `unicode-math` are automatically loaded when `asmeconf` is run under #LuaLaTeX. Those packages require that the necessary fonts are available on your computer. If you wish to use #LuaLaTeX without the features of `unicode-math` and `fontspec`, use the class option `[nofontspec]`.

Over the long-term, #LuaLaTeX will become the preferred engine for using #LaTeX (see #link("https://www.latex-project.org/news/latex2e-news/ltnews40.pdf")[_LaTeX News_, Issue~40]). Access to #LuaLaTeX is different in each #LaTeX platform. Check the documentation for your platform to load #LuaLaTeX.

= Multilingual Support <appendix:c>

ASME publishes in English, but the `babel` package is loaded for
users who may wish to include other languages. For example, an author might wish to include an appendix that provides the
abstract in another language.

When more than one language option is included in `\documentclass[..]{asmeconf}`, English will be
set as the document's main language. (To choose a different main language, set `[main=..]`).
If no language options are given, the package defaults to English. As examples, a passage in German is
shown in #ref(<app:pohlhausen>, supplement: [Anhang]),
followed by abstracts in other languages.

The input encoding can be utf-8, as for these glyphs:
àáâäæãåā èéęëêēė îïíīįì ôöòóœøōõ ûüùúū çćč ł ñń ßśš ÿ žźż.

Fonts similar to Times/Helvetica are used when Greek, Vietnamese, or selected cyrillic-alphabet languages are called as options under #pdfTeX. Using #LuaLaTeX, which loads the fontspec package, many additional scripts are available; see the supplemental notes for such usage~@lienhard2021. Possibilities include Arabic, Bengali, Chinese, Devanagari (e.g., for Hindi), Hangul (for Korean), Kana (for Japanese), and Tamil. _These options require an up-to-date #LaTeX installation._

The `asmeconf` class defines several switches that can be used to call languages only when certain class options have been called, as `\if...\fi`: `\ifScriptsLoaded`, `\ifFontspecLoaded`, `\ifpdftex`, and `\ifJapaneseLoaded`.

The bibliography style, `asmeconf.bst`, is designed in English and aimed at #BibTeX.

#foreign("de")[
  = Wärmeaustausch und Reibungswiderstand (#nocase[von] E. Pohlhausen) <app:pohlhausen>
  In einer strömenden Flussigkeit sind Wärmeleitung und Wärmekonvektion Vorgänge, die mit der inneren Reibung (oder Impulsleitung) und mit der Impulskonvektion große Aehnlichkeit besitzen. Mathematisch findet dies seinen Ausdruck in dem gleichartigen Bau der Differentialgleichungen, die einerseits für die Temperatur und anderseits für den Geschwindigkeitsvektor in der Flüssigkeit bestehen. Man kann daraus auf eine Beziehung
  zwischen dem Wärmeaustanch und dem Reibungswiderstand schließen, die eine strömende Flüssigkeit an einem festen Körper hervorrufen. Dies ist zuerst von Prandtl ausgesprochen und durchgeführt worden, und zwar für turbulente Vorgänge, unter der vereinfachenden Annahme von Wärmequellen und -senken im Innern der Flüssigkeit~@pohlhausen1921.
]

// Abstracts in other languages (unnumbered headings, italic text)
#let other-abstract(lang, title, body) = foreign(lang, {
  heading(numbering: none, outlined: false, title)
  text(style: "italic", body)
})

#other-abstract("vi", [Tóm tắt nội dung])[Đây là phần tóm tắt của bài báo khoa học. Chúng tôi viết bằng tiếng Việt. Vấn đề, các phương pháp và các kết quả được mô tả trong phần này. Tài liệu tham khảo cũng được bao gồm.]

#other-abstract("el", [Περίληψη])[Αυτή είναι η περίληψη του άρθρου. Χρησιμοποιούμε την ελληνική γλώσσα. Περιγράφεται το πρόβλημα, οι μέθοδοι και τα αποτελέσματα. Περιλαμβάνονται επίσης αναφορές.]

#other-abstract("ru", [Аннотация])[Это резюме статьи. Пишем по русски. Описаны проблема, методы и результаты. Библиография также включена.]

#other-abstract("vi", [Tóm tắt nội dung])[Đây là phần tóm tắt của bài báo khoa học. Chúng tôi viết bằng tiếng Việt. Vấn đề, các phương pháp và các kết quả được mô tả trong phần này. Tài liệu tham khảo cũng được bao gồm.]
