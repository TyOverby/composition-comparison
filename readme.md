
# 01 - Basic Components

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


# 02 - Parallel Composition

## Bonsai

<details><summary><h3><code>counter.ml</code> (unchanged)</h3></summary>

<!-- $MDX file=02-parallel/bonsai/counter.ml -->
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

<!-- $MDX file=02-parallel/bonsai/main.ml -->
```ocaml
open! Core
open! Import

let app =
  let%sub first = Counter.component in
  let%sub second = Counter.component in
  let%arr first = first
  and second = second in
  N.div [ first; second ]
;;

let _ =
  Start.start ~bind_to_element_with_id:"app" Start.Result_spec.just_the_view app
;;
```

</details>


## Elm

<details><summary><h3><code>Counter.elm</code> (unchanged)</h3></summary>

<!-- $MDX file=02-parallel/elm/src/Counter.elm -->
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

<!-- $MDX file=02-parallel/elm/src/Main.elm -->
```elm
module Main exposing (main)

import Browser
import Counter
import Html exposing (Html, div, map)


type alias Model =
    { first : Counter.Model, second : Counter.Model }


init : Model
init =
    { first = Counter.init, second = Counter.init }


type Msg
    = First Counter.Msg
    | Second Counter.Msg


update : Msg -> Model -> Model
update msg model =
    case msg of
        First msg_first ->
            { model | first = Counter.update msg_first model.first }

        Second msg_second ->
            { model | second = Counter.update msg_second model.second }


view : Model -> Html Msg
view model =
    div []
        [ map First (Counter.view model.first)
        , map Second (Counter.view model.second)
        ]


main =
    Browser.sandbox { init = init, update = update, view = view }
```

</details>

# 03 - Sequential Composition

## Bonsai

<details open><summary><h3><code>counter.ml</code></h3></summary>

<!-- $MDX file=03-sequential/bonsai/counter.ml -->
```ocaml
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

let component ~how_much =
  let%sub state_and_inject =
    Bonsai.state_machine1
      (module Int)
      (module Action)
      ~default_model:0
      ~apply_action
      how_much
  in
  let%arr state, inject = state_and_inject
  and how_much = how_much in
  let view =
    N.div
      [ N.button ~attr:(A.on_click (fun _ -> inject Decr)) [ N.textf "-%d" how_much ]
      ; N.span [ N.textf "%d" state ]
      ; N.button ~attr:(A.on_click (fun _ -> inject Incr)) [ N.textf "+%d" how_much ]
      ]
  in
  view, state
;;
```
</details>

<details><summary><h3><code>counter.ml</code> (diff)</h3></summary>

```sh
$ patdiff -dont-produce-unified-lines 01-basic/bonsai/counter.ml 03-sequential/bonsai/counter.ml
------ 01-basic/bonsai/counter.ml
++++++ 03-sequential/bonsai/counter.ml
@|-1,31 +1,36 ============================================================
 |open! Core
 |open! Import
 |
 |module Action = struct
 |  type t =
 |    | Incr
 |    | Decr
 |  [@@deriving sexp_of]
 |end
 |
-|let apply_action ~inject:_ ~schedule_event:_ model (action : Action.t) =
+|let apply_action ~inject:_ ~schedule_event:_ how_much model (action : Action.t) =
 |  match action with
-|  | Incr -> model + 1
+|  | Incr -> model + how_much
-|  | Decr -> model - 1
+|  | Decr -> model - how_much
 |;;
 |
-|let component =
+|let component ~how_much =
 |  let%sub state_and_inject =
-|    Bonsai.state_machine0
+|    Bonsai.state_machine1
 |      (module Int)
 |      (module Action)
 |      ~default_model:0
 |      ~apply_action
+|      how_much
 |  in
-|  let%arr state, inject = state_and_inject in
+|  let%arr state, inject = state_and_inject
+|  and how_much = how_much in
+|  let view =
 |    N.div
-|    [ N.button ~attr:(A.on_click (fun _ -> inject Decr)) [ N.text "-1" ]
+|      [ N.button ~attr:(A.on_click (fun _ -> inject Decr)) [ N.textf "-%d" how_much ]
 |      ; N.span [ N.textf "%d" state ]
-|    ; N.button ~attr:(A.on_click (fun _ -> inject Incr)) [ N.text "+1" ]
+|      ; N.button ~attr:(A.on_click (fun _ -> inject Incr)) [ N.textf "+%d" how_much ]
 |      ]
+|  in
+|  view, state
 |;;
[1]
```

</details>

<details open><summary><h3><code>main.ml</code></h3></summary>

<!-- $MDX file=03-sequential/bonsai/main.ml -->
```ocaml
open! Core
open! Import

let app =
  let%sub first_view, how_much = Counter.component ~how_much:(Value.return 1) in
  let%sub second_view, _ = Counter.component ~how_much in
  let%arr first = first_view
  and second = second_view in
  N.div [ first; second ]
;;

let _ = Start.start ~bind_to_element_with_id:"app" Start.Result_spec.just_the_view app
```

