open! Core
open! Import

let app graph =
  let view, _ = Counter.component ~label:(Bonsai.return "counter") graph in
  view
;;

let () = Start.start app
