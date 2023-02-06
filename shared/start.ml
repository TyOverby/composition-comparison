open! Bonsai_web

module _ =
[%css
stylesheet
  {|
  body {
    padding: 4em;
    font-family: sans-serif;
  }

  body>div>div *:nth-child(1) {
    display:inline-block;
    width:75px;
  }

  body>div>div *:nth-child(3) {
    display:inline-flex;
    justify-content:center;
    width:25px;
  }

  button {
    margin: 0.5em;
  }

|}]

let start c =
  let _ = Start.start ~bind_to_element_with_id:"app" Start.Result_spec.just_the_view c in
  ()
;;
