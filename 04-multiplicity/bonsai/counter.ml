open! Core
open! Import

module Action = struct
  type t =
    | Incr
    | Decr
  [@@deriving sexp_of]
end

let apply_action ~inject:_ ~schedule_event:_ model (action : Action.t) =
  match action with
  | Incr -> model + 1
  | Decr -> model - 1
;;

let component label =
  let%sub state_and_inject =
    Bonsai.state_machine0 (module Int) (module Action) ~default_model:0 ~apply_action
  in
  let%arr state, inject = state_and_inject
  and label = label in
  let view =
    N.div
      [ N.span [ N.textf "%s: " label ]
      ; N.button ~attr:(A.on_click (fun _ -> inject Decr)) [ N.text "-1" ]
      ; N.span [ N.textf "%d" state ]
      ; N.button ~attr:(A.on_click (fun _ -> inject Incr)) [ N.text "+1" ]
      ]
  in
  view, state
;;
