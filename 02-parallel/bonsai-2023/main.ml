open! Core
open! Import

let app graph =
  let first, _ = Counter.component ~label:(Bonsai.return "first") graph in
  let second, _ = Counter.component ~label:(Bonsai.return "second") graph in
  let%map first and second in
  N.div [ first; second ]
;;

let () = Start.start app
