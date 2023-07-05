open! Core
open! Import

let app graph =
  let counter_view, how_many = Counter.component ~label:(Bonsai.return "how many") graph in
  let map =
    let%map how_many in
    List.init how_many ~f:(fun i -> i, ()) |> Int.Map.of_alist_exn
  in
  let others = Bonsai.assoc (module Int) map graph ~f:(fun key _data graph ->
    let view, _ = Counter.component ~label:(key >>| Int.to_string) graph in
    view)
  in
  let%map counter_view and others in
  N.div (counter_view :: Map.data others)
;;

let () = Start.start app
