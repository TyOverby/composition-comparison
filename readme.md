# 01 - Basic Components

## Defining a component
<table>
<tr>
<th>Bonsai</th>
<th>Elm</th>
</tr>
<tr>
<td valign="top">

<!-- $MDX file=shared/counter.ml -->
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

let component ~label ~how_much =
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
```

</td>
<td valign="top">

<!-- $MDX file=shared/Counter.elm -->
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


view : Int -> String -> Model -> Html Msg
view howMuch label model =
    div []
        [ span [] [ text (String.concat [ label, ": " ]) ]
        , button [ onClick Decrement ] [ text (String.concat [ "-", String.fromInt howMuch ]) ]
        , span [] [ text (String.fromInt model) ]
        , button [ onClick Increment ] [ text (String.concat [ "+", String.fromInt howMuch ]) ]
        ]
```

</td>
</tr>
</table>

## Using a component

<table>
<tr>
<th>Bonsai</th>
<th>Elm</th>
</tr>
<tr>
<td valign="top">

<!-- $MDX file=01-basic/bonsai/main.ml -->
```ocaml
open! Core
open! Import

let app =
  let%sub view, _ =
    Counter.component ~label:(Value.return "counter") ~how_much:(Value.return 1)
  in
  return view
;;

let _ = Start.start ~bind_to_element_with_id:"app" Start.Result_spec.just_the_view app
```

</td>
<td valign="top">

<!-- $MDX file=01-basic/elm/Main.elm -->
```elm
module Main exposing (main)

import Browser
import Counter


init =
    Counter.init


update =
    Counter.update 1


view =
    Counter.view 1 "counter"


main =
    Browser.sandbox { init = init, update = update, view = view }
```

</td>
</tr>
</table>


# 02 - Parallel Composition

<table>
<tr>
<th>Bonsai</th>
<th>Elm</th>
</tr>
<tr>
<td valign="top">

<!-- $MDX file=02-parallel/bonsai/main.ml -->
```ocaml
open! Core
open! Import

let app =
  let%sub first, _ =
    Counter.component ~label:(Value.return "first") ~how_much:(Value.return 1)
  in
  let%sub second, _ =
    Counter.component ~label:(Value.return "second") ~how_much:(Value.return 2)
  in
  let%arr first = first
  and second = second in
  N.div [ first; second ]
;;

let _ = Start.start ~bind_to_element_with_id:"app" Start.Result_spec.just_the_view app
```

</td><td valign="top">

<!-- $MDX file=02-parallel/elm/Main.elm -->
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
            { model | second = Counter.update 1 msg_second model.second }


view : Model -> Html Msg
view model =
    div []
        [ map First (Counter.view 1 "first" model.first)
        , map Second (Counter.view 1 "second" model.second)
        ]


main =
    Browser.sandbox { init = init, update = update, view = view }
```

</td>
</tr>
</table>

# 03 - Sequential Composition

## Bonsai

### `main.ml`

<details open><summary>File Contents</summary>

<!-- $MDX file=03-sequential/bonsai/main.ml -->
```ocaml
open! Core
open! Import

let app =
  let%sub first_view, how_much =
    Counter.component ~label:(Value.return "first") ~how_much:(Value.return 1)
  in
  let%sub second_view, _ = Counter.component ~label:(Value.return "second") ~how_much in
  let%arr first = first_view
  and second = second_view in
  N.div [ first; second ]
;;

let _ = Start.start ~bind_to_element_with_id:"app" Start.Result_spec.just_the_view app
```

</details>


## Elm

### `Main.elm`

<details open><summary>File Contents</summary>

<!-- $MDX file=03-sequential/elm/Main.elm -->
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
        [ map First (Counter.view 1 "first" model.first)
        , map Second (Counter.view model.first "second" model.second)
        ]


main =
    Browser.sandbox { init = init, update = update, view = view }
```

</details>

# 04 - Multiplicity

## Bonsai

### `main.ml`

<details open><summary>File Contents</summary>

<!-- $MDX file=04-multiplicity/bonsai/main.ml -->
```ocaml
open! Core
open! Import

let app =
  let%sub counter_view, how_many =
    Counter.component ~label:(Value.return "how many") ~how_much:(Value.return 1)
  in
  let%sub map =
    let%arr how_many = how_many in
    Int.Map.of_alist_exn (List.init how_many ~f:(fun i -> i, ()))
  in
  let make_subcomponent key _data =
    let%sub subcomponent =
      Counter.component ~label:(Value.map key ~f:Int.to_string) ~how_much:(Value.return 1)
    in
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

### `Main.elm`

<details open><summary>File Contents</summary>

<!-- $MDX file=04-multiplicity/elm/Main.elm -->
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
            Just (Counter.update 1 msg 0)

        Just model_for_other ->
            Just (Counter.update 1 msg model_for_other)


update : Msg -> Model -> Model
update appMsg model =
    case appMsg of
        HowMany msgHowMany ->
            { model | howMany = Counter.update 1 msgHowMany model.howMany }

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
                    Counter.view 1 (String.fromInt key) model

                Nothing ->
                    Counter.view 1 (String.fromInt key) Counter.init
    in
    Html.map (mapKey key) html


view : Model -> Html Msg
view model =
    div []
        (List.append [ Html.map HowMany (Counter.view 1 "how many" model.howMany) ]
            (List.map (viewSubcomponent model.others) (List.range 0 (model.howMany - 1)))
        )


main =
    Browser.sandbox { init = init, update = update, view = view }
```

</details>
