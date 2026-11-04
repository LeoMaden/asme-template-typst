// asmeconf.typ — a Typst template for ASME conference papers
//
// A Typst port of the layout produced by John H. Lienhard's asmeconf LaTeX class
// (https://ctan.org/pkg/asmeconf, v1.47), following ASME's formatting guidelines:
// https://www.asme.org/publications-submissions/proceedings/formatting-the-paper
//
// Usage: see asmeconf-template.typ.  Compile with the bundled fonts:
//     typst compile --font-path fonts asmeconf-template.typ
//
// License: MIT (as for asmeconf).

// ---------------------------------------------------------------------------
//  Font sets
// ---------------------------------------------------------------------------
//
// "texgyre"    : TeX Gyre Termes / Heros / Inconsolata, as used by asmeconf (default).
// "liberation" : Liberation Serif / Sans / Mono (metric clones of Times New Roman / Arial).
// "msfonts"    : Times New Roman / Arial / Courier New, the fonts named by ASME (if installed).
//
// `sans-scale` mirrors asmeconf's helvratio = 0.91 (Helvetica scaled to Times' x-height).
// Set it to 1.0 for nominal Arial sizes (e.g. title exactly 11 pt).

#let _fontsets = (
  texgyre: (
    serif: ("TeX Gyre Termes", "Liberation Serif"),
    sans: ("TeX Gyre Heros", "Liberation Sans"),
    mono: ("Inconsolatazi4", "DejaVu Sans Mono"),
    math: ("TeX Gyre Termes Math",),
    sans-math: ("Lete Sans Math", "TeX Gyre Termes Math"),
    sans-scale: 0.91,
    mono-scale: 1.03,
  ),
  liberation: (
    serif: ("Liberation Serif",),
    sans: ("Liberation Sans",),
    mono: ("Liberation Mono",),
    math: ("TeX Gyre Termes Math",),
    sans-math: ("Lete Sans Math", "TeX Gyre Termes Math"),
    sans-scale: 1.0,
    mono-scale: 0.95,
  ),
  msfonts: (
    serif: ("Times New Roman", "Liberation Serif"),
    sans: ("Arial", "Liberation Sans"),
    mono: ("Courier New", "Liberation Mono"),
    math: ("TeX Gyre Termes Math",),
    sans-math: ("Lete Sans Math", "TeX Gyre Termes Math"),
    sans-scale: 1.0,
    mono-scale: 0.95,
  ),
)

// The active font set is stored in state so helper functions can read it.
#let _fonts = state("asmeconf-fonts", _fontsets.texgyre)
#let _opts = state("asmeconf-opts", (:))

// Sans-serif text at a nominal size (scaled as asmeconf does).
#let _sans(body, size: 10pt, weight: "regular") = context {
  let f = _fonts.get()
  text(font: f.sans, size: size * f.sans-scale, weight: weight, body)
}

// ---------------------------------------------------------------------------
//  Case handling: \MakeTextUppercase and \NoCaseChange
// ---------------------------------------------------------------------------

// Wrap text that must not be uppercased in titles and section headings, e.g.
//   = Reference Formatting with #nocase(`asmeconf.bst`)
#let nocase(body) = [#box(body)<asme-nocase>]

// Uppercase content recursively, leaving math, citations, references, footnotes,
// and anything wrapped in `nocase` untouched (like LaTeX's \MakeTextUppercase).
#let _upper(c) = {
  if type(c) == str { return upper(c) }
  if type(c) != content { return c }
  if c.at("label", default: none) == <asme-nocase> { return c }
  let f = c.func()
  if f in (math.equation, cite, ref, footnote, metadata, linebreak, h, v) { return c }
  if f == text { return upper(c) }
  if f == raw { return upper(c) }
  if c.has("children") { return c.children.map(_upper).join() }
  if f == strong { return strong(_upper(c.body)) }
  if f == emph { return emph(_upper(c.body)) }
  if f == link { return link(c.dest, _upper(c.body)) }
  if f == box { return box(_upper(c.body)) }
  if f == super { return super(_upper(c.body)) }
  if f == sub { return sub(_upper(c.body)) }
  if f == smallcaps { return _upper(c.body) }
  if c.has("child") { return upper(c) } // styled content: cannot be rebuilt
  if c.has("body") { return upper(c) }
  c
}

