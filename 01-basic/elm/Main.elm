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
