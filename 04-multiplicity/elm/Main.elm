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