</details>


## Elm

<details open><summary><h3><code>Counter.elm</code></h3></summary>

<!-- $MDX file=03-sequential/elm/src/Counter.elm -->
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


update : Int -> Msg -> Model -> Model
update howMuch msg model =
    case msg of
        Increment ->
            model + howMuch

        Decrement ->
            model - howMuch


view : Int -> Model -> Html Msg
view howMuch model =
    div []
        [ button [ onClick Decrement ] [ text (String.concat [ "-", String.fromInt howMuch ]) ]
        , span [] [ text (String.fromInt model) ]
        , button [ onClick Increment ] [ text (String.concat [ "+", String.fromInt howMuch ]) ]
        ]
```
</details>

<details><summary><h3><code>Counter.elm</code> (diff)</h3></summary>

```sh
$ patdiff -dont-produce-unified-lines 01-basic/elm/src/Counter.elm 03-sequential/elm/src/Counter.elm
------ 01-basic/elm/src/Counter.elm
++++++ 03-sequential/elm/src/Counter.elm
@|-6,33 +6,33 ============================================================
 |
 |
 |type alias Model =
 |    Int
 |
 |
 |init : Model
 |init =
 |    0
 |
 |
 |type Msg
 |    = Increment
 |    | Decrement
 |
 |
-|update : Msg -> Model -> Model
-|update msg model =
+|update : Int -> Msg -> Model -> Model
+|update howMuch msg model =
 |    case msg of
 |        Increment ->
-|            model + 1
+|            model + howMuch
 |
 |        Decrement ->
-|            model - 1
+|            model - howMuch
 |
 |
-|view : Model -> Html Msg
-|view model =
+|view : Int -> Model -> Html Msg
+|view howMuch model =
 |    div []
