open! Core
open! Import

let app =
  let%sub view, _ = Counter.component (Value.return "counter") in
  return view
;;

let _ = Start.start ~bind_to_element_with_id:"app" Start.Result_spec.just_the_view app