// ---------------------------------------------------------------------------
//  Public helpers
// ---------------------------------------------------------------------------

// Run-in, unnumbered sub-subsection heading (LaTeX \subsubsection*{..}).
#let paragraph-heading(title) = {
  parbreak()
  v(6pt, weak: true)
  context {
    let f = _fonts.get()
    text(font: f.sans, size: 10pt * f.sans-scale, weight: "bold", title)
  }
  h(0.5em)
}

// Continue a paragraph after a display equation, quote, or centered block without
// a first-line indent (in LaTeX: no blank line after \end{equation}).
#let noindent(body) = {
  set par(first-line-indent: 0pt)
  body
}

// Nomenclature list (LaTeX nomenclature environment).
//   #nomenclature(
//     [Roman letters],                       // a content item is a subheading
//     ($k$, [Thermal conductivity [W m$^(-1)$ K$^(-1)$]]),
//     ...
//   )
#let nomenclature(title: [Nomenclature], label-width: 2em, ..items) = {
  heading(level: 1, numbering: none, outlined: true, title)
  set par(justify: false, first-line-indent: 0pt)
  for it in items.pos() {
    if type(it) == array {
      block(above: 2pt, below: 2pt, inset: (left: 1.3em), grid(
        columns: (label-width - 0.3em, 1fr),
        column-gutter: 1em,
        it.at(0), it.at(1),
      ))
    } else {
      block(above: 5pt, below: 2pt, sticky: true, emph(it))
    }
  }
}

// Appendix: switch section numbering to A, B, C ...
//   #show: appendix
#let appendix(body) = {
  counter(heading).update(0)
  set heading(numbering: "A.1", supplement: [Appendix])
  body
}

// Text in another language (sets hyphenation, quotes, and "Appendix"/"Anhang", etc.)
#let foreign(lang, body) = {
  set text(lang: lang)
  body
}

// Two-column-spanning figure/table: use figure(scope: "parent", placement: top, ...)

// ---------------------------------------------------------------------------
//  Main template
// ---------------------------------------------------------------------------

