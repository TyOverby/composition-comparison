open! Core
open! Import

let app =
  let%sub first_view, how_much =
    Counter.component ~label:(Value.return "first") ~how_much:(Value.return 1)
  in
  let%sub second_view, _ = Counter.component ~label:(Value.return "second") ~how_much in
  let%arr first = first_view
  and second = second_view in
  N.div [ first; second ]
;;

let _ = Start.start ~bind_to_element_with_id:"app" Start.Result_spec.just_the_view app
