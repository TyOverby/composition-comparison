open! Core
open! Import

let app =
  let%sub counter_view, how_many =
    Counter.component ~label:(Value.return "how many") ()
  in
  let%sub map =
    let%arr how_many = how_many in
    List.init how_many ~f:(fun i -> i, ()) |> Int.Map.of_alist_exn
  in
  let%sub others =
    Bonsai.assoc
      (module Int)
      map
      ~f:(fun key _data ->
        let%sub label =
          let%arr key = key in
          Int.to_string key
        in
        let%sub view, _ = Counter.component ~label () in
        return view)
  in
  let%arr counter_view = counter_view
  and others = others in
  N.div (counter_view :: Map.data others)
;;

let () = Start.start app
