open! Bonsai_web

let start c =
  let _ =
    Start.start
      ~bind_to_element_with_id:"app"
      Start.Result_spec.just_the_view
      c
  in
  ()
;;
