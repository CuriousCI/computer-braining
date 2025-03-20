#set text(font: "New Computer Modern", lang: "it", weight: "light", size: 11pt)
#set page(margin: 1.75in)
#set par(leading: 0.55em, spacing: 0.85em, first-line-indent: 1.8em, justify: true)
#set math.equation(numbering: "(1)")

#show figure: set block(breakable: true)
#show figure.caption: set align(center)
#show heading: set block(above: 1.4em, below: 1em)
#show outline.entry.where(level: 1): it => { show repeat : none; v(1.1em, weak: true); text(size: 1em, strong(it)) }
#show raw: set text(font:"CaskaydiaCove NFM", lang: "it", weight: "light", size: 9pt)
#show sym.emptyset : sym.diameter 

#let reft(reft) = box(width: 8pt, place(dy: -8pt, 
  box(radius: 100%, width: 9pt, height: 9pt, inset: 1pt, stroke: .5pt, // fill: black,
    align(center + horizon, text(font: "CaskaydiaCove NFM", size: 7pt, repr(reft)))
  )
))

#let small(t) = text(size: 0.7em, str(t))
#let yellow = rgb("#ffbf00")
#let yellow = rgb("#fabd2f")
#let blue = rgb("#83a598")
#let green = rgb("#b8bb26")

#set heading(numbering: "1.1")
#set raw(lang: "Rust")
#set table(stroke: 0.25pt)

= E.A.3.2

Implementazioni in `Rust` e esercizi 
- #link("https://github.com/CuriousCI/artificial-intelligence")[https://github.com/CuriousCI/artificial-intelligence]

== Ricerca in profondità 
DFS (depth first search); \ \

*NOTA*: nella DFS viene *ignorato* l'ordine alfabetico per archi di pari merito; per come è stata definita l'interfaccia della frontiera i singoli inserimenti sono indipendenti... il problema si potrebbe aggirare trasformando la *stack* in una *priority-queue*, però non vale la pena sbattere la testa su questi dettagli, il concetto è chiaro.

*NOTA*: lo stesso problema c'è per l'*approfondimento iterativo*, perché non faccio altro che chiamare la versione iterativa della ricerca con la stessa frontiera del DFS.

\

#align(center)[
#table(
  columns: (auto, auto, 4em, 6em, auto),
  align: (center + horizon, center + horizon, center + horizon, center + horizon, start) ,
  table.header([\#], [], [*azioni*], [*esplorati*], [*frontiera*]),

[0], $emptyset$, ``, `{}`, `(S, p: -, g: 0, h: 20, f: 20, d: 0)`,

[1], `S`, `A, B, D`, `{S}`, 
`(D, p: S, g: 3, h: 17, f: 20, d: 1)
(B, p: S, g: 3, h: 16, f: 19, d: 1)
(A, p: S, g: 3, h: 16, f: 19, d: 1)
`,

[2], `D`, `C`, `{D, S}`, 
`(C, p: D, g: 5, h: 14, f: 19, d: 2)
(B, p: S, g: 3, h: 16, f: 19, d: 1)
(A, p: S, g: 3, h: 16, f: 19, d: 1)
`,

[3], `C`, `S, G2`, `{D, C, S}`, 
`(G2, p: C, g: 23, h: 0, f: 23, d: 3)
(B, p: S, g: 3, h: 16, f: 19, d: 1)
(A, p: S, g: 3, h: 16, f: 19, d: 1)
`,

[4], `G2`, ``, `{D, C, G2, S}`, table.cell(align: center + horizon, `is goal`)
)
]

\

/ Percorso: $"S" -> "D" -> "C" -> "G2"$
/ Costo: 3 + 2 + 18 = 23
/ Iterazioni: 4
/ Ottimalità: il costo non è ottimale, e generalmente la DFS non garantisce ottimalità

#pagebreak()

== Ricerca in ampiezza 
BFS (breadth first search)

