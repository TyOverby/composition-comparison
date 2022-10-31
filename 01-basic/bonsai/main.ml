open! Core
open! Import

let app = Counter.component ~label:(Value.return "counter") ()
let () = Start.start app
