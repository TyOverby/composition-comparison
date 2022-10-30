open! Core
open! Import

let app =
  let%sub first, _ =
    Counter.component ~label:(Value.return "first") ~how_much:(Value.return 1)
  in
  let%sub second, _ =
    Counter.component ~label:(Value.return "second") ~how_much:(Value.return 2)
  in
  let%arr first = first
  and second = second in
  N.div [ first; second ]
;;

let _ = Start.start ~bind_to_element_with_id:"app" Start.Result_spec.just_the_view app