#align(center)[
#table(
  columns: (auto, auto, 4em, 6em, auto),
  align: (center + horizon, center + horizon, center + horizon, center + horizon, start) ,
  table.header([\#], [], [*azioni*], [*esplorati*], [*frontiera*]),

[0], $emptyset$, ``, `{}`, `(S, p: -, g: 0, h: 20, f: 20, d: 0)`,

[1], `S`, `A, B, D`, `{S}`, 
`(A, p: S, g: 3, h: 16, f: 19, d: 1)
(B, p: S, g: 3, h: 16, f: 19, d: 1)
(D, p: S, g: 3, h: 17, f: 20, d: 1)
`,

[2], `A`, `E, H`, `{A, S}`, 
`(B, p: S, g: 3, h: 16, f: 19, d: 1)
(D, p: S, g: 3, h: 17, f: 20, d: 1)
(E, p: A, g: 4, h: 15, f: 19, d: 2)
(H, p: A, g: 11, h: 8, f: 19, d: 2)
`,

[3], `B`, `C, I, J`, `{A, B, S}`, 
`(D, p: S, g: 3, h: 17, f: 20, d: 1)
(E, p: A, g: 4, h: 15, f: 19, d: 2)
(H, p: A, g: 11, h: 8, f: 19, d: 2)
(C, p: B, g: 5, h: 14, f: 19, d: 2)
(I, p: B, g: 6, h: 12, f: 18, d: 2)
(J, p: B, g: 8, h: 10, f: 18, d: 2)
`,

[4], `D`, `C`, `{A, B, D, S}`, 
`(E, p: A, g: 4, h: 15, f: 19, d: 2)
(H, p: A, g: 11, h: 8, f: 19, d: 2)
(C, p: B, g: 5, h: 14, f: 19, d: 2)
(I, p: B, g: 6, h: 12, f: 18, d: 2)
(J, p: B, g: 8, h: 10, f: 18, d: 2)
`,

[5], `E`, `D, H`, `{A, B, D, E, S}`, 
`(H, p: A, g: 11, h: 8, f: 19, d: 2)
(C, p: B, g: 5, h: 14, f: 19, d: 2)
(I, p: B, g: 6, h: 12, f: 18, d: 2)
(J, p: B, g: 8, h: 10, f: 18, d: 2)
`,

[6], `H`, `G1`, `{A, B, D, E, H, S}`, 
`(C, p: B, g: 5, h: 14, f: 19, d: 2)
(I, p: B, g: 6, h: 12, f: 18, d: 2)
(J, p: B, g: 8, h: 10, f: 18, d: 2)
(G1, p: H, g: 20, h: 0, f: 20, d: 3)
`,

[7], `C`, `S, G2`, `{A, B, C, D, E, H, S}`, 
`(I, p: B, g: 6, h: 12, f: 18, d: 2)
(J, p: B, g: 8, h: 10, f: 18, d: 2)
(G1, p: H, g: 20, h: 0, f: 20, d: 3)
(G2, p: C, g: 23, h: 0, f: 23, d: 3)
`,

[8], `I`, `A, H`, `{A, B, C, D, E, H, I, S}`, 
`(J, p: B, g: 8, h: 10, f: 18, d: 2)
(G1, p: H, g: 20, h: 0, f: 20, d: 3)
(G2, p: C, g: 23, h: 0, f: 23, d: 3)
`,

[9], `J`, `G2`, `{A, B, C, D, E, H, I, J, S}`, 
`(G1, p: H, g: 20, h: 0, f: 20, d: 3)
(G2, p: C, g: 23, h: 0, f: 23, d: 3)
`,

[10], `G1`, ``, `{A, B, C, D, E, G1, H I, J, S}`, table.cell(align: center + horizon, `is goal`)
)
]

\

/ Percorso: $"S" -> "A" -> "H" -> "G1"$
/ Costo: 3 + 8 + 9 = 20  
/ Iterazioni: 10
/ Ottimalità: il costo non è ottimale, generalmente la BFS garantisce ottimalità solo se il costo dei cammini aumenta monoticamente con la profondità

#pagebreak()

== Ricerca a costi uniformi 
Min cost search

