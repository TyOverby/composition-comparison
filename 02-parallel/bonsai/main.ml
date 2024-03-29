open! Core
open! Import

let app =
  let%sub first, _ = Counter.component ~label:(Value.return "first") () in
  let%sub second, _ = Counter.component ~label:(Value.return "second") () in
  let%arr first = first
  and second = second in
  N.div [ first; second ]
;;

let () = Start.start app
