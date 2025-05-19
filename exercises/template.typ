#let conf(title, doc) = {
  set text(font: "New Computer Modern", lang: "it", weight: "light", size: 11pt)
  set page(margin: 1.75in)
  // set par(leading: 0.55em, spacing: 0.85em, first-line-indent: 1.8em, justify: true)
  set par(leading: 0.55em, spacing: 0.85em, justify: true)
  set math.equation(numbering: "(1)")
  set heading(numbering: "1.1")
  set raw(lang: "Rust")
  set table(stroke: 0.25pt)
  set list(marker: [--])

  show math.equation.where(block: true): set block(breakable: true)
  show figure.caption: set align(center)
  show heading: set block(above: 1.4em, below: 1em)
  show raw: set text(font: "CaskaydiaCove NFM", lang: "it", weight: "light", size: 9pt)
  show sym.emptyset: sym.diameter

  heading(numbering: none, title)
  context counter(heading).step()
  doc
}

#let minizinc(body) = [
  #show raw.where(block: true): block.with(
    inset: 1em,
    width: 100%,
    fill: luma(254),
    stroke: (left: 5pt + luma(245), rest: 1pt + luma(245)),
  )

  #show regex("constraint"): set text(red)
  #show regex("array|var"): set text(red)

  #body
]
