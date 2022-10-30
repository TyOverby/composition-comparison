
# Basic Components

## Bonsai

<details open><summary><h3><code>counter.ml</code></h3></summary>

<!-- $MDX file=01-basic/bonsai/counter.ml -->
```ocaml
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

let component =
  let%sub state_and_inject =
    Bonsai.state_machine0
      (module Int)
      (module Action)
      ~default_model:0
      ~apply_action
  in
  let%arr state, inject = state_and_inject in
  N.div
    [ N.button ~attr:(A.on_click (fun _ -> inject Decr)) [ N.text "-1" ]
    ; N.span [ N.textf "%d" state ]
    ; N.button ~attr:(A.on_click (fun _ -> inject Incr)) [ N.text "+1" ]
    ]
;;
```

</details>

<details open><summary><h3><code>main.ml</code></h3></summary>

<!-- $MDX file=01-basic/bonsai/main.ml -->
```ocaml
open! Core
open! Import

let app = Counter.component

let _ =
  Start.start ~bind_to_element_with_id:"app" Start.Result_spec.just_the_view app
;;
```

</details>


## Elm

<details open><summary><h3><code>Counter.elm</code></h3></summary>

<!-- $MDX file=01-basic/elm/src/Counter.elm -->
```elm
module Counter exposing (Model, Msg, init, update, view)

import Browser
import Html exposing (Html, button, div, span, text)
import Html.Events exposing (onClick)


type alias Model =
    Int


init : Model
init =
    0


type Msg
    = Increment
    | Decrement


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            model + 1

        Decrement ->
            model - 1


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Decrement ] [ text "-1" ]
        , span [] [ text (String.fromInt model) ]
        , button [ onClick Increment ] [ text "+1" ]
        ]
```

</details>

<details open><summary><h3><code>Main.elm</code></h3></summary>

<!-- $MDX file=01-basic/elm/src/Main.elm -->
```elm
module Main exposing (main)

import Browser
import Counter


main =
    Browser.sandbox { init = Counter.init, update = Counter.update, view = Counter.view }
```

</details>
