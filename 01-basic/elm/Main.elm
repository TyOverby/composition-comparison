module Main exposing (main)

import Browser
import Counter


update =
    Counter.update 1


view =
    Counter.view 1 "counter"


main =
    Browser.sandbox { init = Counter.init, update = update, view = view }
