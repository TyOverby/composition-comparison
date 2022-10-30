open! Core
open! Import

let app = Counter.component ~label:(Value.return "counter") ()

let _ =
  Start.start
    ~bind_to_element_with_id:"app"
    Start.Result_spec.just_the_view
    app
;;
