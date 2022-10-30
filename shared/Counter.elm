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
