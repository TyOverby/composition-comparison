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
