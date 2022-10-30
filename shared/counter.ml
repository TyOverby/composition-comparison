open! Core
open! Import

module Action = struct
  type t =
    | Incr
    | Decr
  [@@deriving sexp_of]
end

let apply_action ~inject:_ ~schedule_event:_ how_much model (action : Action.t) =
  match action with
  | Incr -> model + how_much
  | Decr -> model - how_much
;;

let component ~label ?(how_much = Value.return 1) =
  let%sub state_and_inject =
    Bonsai.state_machine1
      (module Int)
      (module Action)
      ~default_model:0
      ~apply_action
      how_much
  in
  let%arr state, inject = state_and_inject
  and how_much = how_much
  and label = label in
  let view =
    N.div
      [ N.span [ N.textf "%s: " label ]
      ; N.button ~attr:(A.on_click (fun _ -> inject Decr)) [ N.textf "-%d" how_much ]
      ; N.span [ N.textf "%d" state ]
      ; N.button ~attr:(A.on_click (fun _ -> inject Incr)) [ N.textf "+%d" how_much ]
      ]
  in
  view, state
;;
