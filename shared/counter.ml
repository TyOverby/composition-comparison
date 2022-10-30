open! Core
open! Import

module Action = struct
  type t =
    | Incr
    | Decr
  [@@deriving sexp_of]
end

let default_model = 0

let apply_action ~inject:_ ~schedule_event:_ how_much model action =
  match (action : Action.t) with
  | Incr -> model + how_much
  | Decr -> model - how_much
;;

let component' ~label ?(by = Value.return 1) () =
  let%sub state_and_inject =
    Bonsai.state_machine1
      (module Int)
      (module Action)
      ~default_model
      ~apply_action
      by
  in
  let%arr state, inject = state_and_inject
  and by = by
  and label = label in
  let button op action =
    N.button
      ~attr:(A.on_click (fun _ -> inject action))
      [ N.textf "%s%d" op by ]
  in
  let view =
    N.div
      [ N.textf "%s: " label
      ; button "-" Decr
      ; N.textf "%d" state
      ; button "+" Incr
      ]
  in
  view, state
;;

let component ~label ?by () =
  let%map.Computation view, _ = component' ~label ?by () in
  view
;;
