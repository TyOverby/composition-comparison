module Main exposing (main)
import Browser
import Counter

main = Browser.sandbox { init = Counter.init, update = Counter.update, view = Counter.view }
