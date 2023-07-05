open! Core
open! Import

let apply_action _ctx by model = function
  | `Incr -> model + by
  | `Decr -> model - by
;;

let component ~label ?(by = Bonsai.return 1) graph =
  let state, inject = Bonsai.state_machine1 ~default_model:0 ~apply_action by graph in
  let view =
    let%map state and inject and by and label in
    let button op action =
      N.button ~attr:(A.on_click (fun _ -> inject action)) [ N.textf "%s%d" op by ]
    in
    N.div
      [ Vdom.Node.span [ N.textf "%s: " label ]
      ; button "-" `Decr
      ; Vdom.Node.span [ N.textf "%d" state ]
      ; button "+" `Incr
      ]
  in
  view, state
;;
