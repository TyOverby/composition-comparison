open! Core
open! Import

let app =
  let%sub counter_view, how_many =
    Counter.component ~label:(Value.return "how many") ~how_much:(Value.return 1)
  in
  let%sub map =
    let%arr how_many = how_many in
    Int.Map.of_alist_exn (List.init how_many ~f:(fun i -> i, ()))
  in
  let make_subcomponent key _data =
    let%sub subcomponent =
      Counter.component ~label:(Value.map key ~f:Int.to_string) ~how_much:(Value.return 1)
    in
    let%arr view, _ = subcomponent in
    view
  in
  let%sub others = Bonsai.assoc (module Int) map ~f:make_subcomponent in
  let%arr counter_view = counter_view
  and others = others in
  N.div (counter_view :: Map.data others)
;;

let _ = Start.start ~bind_to_element_with_id:"app" Start.Result_spec.just_the_view app