#let asmeconf(
  // Conference header (first page, top right)
  conf-name: none,
  conf-acronym: none,
  conf-date: none,
  conf-city: none,
  paper-no: [Add paper number],
  // Title and authors
  title: [Missing title!],
  authors: (),
  // Each author: (name: "..", affil: 1 or (1, 2), joint-first: false, corresponding: false)
  affiliations: (:),
  // Keys are affiliation tags (as strings), values are addresses.
  corresponding-email: none,
  // Front matter
  abstract: none,
  keywords: (),
  version-note: none,
  // PDF metadata
  pdf-title: none,
  pdf-author: none,
  pdf-keywords: (),
  // Options (mirroring asmeconf class options)
  // strict: false reproduces the asmeconf LaTeX output (sans-serif scaled to 0.91, TeX Gyre fonts,
  //   asmeconf.bst-style references, optional coloured links, hanging punctuation).
  // strict: true follows the ASME written specification exactly: Arial/Times New Roman at the
  //   nominal sizes (header 10 pt, paper number 16 pt, title 11 pt, headings 10 pt), all text black,
  //   nothing protruding into the margins, and serial commas in reference author lists.
  strict: false,
  fonts: auto,             // auto | "texgyre" | "liberation" | "msfonts" | a custom dictionary
                           //   auto = "texgyre" (strict: false) or "msfonts" (strict: true)
  colorlinks: false,       // [colorlinks]; ASME wants black text in the final paper
  lineno: false,           // [lineno]
  grid: false,             // [grid]  author blocks in a grid
  head: true,              // false = [nohead]
  footer: "asme",          // "asme" | "none" (nofoot) | "govt" | "govtsome" | "contractor"
  unboldcaption: false,    // [unboldcaption]
  lang: "en",
  region: "US",
  year: datetime.today().year(),
  body,
) = {
  let fonts = if fonts == auto { if strict { "msfonts" } else { "texgyre" } } else { fonts }
  let f = if type(fonts) == dictionary { _fontsets.texgyre + fonts } else { _fontsets.at(fonts) }
  // ASME specifies nominal Arial sizes; asmeconf scales Helvetica to 0.91 to match the x-height of Times.
  if strict { f.sans-scale = 1.0 }
  let colorlinks = colorlinks and not strict
  // corresponding-author mark: ASME uses a plain asterisk; asmeconf uses the math asterisk
  let ca-mark = if strict { "*" } else { "∗" }
  _fonts.update(f)
  let sans-size(s) = s * f.sans-scale
  let linkcolor = if colorlinks { rgb(0, 0, 160) } else { black }
  let urlcolor = if colorlinks { rgb(0, 80, 180) } else { black }

  // ---- Document metadata -------------------------------------------------
  let plain(c) = if type(c) == str { c } else if c == none { none } else {
    // crude conversion of content to a string for the PDF metadata
    if c.has("text") { c.text } else if c.has("children") { c.children.map(plain).filter(x => x != none).join() } else if c.has("body") { plain(c.body) } else { " " }
  }
  set document(
    title: if pdf-title != none { pdf-title } else { plain(title) },
    author: if pdf-author != none { pdf-author } else { authors.map(a => plain(a.name)) },
    keywords: pdf-keywords,
  )

  // ---- Page --------------------------------------------------------------
  let copyright-note = (
    govt: [This material is declared a work of the U.~S.~Government and is not subject to copyright protection in the United States. \ Approved for public release; distribution is unlimited.],
    contractor: text(size: 8pt)[The United States Government retains, and by accepting the article for publication, the publisher acknowledges that the United States Government retains, a non-exclusive, paid-up, irrevocable, worldwide license to publish or reproduce the published form of this work, or allow others to do so, for United States Government purposes.],
    govtsome: [This work was authored in part by a U.~S. Government employee in the scope of his/her employment. ASME disclaims all interest in the U.~S. Government's contribution.],
  )
  set page(
    paper: "us-letter",
    margin: (left: 0.5in, right: 0.5in, top: 0.5in, bottom: 1in),
    columns: 2,
    footer-descent: if footer in ("asme", "none") { 0.5in - 7pt } else { 0.3in - 7pt },
    footer: context {
      set text(size: 10pt)
      let n = counter(page).display()
      if footer == "asme" {
        std.grid(columns: (1fr, auto, 1fr), [], n, align(right)[Copyright ©#year by ASME])
      } else if footer == "none" {
        align(center, n)
      } else {
        set par(justify: false, first-line-indent: 0pt)
        align(center)[#n \ #v(0.5em, weak: true) #text(size: 9pt, copyright-note.at(footer))]
      }
    },
  )
  set columns(gutter: 0.38in)

  // ---- Text --------------------------------------------------------------
  set text(
    font: f.serif,
    size: 10pt,
    lang: lang,
    region: region,
    overhang: not strict,
    top-edge: 0.7em,
    bottom-edge: -0.3em,
  )
  // 10/12 pt type: 10 pt line box + 2 pt leading = 12 pt baselineskip
  set par(
    justify: true,
    leading: 2pt,
    spacing: 2pt,
    first-line-indent: (amount: 15pt, all: true),
  )
  show raw: set text(font: f.mono, size: 1.25em * f.mono-scale)
  show raw.where(block: true): set block(above: 8pt, below: 8pt)
  show raw.where(block: true): set par(justify: false)
  show math.equation: set text(font: f.math)
  show math.equation.where(block: true): set block(above: 8pt, below: 8pt)
  // A numbering function (rather than "(1)") keeps the parentheses in references, also with the equate package
  set math.equation(numbering: (..n) => "(" + n.pos().map(str).join(".") + ")", supplement: [Eq.])

  // Lists
  set list(indent: 1em)
  set enum(indent: 1em)
  show terms: it => {
    for item in it.children {
      block(above: 4pt, below: 4pt, inset: (left: 1em), {
        set par(first-line-indent: (amount: 15pt, all: false))
        [#h(-1em)#strong(item.term)#h(0.5em)#item.description]
      })
    }
  }
  show quote.where(block: true): it => block(inset: (left: 1.5em, right: 1.5em), above: 6pt, below: 6pt, {
    set par(first-line-indent: 0pt)
    it.body
  })

  // Links, references, citations
  show link: set text(fill: urlcolor)
  show ref: set text(fill: linkcolor)
  show cite: it => {
    // colour only the numbers, not the brackets (as hyperref does)
    show regex("\d+"): set text(fill: linkcolor)
    it
  }

  // Footnotes (LaTeX \footnotesize = 8/9.5 pt)
  set footnote.entry(
    separator: line(length: 40%, stroke: 0.4pt),
    clearance: 8pt,
    gap: 2pt,
    indent: 0pt,
  )
  show footnote.entry: it => {
    set par.line(numbering: none)
    set text(size: 8pt)
    set par(leading: 1.5pt, first-line-indent: 0pt, hanging-indent: 0pt, justify: true)
    let loc = it.note.location()
    let num = numbering(it.note.numbering, ..counter(footnote).at(loc))
    [#h(1em)#super(num)#it.note.body]
  }

  // Line numbers
  set par.line(numbering: if lineno { n => text(size: 7pt, font: f.serif, fill: luma(80), str(n)) } else { none }, numbering-scope: "page")

  // ---- Headings ----------------------------------------------------------
  set heading(numbering: "1.1", supplement: [Sect.])
  show heading: it => {
    set par(first-line-indent: 0pt, justify: false)
    set text(font: f.sans, size: sans-size(10pt), weight: "bold", hyphenate: false)
    show math.equation: set text(font: f.sans-math, weight: "bold")
    let num = if it.numbering != none {
      counter(heading).display(it.numbering) + h(1em)
    }
    let body = if it.level == 1 { _upper(it.body) } else { it.body }
    block(above: 14pt, below: 6pt, sticky: true, [#num#body])
  }

  // ---- Figures, tables and captions ----------------------------------------
  set figure(placement: top, gap: 8pt)
  set figure.caption(separator: [: ])
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.where(kind: image): set figure(supplement: [Fig.])
  show figure.where(kind: table): set figure(supplement: [Table])
  show figure: set block(above: 10pt, below: 10pt)
  show figure: set par.line(numbering: none)
  show figure: it => {
    if it.kind == image { counter(figure.where(kind: "subfigure")).update(0) }
    it
  }
  set table(stroke: none, inset: (x: 6pt, y: 1.2pt))
  show table: set block(above: 4pt, below: 4pt)
  show table: set par(justify: false, first-line-indent: 0pt)
  show figure.caption: it => {
    set par(first-line-indent: 0pt, justify: true)
    set text(font: f.sans, size: sans-size(if it.kind == "subfigure" { 9pt } else { 9pt }))
    show math.equation: set text(font: f.sans-math)
    let is-sub = it.kind == "subfigure"
    let name = if it.kind == image { "Figure" } else if it.kind == table { "Table" } else { it.supplement }
    let lab = if is-sub {
      [(#context it.counter.display("a")) ]
    } else {
      [#upper(name) #context it.counter.display(it.numbering): ]
    }
    let weight = if unboldcaption and not is-sub { "regular" } else { "bold" }
    show math.equation: set text(weight: weight)
    let content = [#strong(lab)#text(weight: weight, it.body)]
    layout(size => {
      if measure(content).width <= size.width { align(center, content) } else { content }
    })
  }

  // ---- Bibliography ------------------------------------------------------
  set bibliography(
    title: [References],
    style: if strict { "asmeconf-strict.csl" } else { "asmeconf.csl" },
  )
  show bibliography: it => {
    set par(first-line-indent: 0pt, justify: true)
    set text(size: 10pt)
    it
  }

  // ---- Title block -------------------------------------------------------
  let author-marks(a) = {
    let affs = a.at("affil", default: none)
    let affs = if affs == none { () } else if type(affs) == array { affs } else { (affs,) }
    let marks = affs.map(str)
    if a.at("joint-first", default: false) { marks.push("†") }
    if a.at("corresponding", default: false) { marks.push(ca-mark) }
    marks.join(",")
  }
  let has-jfa = authors.any(a => a.at("joint-first", default: false))
  let has-ca = authors.any(a => a.at("corresponding", default: false))

  let header = {
    set par(first-line-indent: 0pt, justify: false, leading: 2pt)
    set text(font: f.sans, weight: "bold", size: sans-size(10pt))
    if head {
      align(right)[
        #conf-name \
        #conf-acronym \
        #conf-date, #conf-city
      ]
      v(24pt - 2pt)
      align(right, text(size: sans-size(16pt), paper-no))
      v(36pt - 2pt)
    } else {
      v(108pt)
    }
    show math.equation: set text(font: f.sans-math, weight: "bold")
    align(center, text(size: sans-size(11pt), _upper(title)))
    v(24pt - 2pt)
  }

  let author-block = {
    set par(first-line-indent: 0pt, justify: false, leading: 2pt)
    set text(font: f.sans, size: sans-size(10pt))
    if not grid {
      align(center, text(weight: "bold", authors.map(a => [#a.name#super(typographic: false, author-marks(a))]).join([, ])))
      v(10pt)
      for (k, addr) in affiliations.pairs() {
        align(center)[#if k != "" { super(typographic: false, k) }#addr]
      }
    } else {
      // Traditional grid: one block per affiliation, three blocks per row.
      let cells = affiliations.pairs().map(((k, addr)) => {
        let names = authors.filter(a => {
          let af = a.at("affil", default: none)
          let af = if type(af) == array { af } else { (af,) }
          af.map(str).contains(k)
        })
        align(center)[
          #for a in names [#text(weight: "bold")[#a.name#super(author-marks(a).replace(regex("^\d+,?"), ""))] \ ]
          #addr
        ]
      })
      align(center, std.grid(columns: calc.min(cells.len(), 3) * (0.3 * 7.5in,), column-gutter: 0.03 * 7.5in, row-gutter: 12pt, ..cells))
    }
    v(39pt)
  }

  place(top, float: true, scope: "parent", clearance: 0pt, block(width: 100%, {
    header
    author-block
  }))

  // Title-page footnotes: joint first authors, corresponding author, version note.
  // The markers are hidden; the symbols already appear in the author line.
  place(top + left, {
    show footnote: it => hide(it)
    if has-jfa { footnote(numbering: _ => "†")[Joint first authors] }
    if has-ca {
      footnote(numbering: _ => ca-mark)[Corresponding author#if corresponding-email != none [: #corresponding-email]]
    }
    if version-note != none { footnote(numbering: _ => "", version-note) }
  })
  counter(footnote).update(0)

  // ---- Abstract and keywords ----------------------------------------------
  if abstract != none {
    heading(level: 1, numbering: none, [Abstract])
    {
      set text(style: "italic")
      abstract
    }
    if keywords.len() > 0 {
      parbreak()
      v(3pt)
      block({
        set par(first-line-indent: 0pt)
        [#text(font: f.sans, size: sans-size(10pt), weight: "bold")[Keywords:] #keywords.join(", ")]
      })
    }
  }

  body
}
