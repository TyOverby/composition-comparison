open! Core
open! Import

let app =
  let%sub first_view, by = Counter.component ~label:(Value.return "first") () in
  let%sub second_view, _ = Counter.component ~label:(Value.return "second") ~by () in
  let%arr first = first_view
  and second = second_view in
  N.div [ first; second ]
;;

let () = Start.start app
