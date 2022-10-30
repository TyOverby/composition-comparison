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
