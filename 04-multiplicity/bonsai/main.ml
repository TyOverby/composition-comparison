open! Core
open! Import

let app =
  let%sub first = Counter.component in
  let%sub second = Counter.component in
  let%arr first = first
  and second = second in
  N.div [ first; second ]
;;

let _ =
  Start.start ~bind_to_element_with_id:"app" Start.Result_spec.just_the_view app
;;
