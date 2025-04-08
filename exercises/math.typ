// #let indent(body) = box(width: 100%, inset: (left: 1em), stroke: (left: (thickness: .3pt, paint: black, dash: "dashed")), body)
#let indent(body) = block(width: 100%, inset: (left: .5em), stroke: (left: 2pt + luma(240)), body)

#let note(stamp, label, title, body) = [ 
  #heading(depth: 3, numbering: none)[#context counter(label).step() #title]
  // *#stamp #context counter(heading).display().#context counter(label).step()#context counter(label).display() #title* \
  #body 
]

// #let note(color, title, body) = [ #text(rgb(color))[*#title*] \ #body ]
// #let note(color, title, body) = block(
// // , rest: 0.1pt + rgb(color)
//   width: 100%, inset: 1em, stroke: (left: 2pt + rgb(color)),
//   [ #heading(outlined: false, level: 4, text(rgb(color))[*#title*]) #body ]
// )

#let definition(body, title: "") = block(stroke: (thickness: .5pt, paint: silver, dash: "dashed"), width: 100%, inset: 1em,
  note(
    "Definizione",
    "definition",
    title,
    body
  )
)

#let proposition(body, title: "") = note(
  "Proposizione",
  "proposition",
  title,
  body
)

#let theorem(body, title: "") = block(stroke: (thickness: .5pt, paint: black, dash: "dashed"), width: 100%, inset: 1em, 
  note(
    "Teorema",
    "theorem",
    title,
    body
  )
)

// #let propositions = counter("proposition")
// #let proposition(body, title: "") = note(
//   [Proposizione #context counter(heading).display().#propositions.step()#context propositions.display() #title ],
//   body
// )

// #let proposition(body, title: "") = [
//   #heading(outlined: false, level: 4, text(rgb("#1a7f37"))[*Proposizione #propositions.step() #context propositions.display() #title*]) #body
// ]

#let lemmas = counter("lemma")
#let lemma(body, title: "") = [
  #heading(outlined: false, numbering: none, level: 4, text(rgb("#8250df"))[*Lemma #lemmas.step() #context lemmas.display() #title*]) #body
]

// #let proposition(body, title: "") = note(
//   "#1a7f37", 
//   [Proposizione #propositions.step() #context propositions.display() #title ],
//   body
// )

// purple: #8250df

#let proofs = counter("proof")
#let proof(body) = note(
  "#0969da", 
  [Dimostrazione #proofs.step() #context proofs.display()],
  body
)

#let corollarys = counter("corollary")
#let corollary(body) = note(
  "#0969da", 
  [Corollario #corollarys.step() #context corollarys.display()],
  body
)


#let examples = counter("example")
#let example(body) = note(
  // "#0969da", 
  [Teorema #examples.step() #context examples.display()],
  body
)

#let observations = counter("observation")
#let observation(body) = note(
  "",
  "",
  // "#0969da", 
  [Osservazione #observations.step() #context observations.display()],
  body
)

// #let corollary(body) = block()
//
// #let theorem(body) = block()
//
// #let observation(body) = block()

//   block(
//   width: 100%, inset: 10pt, stroke: (left: 2pt + rgb("#0969da")),
//   [#text(rgb("#0969da"))[Definizione] \ #body]
// )
