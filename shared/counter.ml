open! Core
open! Import

module Action = struct
  type t =
    | Incr
    | Decr
  [@@deriving sexp_of]
end

let apply_action ~inject:_ ~schedule_event:_ by model = function
  | Action.Incr -> model + by
  | Decr -> model - by
;;

let component ~label ?(by = Value.return 1) () =
  let%sub state_and_inject =
    Bonsai.state_machine1 (module Int) (module Action) ~default_model:0 ~apply_action by
  in
  let%arr state, inject = state_and_inject
  and by = by
  and label = label in
  let button op action =
    N.button ~attr:(A.on_click (fun _ -> inject action)) [ N.textf "%s%d" op by ]
  in
  let view =
    N.div
      [ Vdom.Node.span [ N.textf "%s: " label ]
      ; button "-" Decr
      ; Vdom.Node.span [ N.textf "%d" state ]
      ; button "+" Incr
      ]
  in
  view, state
;;
