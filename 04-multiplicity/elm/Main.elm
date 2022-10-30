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
