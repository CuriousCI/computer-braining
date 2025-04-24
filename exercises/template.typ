#let conf(title, doc) = {
  set text(font: "New Computer Modern", lang: "it", weight: "light", size: 11pt)
  set page(margin: 1.75in)
  set par(leading: 0.55em, spacing: 0.85em, first-line-indent: 1.8em, justify: true)
  set math.equation(numbering: "(1)")
  set heading(numbering: "1.1")
  set raw(lang: "Rust")

  show figure.caption: set align(center)
  show heading: set block(above: 1.4em, below: 1em)
  show raw: set text(font:"CaskaydiaCove NFM", lang: "it", weight: "light", size: 9pt)
  show sym.emptyset : sym.diameter 

  heading(numbering: none)[E.A.5.7 (Cards 2)]
  context counter(heading).step()
  doc
}
