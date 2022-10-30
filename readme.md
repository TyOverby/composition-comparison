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

let default_model = 0

let apply_action ~inject:_ ~schedule_event:_ by model action =
  match (action : Action.t) with
  | Incr -> model + by
  | Decr -> model - by
;;

let component' ~label ?(by = Value.return 1) () =
  let%sub state_and_inject =
    Bonsai.state_machine1
      (module Int)
      (module Action)
      ~default_model
      ~apply_action
      by
  in
  let%arr state, inject = state_and_inject
  and by = by
  and label = label in
  let button op action =
    N.button
      ~attr:(A.on_click (fun _ -> inject action))
      [ N.textf "%s%d" op by ]
  in
  let view =
    N.div
      [ N.textf "%s: " label
      ; button "-" Decr
      ; N.textf "%d" state
      ; button "+" Incr
      ]
  in
  view, state
;;

let component ~label ?by () =
  let%map.Computation view, _ = component' ~label ?by () in
  view
;;
```

</td>
<td valign="top">

<!-- $MDX file=shared/Counter.elm -->
```elm
module Counter exposing (Model, Msg, init, update, view)

import Browser
import Html exposing (Html, div, span, text)
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
    let
        button op action =
            Html.button [ onClick action ] [ text (String.concat [ op, String.fromInt howMuch ]) ]
    in
    div []
        [ text (String.concat [ label, ": " ])
        , button "-" Decrement
        , text (String.fromInt model)
        , button "+" Increment
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

let app = Counter.component ~label:(Value.return "counter") ()

let _ =
  Start.start ~bind_to_element_with_id:"app" Start.Result_spec.just_the_view app
;;
```

</td>
<td valign="top">

<!-- $MDX file=01-basic/elm/Main.elm -->
```elm
module Main exposing (main)

import Browser
import Counter


update =
    Counter.update 1


view =
    Counter.view 1 "counter"


main =
    Browser.sandbox { init = Counter.init, update = update, view = view }
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
  let%sub first = Counter.component ~label:(Value.return "first") () in
  let%sub second = Counter.component ~label:(Value.return "second") () in
  let%arr first = first
  and second = second in
  N.div [ first; second ]
;;

let _ =
  Start.start ~bind_to_element_with_id:"app" Start.Result_spec.just_the_view app
;;
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

<table>
<tr>
<th>Bonsai</th>
<th>Elm</th>
</tr>
<tr>
<td valign="top">

<!-- $MDX file=03-sequential/bonsai/main.ml -->
```ocaml
open! Core
open! Import

let app =
  let%sub first_view, by =
    Counter.component' ~label:(Value.return "first") ()
  in
  let%sub second_view =
    Counter.component ~label:(Value.return "second") ~by ()
  in
  let%arr first = first_view
  and second = second_view in
  N.div [ first; second ]
;;

let _ =
  Start.start ~bind_to_element_with_id:"app" Start.Result_spec.just_the_view app
;;
```

</td> <td valign="top">

<!-- $MDX file=03-sequential/elm/Main.elm -->
```elm
module Main exposing (main)

import Browser
import Counter
import Html exposing (Html, div)


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
        [ Counter.view 1 "first" model.first |> Html.map First
        , Counter.view model.first "second" model.second |> Html.map Second
        ]


main =
    Browser.sandbox { init = init, update = update, view = view }
```

</td>
</tr>
</table>

# 04 - Multiplicity

<table>
<tr>
<th>Bonsai</th>
<th>Elm</th>
</tr>
<tr>
<td valign="top">

<!-- $MDX file=04-multiplicity/bonsai/main.ml -->
```ocaml
open! Core
open! Import

let app =
  let%sub counter_view, how_many =
    Counter.component' ~label:(Value.return "how many") ()
  in
  let%sub map =
    let%arr how_many = how_many in
    Int.Map.of_alist_exn (List.init how_many ~f:(fun i -> i, ()))
  in
  let%sub others = Bonsai.assoc (module Int) map ~f:(fun key _data ->
    let label = Value.map key ~f:Int.to_string in
    Counter.component ~label ())
  in
  let%arr counter_view = counter_view
  and others = others in
  N.div (counter_view :: Map.data others)
;;

let _ =
  Start.start ~bind_to_element_with_id:"app" Start.Result_spec.just_the_view app
;;
```

</td><td valign="top">

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
            { model
                | others =
                    Dict.update which (updateSubcomponent msg) model.others
            }


mapKey : Int -> Counter.Msg -> Msg
mapKey which msg =
    ForKey { msg = msg, which = which }


viewSubcomponent : Dict Int Counter.Model -> Int -> Html Msg
viewSubcomponent models key =
    case Dict.get key models of
        Just model ->
            Counter.view 1 (String.fromInt key) model
                |> Html.map (mapKey key)

        Nothing ->
            Counter.view 1 (String.fromInt key) Counter.init
                |> Html.map (mapKey key)


view : Model -> Html Msg
view model =
    List.range 0 (model.howMany - 1)
        |> List.map (viewSubcomponent model.others)
        |> List.append [ Html.map HowMany (Counter.view 1 "how many" model.howMany) ]
        |> div []


main =
    Browser.sandbox { init = init, update = update, view = view }
```

</td>
</tr>
</table>