#align(center)[
#table(
  columns: (auto, auto, 4em, 6em, auto),
  align: (center + horizon, center + horizon, center + horizon, center + horizon, start) ,
  table.header([\#], [], [*azioni*], [*esplorati*], [*frontiera*]),

[0], $emptyset$, ``, `{}`, `(S, p: -, g: 0, h: 20, f: 20, d: 0)`,

[1], `S`, `A, B, D`, `{S}`, 
`(A, p: S, g: 3, h: 16, f: 19, d: 1)
(B, p: S, g: 3, h: 16, f: 19, d: 1)
(D, p: S, g: 3, h: 17, f: 20, d: 1)
`,

[2], `A`, `E, H`, `{A, S}`, 
`(B, p: S, g: 3, h: 16, f: 19, d: 1)
(D, p: S, g: 3, h: 17, f: 20, d: 1)
(E, p: A, g: 4, h: 15, f: 19, d: 2)
(H, p: A, g: 11, h: 8, f: 19, d: 2)
`,

[3], `B`, `C, I, J`, `{A, B, S}`, 
`(D, p: S, g: 3, h: 17, f: 20, d: 1)
(E, p: A, g: 4, h: 15, f: 19, d: 2)
(C, p: B, g: 5, h: 14, f: 19, d: 2)
(I, p: B, g: 6, h: 12, f: 18, d: 2)
(J, p: B, g: 8, h: 10, f: 18, d: 2)
(H, p: A, g: 11, h: 8, f: 19, d: 2)
`,

[4], `D`, `C`, `{A, B, D, S}`, 
`(E, p: A, g: 4, h: 15, f: 19, d: 2)
(C, p: B, g: 5, h: 14, f: 19, d: 2)
(I, p: B, g: 6, h: 12, f: 18, d: 2)
(J, p: B, g: 8, h: 10, f: 18, d: 2)
(H, p: A, g: 11, h: 8, f: 19, d: 2)
`,

[5], `E`, `D, H`, `{A, B, D, E, S}`, 
`(C, p: B, g: 5, h: 14, f: 19, d: 2)
(I, p: B, g: 6, h: 12, f: 18, d: 2)
(J, p: B, g: 8, h: 10, f: 18, d: 2)
(H, p: A, g: 11, h: 8, f: 19, d: 2)
`,

[6], `C`, `S, G2`, `{A, B, C, D, E, S}`, 
`(I, p: B, g: 6, h: 12, f: 18, d: 2)
(J, p: B, g: 8, h: 10, f: 18, d: 2)
(H, p: A, g: 11, h: 8, f: 19, d: 2)
(G2, p: C, g: 23, h: 0, f: 23, d: 3)
`,

[7], `I`, `A, H`, `{A, B, C, D, E, I, S}`, 
`(J, p: B, g: 8, h: 10, f: 18, d: 2)
(H, p: I, g: 10, h: 8, f: 18, d: 3)
(G2, p: C, g: 23, h: 0, f: 23, d: 3)
`,

[8], `J`, `G2`, `{A, B, C, D, E, I, J, S}`, 
`(H, p: I, g: 10, h: 8, f: 18, d: 3)
(G2, p: J, g: 20, h: 0, f: 20, d: 3)
`,

[9], `H`, `G1`, `{A, B, C, D, E, H, I, J, S}`, 
`(G1, p: H, g: 19, h: 0, f: 19, d: 4)
(G2, p: J, g: 20, h: 0, f: 20, d: 3)
`,

[10], `G1`, ``, `{A, B, C, D, E, G1, H, I, J, S}`, table.cell(align: center + horizon, `is goal`)
)
]

\ \

/ Percorso: $"S" -> "B" -> "I" -> "H" -> "G1"$
/ Costo: 3 + 3 + 4 + 9 = 19
/ Iterazioni: 10 
/ Ottimalità: il costo è ottimale, e generalmente il min-cost trova il cammino ottimale (si considera sempre il caso di un albero di ricerca finito)

#pagebreak()

== Ricerca ad approfondimento iterativo 
Iterative deepening search

