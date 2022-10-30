module Main exposing (main)

import Browser
import Counter


view =
    Counter.view "counter"


main =
    Browser.sandbox { init = Counter.init, update = Counter.update, view = view }
