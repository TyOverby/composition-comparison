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
    | ForKey Int Counter.Msg


updateOther which msg =
    Dict.update which
        (\m ->
            Just (Counter.update 1 msg (Maybe.withDefault 0 m))
        )


update : Msg -> Model -> Model
update appMsg model =
    case appMsg of
        HowMany msgHowMany ->
            { model | howMany = Counter.update 1 msgHowMany model.howMany }

        ForKey which msg ->
            { model | others = updateOther which msg model.others }


viewOther : Dict Int Counter.Model -> Int -> Html Counter.Msg
viewOther models key =
    case Dict.get key models of
        Just model ->
            Counter.view 1 (String.fromInt key) model

        Nothing ->
            Counter.view 1 (String.fromInt key) Counter.init


view : Model -> Html Msg
view model =
    List.range 0 (model.howMany - 1)
        |> List.map (\i -> Html.map (ForKey i) (viewOther model.others i))
        |> List.append [ Html.map HowMany (Counter.view 1 "how many" model.howMany) ]
        |> div []


main =
    Browser.sandbox { init = init, update = update, view = view }