#align(center)[
#table(
  columns: (auto, auto, 4em, 6em, auto),
  align: (center + horizon, center + horizon, center + horizon, center + horizon, start) ,
  table.header([\#], [], [*azioni*], [*esplorati*], [*frontiera*]),

[0], $emptyset$, ``, `{}`, `(S, p: -, g: 0, h: 20, f: 20, d: 0)`,

[1], `S`, `A, B, D`, `{S}`, 
`(D, p: S, g: 3, h: 17, f: 20, d: 1)
(B, p: S, g: 3, h: 16, f: 19, d: 1)
(A, p: S, g: 3, h: 16, f: 19, d: 1)
`,

[2], `D`, ``, `{D, S}`, 
`(B, p: S, g: 3, h: 16, f: 19, d: 1)
(A, p: S, g: 3, h: 16, f: 19, d: 1)
`,

[3], `B`, ``, `{B, D, S}`, `(A, p: S, g: 3, h: 16, f: 19, d: 1)`,

[4], `A`, ``, `{A, B, D, S}`, ``,

[5], $emptyset$, ``, `{}`, `(S, p: -, g: 0, h: 20, f: 20, d: 0)`,

[6], `S`, `A, B, D`, `{S}`, 
`(D, p: S, g: 3, h: 17, f: 20, d: 1)
(B, p: S, g: 3, h: 16, f: 19, d: 1)
(A, p: S, g: 3, h: 16, f: 19, d: 1)
`,

[7], `D`, `C`, `{D, S}`, 
`(C, p: D, g: 5, h: 14, f: 19, d: 2)
(B, p: S, g: 3, h: 16, f: 19, d: 1)
(A, p: S, g: 3, h: 16, f: 19, d: 1)
`,

[7], `C`, ``, `{C, D, S}`, 
`(B, p: S, g: 3, h: 16, f: 19, d: 1)
(A, p: S, g: 3, h: 16, f: 19, d: 1)
`,

[8], `B`, `C, I, J`, `{B, C, D, S}`, 
`(J, p: B, g: 8, h: 10, f: 18, d: 2)
(I, p: B, g: 6, h: 12, f: 18, d: 2)
(A, p: S, g: 3, h: 16, f: 19, d: 1)
`,

[9], `J`, ``, `{B, C, D, J, S}`, 
`(I, p: B, g: 6, h: 12, f: 18, d: 2)
(A, p: S, g: 3, h: 16, f: 19, d: 1)
`,

[10], `I`, ``, `{B, C, D, I, J, S}`, `(A, p: S, g: 3, h: 16, f: 19, d: 1)`,

[11], `A`, `E, H`, `{A, B, C, D, J, S}`, 
`(H, p: A, g: 11, h: 8, f: 19, d: 2)
(E, p: A, g: 4, h: 15, f: 19, d: 2)
`,

[12], `H`, ``, `{A, B, C, D, H, J, S}`, `(E, p: A, g: 4, h: 15, f: 19, d: 2)`,

[13], `E`, ``, `{A, B, C, D, E, H, J, S}`, ``,

[14], $emptyset$, ``, `{}`, `(S, p: -, g: 0, h: 20, f: 20, d: 0)`,

[15], `S`, `A, B, D`, `{S}`, 
`(D, p: S, g: 3, h: 17, f: 20, d: 1)
(B, p: S, g: 3, h: 16, f: 19, d: 1)
(A, p: S, g: 3, h: 16, f: 19, d: 1)
`,

[16], `D`, `C`, `{D, S}`, 
`(C, p: D, g: 5, h: 14, f: 19, d: 2)
(B, p: S, g: 3, h: 16, f: 19, d: 1)
(A, p: S, g: 3, h: 16, f: 19, d: 1)
`,

[17], `C`, `S, G2`, `{C, D, S}`, 
`(G2, p: C, g: 23, h: 0, f: 23, d: 3)
(B, p: S, g: 3, h: 16, f: 19, d: 1)
(A, p: S, g: 3, h: 16, f: 19, d: 1)
`,

[18], `G2`, ``, `{C, D, G2, S}`, table.cell(align: center + horizon, `is goal`)
)
]

\

/ Percorso: $"S" -> "D" -> "C" -> "G2"$
/ Costo: 3 + 2 + 18 = 23
/ Iterazioni: 18
/ Ottimalità: il cammino non è ottimale, e generalmente non è detto che la ricerca ad approfondimento iterativo trovi un cammino con costo ottimale

#pagebreak()

== Ricerca best-first greedy 
Best-first greedy search

#align(center)[
#table(
  columns: (auto, auto, 4em, 6em, auto),
  align: (center + horizon, center + horizon, center + horizon, center + horizon, start) ,
  table.header([\#], [], [*azioni*], [*esplorati*], [*frontiera*]),

[0], $emptyset$, ``, `{}`, `(S, p: -, g: 0, h: 20, f: 20, d: 0)`,

[1], `S`, `A, B, D`, `{S}`, 
`(A, p: S, g: 3, h: 16, f: 19, d: 1)
(B, p: S, g: 3, h: 16, f: 19, d: 1)
(D, p: S, g: 3, h: 17, f: 20, d: 1)
`,

[2], `A`, `E, H`, `{A, S}`, 
`(H, p: A, g: 11, h: 8, f: 19, d: 2)
(E, p: A, g: 4, h: 15, f: 19, d: 2)
(B, p: S, g: 3, h: 16, f: 19, d: 1)
(D, p: S, g: 3, h: 17, f: 20, d: 1)
`,

[3], `H`, `G1`, `{A, H, S}`, 
`(G1, p: H, g: 20, h: 0, f: 20, d: 3)
(E, p: A, g: 4, h: 15, f: 19, d: 2)
(B, p: S, g: 3, h: 16, f: 19, d: 1)
(D, p: S, g: 3, h: 17, f: 20, d: 1)
`,

[4], `G1`, ``, `{A, G1, H, S}`, table.cell(align: center + horizon, `is goal`)
)
]

\

