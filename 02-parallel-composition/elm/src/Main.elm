module Main exposing (main)
import Browser
import Html exposing (Html, div, map)
import Counter

type alias Model = { first: Counter.Model, second: Counter.Model }

init : Model
init = { first = Counter.init, second = Counter.init }

type Msg = 
      First Counter.Msg
    | Second Counter.Msg

update : Msg -> Model -> Model
update msg model =
  case msg of
    First msg_first -> { model | first = Counter.update msg_first model.first }
    Second msg_second -> { model | second = Counter.update msg_second model.second }

view : Model -> Html Msg
view model =
  div []
    [ map First (Counter.view model.first)
    , map Second (Counter.view model.second)
    ]

main = Browser.sandbox { init = init, update = update, view = view }
