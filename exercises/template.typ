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

// - [ ] E.A.4.1 - Algoritmi a miglioramento iterativo, N-Queens
// - [ ] E.A.4.2 - Algoritmi a miglioramento iterativo, HP 2D-Protein Folding
// - [ ] E.A.5.9 - CSP, Meetings
// - [~] E.A.6.7 - SAT, HC-VIP
// - [~] E.A.6.8 - SAT, Graph colouring with red self-loops
// - [ ] E.A.6.9 - SAT, Cards
// - [ ] E.B.1.5 - FOL, Club delle Alpi, modelling e inferenza
// - [~] E.B.2.1 - PDDL, Torri di Hanoi, modelling
// - [ ] E.B.2.2 - PDDL, Domino, modelling
// - [ ] E.B.3.2.2.1 - BN, I Rossi, Modelling - IA
// - [ ] E.B.1.4 - FOL, Aldo, inferenza
// - [ ] E.B.1.2 - FOL, Studenti ansiosi, inferenza
// - [ ] E.A.3.3 - Esplorazione di spazi degli stati, HP 2D-Protein Folding
// - [ ] E.A.6.7 - SAT, HC-VIP - Soluzione

// - [x] E.A.5.8 - CSP, Social Golfers
// - [x] E.A.6.1 - Logica proposizionale, Risoluzione 1
// - [x] E.A.6.2 - Logica proposizionale, Risoluzione 2
// - [x] E.A.6.4 - SAT, N-Queens

// - [x] - E.A.3.1 - Esplorazione di spazi degli stati 1
// - [x] - E.A.3.2 - Esplorazione di spazi degli stati 2
// - [ ] E.A.4.1 - Algoritmi a miglioramento iterativo, N-Queens
// - [ ] E.A.4.2 - Algoritmi a miglioramento iterativo, HP 2D-Protein Folding
// - [x] - E.A.5.2 - CSP, N-Queens
// - [x] - E.A.5.1 - CSP, steepest descent
// - [x] - E.A.5.3 - CSP, Edge colouring
// - [x] - E.A.5.6 - CSP, Cards
// - [x] - E.A.5.7 - CSP, Cards 2
// - [x] E.A.5.8 - CSP, Social Golfers
// - [ ] E.A.5.9 - CSP, Meetings
// - [x] E.A.6.1 - Logica proposizionale, Risoluzione 1
// - [x] E.A.6.2 - Logica proposizionale, Risoluzione 2
// - [x] - E.A.6.3 - Logica proposizionale, DPLL 1
// - [x] E.A.6.4 - SAT, N-Queens
// - [x] - E.A.6.5 - SAT, Schur's lemma
// - [x] - E.A.6.6 - SAT, Edge colouring
// - [~] E.A.6.7 - SAT, HC-VIP
// - [~] E.A.6.8 - SAT, Graph colouring with red self-loops
// - [ ] E.A.6.9 - SAT, Cards
// - [x] - E.B.1.1 - FOL, Studenti ansiosi, modelling
// - [x] - E.B.1.3 - FOL, Aldo, modelling
// - [ ] E.B.1.5 - FOL, Club delle Alpi, modelling e inferenza
// - [~] E.B.2.1 - PDDL, Torri di Hanoi, modelling
// - [ ] E.B.2.2 - PDDL, Domino, modelling
// - [ ] E.B.3.2.2.1 - BN, I Rossi, Modelling - IA
// - [ ] E.B.1.4 - FOL, Aldo, inferenza
// - [ ] E.B.1.2 - FOL, Studenti ansiosi, inferenza
// - [x] - E.A.5.4 - CSP, Generalised Arc-Consistency
// - [x] - E.A.5.5 - CSP, Backtracking e Propagazione di Vincoli
// - [ ] E.A.3.3 - Esplorazione di spazi degli stati, HP 2D-Protein Folding

// - [x] - E.A.6.3 - Logica proposizionale, DPLL 1 - Soluzione (LETTERE DI TSITSING)
// - [x] - E.A.6.5 - SAT, Schur's lemma - Soluzione
// - [x] - E.A.6.6 - SAT, Edge colouring - Soluzione
// - [ ] E.A.6.7 - SAT, HC-VIP - Soluzione
// - [x] - E.A.6.4 - SAT, N-Queens - Soluzione
// - [x] - E.B.1.1 - FOL, Studenti ansiosi, modelling - Soluzione
// - [x] - E.B.1.3 - FOL, Aldo, modelling - Soluzione
