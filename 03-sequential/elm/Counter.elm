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