/ Percorso: $"S" -> "A" -> "H" -> "G1"$
/ Costo: 3 + 8 + 9 = 20 
/ Iterazioni: 4
/ Ottimalità: il cammino non è ottimale, generalmente il best-first non trova l'algoritmo ottimale, a meno che l'euristica non è fedele al costo effettivo dei cammini

#pagebreak()

== A#super[\*]

A#super[\*]


#align(center)[
#table(
  columns: (auto, auto, 4em, 6em, auto),
  align: (center + horizon, center + horizon, center + horizon, center + horizon, start) ,
  table.header([\#], [], [*azioni*], [*esplorati*], [*frontiera*]),

[0], $emptyset$, ``, `{}`, `(S, p: -, g: 0, h: 20, f: 20, d: 0)`,

[1], `S`, `A, B, D`, `{S}`, 
`(A, p: S, g: 3, h: 16, f: 19, d: 1)
(B, p: S, g: 3, h: 16, f: 19, d: 1)
(D, p: S, g: 3, h: 17, f: 20, d: 1)
`,

[2], `A`, `E, H`, `{A, S}`, 
`(B, p: S, g: 3, h: 16, f: 19, d: 1)
(E, p: A, g: 4, h: 15, f: 19, d: 2)
(H, p: A, g: 11, h: 8, f: 19, d: 2)
(D, p: S, g: 3, h: 17, f: 20, d: 1)
`,

[3], `B`, `C, I, J`, `{A, B, S}`, 
`(I, p: B, g: 6, h: 12, f: 18, d: 2)
(J, p: B, g: 8, h: 10, f: 18, d: 2)
(C, p: B, g: 5, h: 14, f: 19, d: 2)
(E, p: A, g: 4, h: 15, f: 19, d: 2)
(H, p: A, g: 11, h: 8, f: 19, d: 2)
(D, p: S, g: 3, h: 17, f: 20, d: 1)
`,

[4], `I`, `A, H`, `{A, B, I, S}`, 
`(H, p: I, g: 10, h: 8, f: 18, d: 3)
(J, p: B, g: 8, h: 10, f: 18, d: 2)
(C, p: B, g: 5, h: 14, f: 19, d: 2)
(E, p: A, g: 4, h: 15, f: 19, d: 2)
(D, p: S, g: 3, h: 17, f: 20, d: 1)
`,

[5], `H`, `G1`, `{A, B, H, I, S}`, 
`(J, p: B, g: 8, h: 10, f: 18, d: 2)
(C, p: B, g: 5, h: 14, f: 19, d: 2)
(E, p: A, g: 4, h: 15, f: 19, d: 2)
(G1, p: H, g: 19, h: 0, f: 19, d: 4)
(D, p: S, g: 3, h: 17, f: 20, d: 1)
`,

[5], `J`, `G2`, `{A, B, H, I, J, S}`, 
`(C, p: B, g: 5, h: 14, f: 19, d: 2)
(E, p: A, g: 4, h: 15, f: 19, d: 2)
(G1, p: H, g: 19, h: 0, f: 19, d: 4)
(D, p: S, g: 3, h: 17, f: 20, d: 1)
(G2, p: J, g: 20, h: 0, f: 20, d: 3)
`,

[6], `C`, `S, G2`, `{A, B, C, H, I, J, S}`, 
`(E, p: A, g: 4, h: 15, f: 19, d: 2)
(G1, p: H, g: 19, h: 0, f: 19, d: 4)
(D, p: S, g: 3, h: 17, f: 20, d: 1)
(G2, p: J, g: 20, h: 0, f: 20, d: 3)
`,

[7], `E`, `D, H`, `{A, B, C, E, H, I, J, S}`, 
`(G1, p: H, g: 19, h: 0, f: 19, d: 4)
(D, p: S, g: 3, h: 17, f: 20, d: 1)
(G2, p: J, g: 20, h: 0, f: 20, d: 3)
`,

[8], `G1`, ``, `{A, B, C, E, G1, H, I, J, S}`, table.cell(align: center + horizon, `is goal`)
)
]

\
\

/ Percorso: $"S" -> "B" -> "I" -> "H" -> "G1"$
/ Costo: 3 + 3 + 8 + 9 = 23
/ Iterazioni: 8
/ Ottimalità: il cammino non è ottimale, generalmente A#super[\*] trova il cammino ottimale solo se l'euristica è consistente

== Euristica

Dato che $h$ consistente $==>$ A#super[\*] trova l'ottimo, e A#super[\*] non ha trovato l'ottimo, allora $h$ non è consistente. Non è neanche ammissibile, dato che l'euristica di `S` è 20, ma il percorso ottimale ha costo 19.
