#let general-indent = 1.2em

#let purple = rgb("b16286")
#let yellow = rgb("d79921")
#let green = rgb("98971a")
#let blue = rgb("458588")
#let red = rgb("#cc241d")

#let indent(body) = box(inset: (x: general-indent), body)

#let regular(body) = text(weight: "regular", body)

#let fol(body) = {
  set text(font: "CaskaydiaCove NF", weight: "light", lang: "en", size: 9pt)
  set highlight(fill: rgb("fbf1c7bb"))

  show emph: it => text(purple, it)
  show strong: it => text(blue, it.body)
  show sym.space.nobreak: h(general-indent)

  show regex("[\w_]+\("): set text(green)
  show regex("\("): set text(black)
  show regex("\)"): set text(black)
  show regex("\b(True|False|result|now|argmax|this|auth|sorted)\b"): set text(yellow)
  show regex("\bforall\b"): $forall$
  show regex("\bexists\b"): $exists$
  show regex("\band\b"): $and$
  show regex("\bnot\b"): $not$
  show regex("\bor\b"): $or$
  show regex("\bin\b"): $in$
  show regex("<->"): $<->$
  show regex("->"): $->$
  show regex("<="): $<=$
  show regex("<"): $<$

  body
}

#let subsection(
  title,
  body,
  newline: true,
  with-fol: true,
) = {
  if newline {
    title
    linebreak()
    indent(if with-fol { fol(body) } else { body })
  } else {
    box(par(hanging-indent: general-indent, if with-fol { fol[#title #body] } else [#title #body]))
  }

  linebreak()
}

#let constraint(
  name,
  body,
  description: none,
) = {
  set text(font: "CaskaydiaCove NF", weight: "light", lang: "en", size: 9pt)
  set highlight(fill: rgb("fbf1c7bb"))

  highlight[[#fol(name)]]

  linebreak()

  indent(if description == none {
    fol(body)
  } else {
    subsection([#regular[description] - ], description, newline: false, with-fol: false)
    subsection(regular[invariant], body)
  })

  v(1em)
}

#let operation(
  name,
  args: none,
  type: none,
  pre: none,
  post: none,
  description: none,
) = {
  set text(font: "CaskaydiaCove NF", weight: "light", lang: "en", size: 9pt)
  set highlight(fill: rgb("fbf1c7bb"))

  highlight(fol[#name\(#args)#if type != [] [: #type]])

  linebreak()

  if pre != none or post != none or description != none {
    indent({
      if description != none {
        subsection([#regular[descrizione] - ], description, newline: false, with-fol: false)
      }
      if pre != none { subsection(regular[precondizioni], pre) }
      if post != none { subsection(regular[postcondizioni ], post) }
    })
  }

  v(1em)
}

#let extension(new-objects: [], old-objects: [], new-tuples: [], old-tuples: []) = {
  set text(font: "CaskaydiaCove NF", weight: "light", lang: "en", size: 9pt)
  set highlight(fill: rgb("fbf1c7bb"))

  subsection(
    strong[changes to extensional level],
    {
      if new-objects != [] { subsection(regular[new objects], new-objects) }
      if old-objects != [] { subsection(regular[old objects], old-objects) }
      if new-tuples != [] { subsection(regular[new tuples], new-tuples) }
      if old-tuples != [] { subsection(regular[old tuples], old-tuples) }
    },
  )
}

#let pddl-action(name, args, pre, effect) = {
  set text(font: "CaskaydiaCove NF", weight: "light", lang: "en", size: 9pt)
  set highlight(fill: rgb("fbf1c7bb"))

  highlight(fol[*#name*(#args)])
  linebreak()
  indent({
    subsection(regular[precondizioni], pre)
    subsection(regular[effetto], effect)
  })

  v(1em)
}

// #let fol-style = {
//   set text(font: "CaskaydiaCove NF", weight: "light", lang: "en", size: 9pt)
//   set highlight(fill: rgb("fbf1c7bb"))
// }


// set text(font: "CaskaydiaCove NF", weight: "light", lang: "en", size: 9pt)
// set highlight(fill: rgb("fbf1c7bb"))
//
// show heading: set block(above: 1.4em, below: 1em)
// show raw: set text(font: "CaskaydiaCove NFM", lang: "en", weight: "light", size: 9pt)
// show math.equation: set text(size: 9pt)
// show sym.space.nobreak: h(general-indent)

// #let red = rgb("b16286")

// #let yellow = rgb("#d79921")
// #let green = rgb("#98971a")
// #let blue = rgb("#458588")

// TODO: default outlined for names
// one should be able to specify if each constraint / operation is outlined or numbered or not
// and one would also be able to specify the level
// there should be a default one in the config, it can be specified as default for every page
// and also  one should be able to specify this stuff on each operation, depending on he wants to do it


// #let conf(title, doc) = {
//   set text(font: "CaskaydiaCove NF", weight: "light", lang: "it", size: 9pt)
//   set page(margin: 1.50in)
//   set underline(offset: 3pt, stroke: .1pt)
//
//   show heading.where(level: 2): set text(size: 1.3em)
//   show heading.where(level: 3): set text(size: 1.2em)
//   show heading: set block(above: 1.4em, below: 1em)
//   show raw: set text(font: "CaskaydiaCove NFM", lang: "en", weight: "light", size: 9pt)
//   show math.equation: set text(size: 9pt)
//   show sym.space.nobreak: h(general-indent)
//
//   page(
//     align(
//       center + horizon,
//       heading(
//         numbering: none,
//         outlined: false,
//         text(size: 2em, weight: "regular", title),
//       ),
//     ),
//   )
//
//   page(outline())
//
//   set page(numbering: "1")
//
//   doc
// }

// #let indent(body) = box(inset: (x: general-indent), body)
//
// #let fol(body) = {
//   set text(font: "CaskaydiaCove NF", weight: "light", lang: "it", size: 9pt)
//
//   show emph: it => text(purple, it)
//   show strong: it => text(blue, it.body)
//   show sym.space.nobreak: h(general-indent)
//   show regex("[\w_]+(\(|\/)"): set text(red)
//   show regex("\(|\/"): set text(black)
//   show regex("\b(True|False|result|now|argmax|this|auth|sorted)\b"): set text(yellow)
//   show regex("\bforall\b"): $forall$
//   show regex("\bexists\b"): $exists$
//   show regex("\band\b"): $and$
//   show regex("\bnot\b"): $not$
//   show regex("\bor\b"): $or$
//   show regex("\bin\b"): $in$
//   show regex("<->"): $<->$
//   show regex("->"): $->$
//   show regex("<="): $<=$
//   show regex("<"): $<$
//
//   body
// }
//
// #let sub-section(title, body, newline: true) = {
//   set text(font: "CaskaydiaCove NF", weight: "light", lang: "it", size: 9pt)
//   text(weight: "regular", title)
//   if newline {
//     linebreak()
//     indent(fol(body))
//   } else {
//     fol(body)
//   }
//   linebreak()
// }
// #let pddl_action(name, args, pre, effect) = {
//   fol({
//     strong(name)
//     [(]
//     args
//     [)]
//   })
//   linebreak()
//   indent({
//     section("Precond ", pre, newline: false)
//     section("Effetto ", effect, newline: false)
//   })
// }
// set text(font: "CaskaydiaCove NF", weight: "light", lang: "en", size: 9pt)
// ==== #text(weight: "light")[[#underline(name.replace(" ", "_"))]]
// ==== #text(weight: "light")[[#underline(name.replace(" ", "_"))]]
// #let constraint(name, body, description: none) = {
//   box(
//     inset: (bottom: 3pt),
//     {
//       [\[]
//       underline(offset: 3pt, stroke: black, fol(name))
//       [\]]
//     },
//   )
//   linebreak()
//   indent(if description == none {
//     fol(body)
//   } else {
//     sub-section("description - ", description, newline: false)
//     sub-section("invariant", body)
//   })
// }
//
// #let operation(name, args: none, type: none, pre: none, post: none, description: none) = [
//   ==== #fol(
//     text(weight: "light")[
//       #underline(stroke: black)[
//         #text(black, name)\(#args)#if type != [] [: #type]
//       ]
//     ],
//   )
//
//   #if pre != [] or post != [] or description != "" {
//     indent[
//       #if description != "" { sub-section("description - ", description, newline: false) }
//       #if pre != [] { sub-section("pre-conditions", pre) }
//       #if post != [] { sub-section("post-conditions", post) }
//     ]
//   }
// ]
// fol([*#name*\(#args)])
// fol[*#name*\(#args)]
// text(
// numbering: none,
// outlined: false,
// level: 3,
// )
// text(
//   weight: "light",
// ),
// underline(stroke: black, offset: 3pt)[
// #[text(black, name)\(#args)]
// ],
//
// #let extension(new-objects: [], old-objects: [], new-tuples: [], old-tuples: []) = [
//   #sub-section(
//     "changes to extensional level",
//     {
//       if new-objects != [] { sub-section("new objects", new-objects) }
//       if old-objects != [] { sub-section("old objects", old-objects) }
//       if new-tuples != [] { sub-section("new tuples", new-tuples) }
//       if old-tuples != [] { sub-section("old tuples", old-tuples) }
//     },
//   )
// ]
// #let yellow = rgb("#d79921")
// #let green = rgb("#98971a")
// #let blue = rgb("#458588")
// #let red = rgb("#b16286")
// :: #highlight(description)
//     / Invariant\:: \ #highlight(body)
// #if description != "" [#text(weight: "regular")[description] \ #indent(highlight(description)) \ ]
// #if pre != [] [#text(weight: "regular")[prev-conditions] \ #indent(highlight(pre)) \ ]
// #if post != [] [#text(weight: "regular")[post-conditions] \ #indent(highlight(post))]
// , vert: .7em
// #if vert != 0 [ #v(vert) ]
// #if new-objects != [] [*new objects*: \ #indent(highlight(new-objects))]
// #if old-objects != [] [*old objects*: \ #highlight(old-objects)]
// #if new-tuples != [] [*new tuples*: \ #highlight(new-tuples)]
// #if old-tuples != [] [*old tuples*: \ #highlight(old-tuples)] #v(.7em)
// set terms(hanging-indent: indentation)
// set terms(hanging-indent: indentation, separator: [#linebreak()])
// show terms.item.term: set text(red, weight: "light")
// show heading: set text(weight: "regular")
// show heading.where(level: 1): set text(size: 1.3)
// show terms.item: it => {
// show strong: set text(weight: "thin")
// set text(weight: "thin")
// it
// text(weight: "regular", fill: red, it.term)
// h(0.6em)
// it.description
// linebreak()
// }
// / desc: #highlight(description)
// / invariant: #highlight(body)
// #show terms.item: set text(weight: "regular", fill: red)
// #block(fill: luma(254), width: 100%, inset: 1em, stroke: .1pt)[
// ]
// ==== #text(weight: "light")[[#name.replace(" ", "_")]]
// ==== #text(weight: "thin")[[#underline(name.replace(" ", "_"))]]
// ==== #highlight(text(weight: "light")[#name\(#args)#if type != [] [: #type]])
// ==== #highlight(text(weight: "light")[#text(black, name)\(#args)#if type != [] [: #type]])
// ==== #highlight(text(weight: "thin")[#underline[#text(black, name)\(#args)#if type != [] [: #type]]])
// #if description != "" [/ description: #highlight(description)]
// #if pre != [] [/ preconditions: #highlight(pre)]
// #if post != [] [/ postconditions: #highlight(post)]
// #let constraint2(class, title, description: "", body) = [
//
//   // ==== #text(weight: "light")[[#text(weight: "extralight")[Constraint].#if type(class) == str [*#class*] else {class}.#title.replace(" ", "_")]]
//   ==== #text(weight: "light")[[#title.replace(" ", "_")]]
//
//   #indent[
//     #if description == "" [
//       #highlight(body)
//     ] else [
//       / description: #highlight(description)
//       / constraint: #highlight(body)
//     ]
//   ]
// ]
// #let trigger(name, operations, function, invocation: [after]) = [
//   === [Trigger.Constraint.#name]
//
//   #indent[
//     / intercepted operations: #operations
//     / invocation: #invocation
//     #text(weight: "bold")[function]\(old, new)
//     #indent[#function]
//   ]
// ]
