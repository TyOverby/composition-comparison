open! Core
open! Import

let app graph =
  let first_view, by = Counter.component ~label:(Bonsai.return "first") graph in
  let second_view, _ = Counter.component ~label:(Bonsai.return "second") ~by graph in
  let%map first = first_view
  and second = second_view in
  N.div [ first; second ]
;;

let () = Start.start app
