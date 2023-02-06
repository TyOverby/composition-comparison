open! Core
open! Import

let app =
  let%sub view, _ = Counter.component ~label:(Value.return "counter") () in
  return view
;;

let () = Start.start app