-|        [ button [ onClick Decrement ] [ text "-1" ]
+|        [ button [ onClick Decrement ] [ text (String.concat [ "-", String.fromInt howMuch ]) ]
 |        , span [] [ text (String.fromInt model) ]
-|        , button [ onClick Increment ] [ text "+1" ]
+|        , button [ onClick Increment ] [ text (String.concat [ "+", String.fromInt howMuch ]) ]
 |        ]
[1]
```

</details>

<details open><summary><h3><code>main.ml</code></h3></summary>

<!-- $MDX file=03-sequential/elm/src/Main.elm -->
```elm
module Main exposing (main)

import Browser
import Counter
import Html exposing (Html, div, map)


type alias Model =
    { first : Counter.Model, second : Counter.Model }


init : Model
init =
    { first = Counter.init, second = Counter.init }


type Msg
    = First Counter.Msg
    | Second Counter.Msg


update : Msg -> Model -> Model
update msg model =
    case msg of
        First msg_first ->
            { model | first = Counter.update 1 msg_first model.first }

        Second msg_second ->
            { model | second = Counter.update model.first msg_second model.second }


view : Model -> Html Msg
view model =
    div []
        [ map First (Counter.view 1 model.first)
        , map Second (Counter.view model.first model.second)
        ]


main =
    Browser.sandbox { init = init, update = update, view = view }
```

</details>

# 04 - Multiplicity

## Bonsai

<details><summary><h3><code>counter.ml</code> (largely unchanged) </h3></summary>

<!-- $MDX file=04-multiplicity/bonsai/counter.ml -->
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
```
</details>

<details><summary><h3><code>counter.ml</code> (diff)</h3></summary>

```sh
$ patdiff -dont-produce-unified-lines 01-basic/bonsai/counter.ml 04-multiplicity/bonsai/counter.ml
------ 01-basic/bonsai/counter.ml
++++++ 04-multiplicity/bonsai/counter.ml
@|-1,31 +1,32 ============================================================
 |open! Core
 |open! Import
 |
 |module Action = struct
 |  type t =
 |    | Incr
 |    | Decr
 |  [@@deriving sexp_of]
 |end
 |
 |let apply_action ~inject:_ ~schedule_event:_ model (action : Action.t) =
 |  match action with
 |  | Incr -> model + 1
 |  | Decr -> model - 1
 |;;
 |
-|let component =
+|let component label =
 |  let%sub state_and_inject =
 |    Bonsai.state_machine0 (module Int) (module Action) ~default_model:0 ~apply_action
-|  in
-|  let%arr state, inject = state_and_inject in
-|  N.div
-|    [ N.button ~attr:(A.on_click (fun _ -> inject Decr)) [ N.text "-1" ]
+|  in
+|  let%arr state, inject = state_and_inject
+|  and label = label in
+|  let view =
+|    N.div
+|      [ N.span [ N.textf "%s: " label ]
+|      ; N.button ~attr:(A.on_click (fun _ -> inject Decr)) [ N.text "-1" ]
 |      ; N.span [ N.textf "%d" state ]
 |      ; N.button ~attr:(A.on_click (fun _ -> inject Incr)) [ N.text "+1" ]
 |      ]
+|  in
+|  view, state
 |;;
[1]
```

</details>

<details open><summary><h3><code>main.ml</code></h3></summary>

<!-- $MDX file=04-multiplicity/bonsai/main.ml -->
```ocaml
open! Core
open! Import

let app =
  let%sub counter_view, how_many = Counter.component (Value.return "how many") in
  let%sub map =
    let%arr how_many = how_many in
    Int.Map.of_alist_exn (List.init how_many ~f:(fun i -> i, ()))
  in
  let make_subcomponent key _data =
    let%sub subcomponent = Counter.component (Value.map key ~f:Int.to_string) in
    let%arr view, _ = subcomponent in
    view
  in
  let%sub others = Bonsai.assoc (module Int) map ~f:make_subcomponent in
  let%arr counter_view = counter_view
  and others = others in
  N.div (counter_view :: Map.data others)
;;

let _ = Start.start ~bind_to_element_with_id:"app" Start.Result_spec.just_the_view app
```

</details>


## Elm

<details><summary><h3><code>Counter.elm</code> (largely unchanged)</h3></summary>

<!-- $MDX file=04-multiplicity/elm/src/Counter.elm -->
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


view : String -> Model -> Html Msg
view label model =
    div []
        [ span [] [ text (String.concat [ label, ": " ]) ]
        , button [ onClick Decrement ] [ text "-1" ]
        , span [] [ text (String.fromInt model) ]
        , button [ onClick Increment ] [ text "+1" ]
        ]
```
</details>

<details><summary><h3><code>Counter.elm</code> (diff)</h3></summary>

```sh
$ patdiff -dont-produce-unified-lines 01-basic/elm/src/Counter.elm 04-multiplicity/elm/src/Counter.elm
------ 01-basic/elm/src/Counter.elm
++++++ 04-multiplicity/elm/src/Counter.elm
@|-16,23 +16,24 ============================================================
 |
 |type Msg
 |    = Increment
 |    | Decrement
 |
 |
 |update : Msg -> Model -> Model
 |update msg model =
 |    case msg of
 |        Increment ->
 |            model + 1
 |
 |        Decrement ->
 |            model - 1
 |
 |
-|view : Model -> Html Msg
-|view model =
+|view : String -> Model -> Html Msg
+|view label model =
-|    div []
-|        [ button [ onClick Decrement ] [ text "-1" ]
+|    div []
+|        [ span [] [ text (String.concat [ label, ": " ]) ]
+|        , button [ onClick Decrement ] [ text "-1" ]
 |        , span [] [ text (String.fromInt model) ]
 |        , button [ onClick Increment ] [ text "+1" ]
 |        ]
[1]
```

</details>

<details open><summary><h3><code>main.ml</code></h3></summary>

<!-- $MDX file=04-multiplicity/elm/src/Main.elm -->
```elm
module Main exposing (main)

import Browser
import Counter
import Dict exposing (Dict)
import Html exposing (Html, div, map)


type alias Model =
    { howMany : Counter.Model, others : Dict Int Counter.Model }


init : Model
init =
    { howMany = Counter.init, others = Dict.empty }


type Msg
    = HowMany Counter.Msg
    | ForKey { msg : Counter.Msg, which : Int }


updateSubcomponent : Counter.Msg -> Maybe Counter.Model -> Maybe Counter.Model
updateSubcomponent msg maybeModel =
    case maybeModel of
        Nothing ->
            Just (Counter.update msg 0)

        Just model_for_other ->
            Just (Counter.update msg model_for_other)


update : Msg -> Model -> Model
update appMsg model =
    case appMsg of
        HowMany msgHowMany ->
            { model | howMany = Counter.update msgHowMany model.howMany }

        ForKey { msg, which } ->
            let
                others =
                    Dict.update which (updateSubcomponent msg) model.others
            in
            { model | others = others }


mapKey : Int -> Counter.Msg -> Msg
mapKey which msg =
    ForKey { msg = msg, which = which }


viewSubcomponent : Dict Int Counter.Model -> Int -> Html Msg
viewSubcomponent models key =
    let
        html =
            case Dict.get key models of
                Just model ->
                    Counter.view (String.fromInt key) model

                Nothing ->
                    Counter.view (String.fromInt key) Counter.init
    in
    Html.map (mapKey key) html


view : Model -> Html Msg
view model =
    div []
        (List.append [ Html.map HowMany (Counter.view "how many" model.howMany) ]
            (List.map (viewSubcomponent model.others) (List.range 0 (model.howMany - 1)))
        )


main =
    Browser.sandbox { init = init, update = update, view = view }
```

</details>
