#let indentation = 2em
#let yellow = rgb("#d79921")
#let green = rgb("#98971a")
#let blue = rgb("#458588")
#let red = rgb("#b16286")

#let conf(title, doc) = {
  set terms(hanging-indent: indentation, separator: [#linebreak()])
  set text(font: "CaskaydiaCove NF", weight: "light", lang: "it", size: 9pt)
  // set page(margin: 1.75in)
  set page(margin: 1.50in)
  set underline(offset: 3pt)
  show heading: set block(above: 1.4em, below: 1em)

  show raw: set text(font: "CaskaydiaCove NFM", lang: "it", weight: "light", size: 9pt)
  show math.equation: set text(size: 9pt)

  page(
    align(
      center + horizon,
      heading(numbering: none, outlined: false, text(size: 1.5em, weight: "regular", title)),
    ),
  )

  show sym.space.nobreak: h(indentation)
  page(outline(indent: 1.5em))
  set page(numbering: "1")
  doc
}

#let indent(body) = block(inset: (x: indentation), spacing: 0pt, [#body])

#let highlight(body) = {
  show emph: it => text(blue, it)
  show strong: it => text(green, it.body)
  show sym.space.nobreak: h(indentation)
  show regex("[\w_]+\("): set text(red)
  show regex("\("): set text(black)
  show regex("True|False|result|now|argmax|this|auth|sorted"): set text(yellow)

  body
}

#let constraint(name, body, desc: "") = [
  ==== #text(weight: "light")[[#name.replace(" ", "_")]]

  #indent[
    #if desc == "" [
      #highlight(body)
    ] else [
      / descrizione: #highlight(desc)
      / vincolo: #highlight(body)
    ]
  ]
]

#let operation(name, type: [], args: [], pre: [], post: [], desc: "") = [
  // ==== #highlight(text(weight: "light")[#name\(#args)#if type != [] [: #type]])
  ==== #highlight(text(weight: "light")[#text(black, name)\(#args)#if type != [] [: #type]])

  #if pre != [] or post != [] or desc != "" [
    #indent[
      #if desc != "" [/ descrizione: #highlight(desc)]
      #if pre != [] [/ pre-condizioni: #highlight(pre)]
      #if post != [] [/ post-condizioni: #highlight(post)]
    ]
  ]
]

#let extension(new-objects: [], old-objects: [], new-tuples: [], old-tuples: []) = [
  #v(.7em)
  / changes to extensional level: #[
      #if new-objects != [] [/ new objects: #highlight(new-objects)]
      #if old-objects != [] [/ old objects: #highlight(old-objects)]
      #if new-tuples != [] [/ new tuples: #highlight(new-tuples)]
      #if old-tuples != [] [/ old tuples: #highlight(old-tuples)] #v(.7em)
    ]
]

#let trigger(name, operations, function, invocation: [after]) = [
  === [Trigger.Constraint.#name]

  #indent[
    / intercepted operations: #operations
    / invocation: #invocation
    #text(weight: "bold")[function]\(old, new)
    #indent[#function]
  ]
]

#let query(name, type: [], args: [], body: []) = [

  == #emph(name)\(#args)#if type != [] [: #type]

  #v(5pt)

  // #if pre != [] or post != [] [
  // #h(10pt) #text(weight: "bold")[pre-condizioni]

  // #if pre != [] [ #block( inset: ("left": 20pt), [#pre]) ]

  // #h(10pt) #text(weight: "bold")[post-condizioni]

  #if body != [] [ #block(inset: ("left": 20pt), [#body]) ]

  #v(10pt)
  // ]

]

// #let trigger(name, operations, function, invocation: [post]) = [
//   == [V.#name]
//
//   #v(5pt)
//
//   #block(inset: ("left": 10pt))[
//     #text(weight: "bold")[operazioni intercettate] #operations
//
//     #text(weight: "bold")[invocazione] #invocation
//
//     #text(weight: "bold")[funzione]\(old, new)
//
//     #block(inset: ("left": 10pt))[#function]
//   ]
//
//   #v(10pt)
// ]
