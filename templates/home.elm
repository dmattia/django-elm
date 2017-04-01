module TestModule exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode

main =
  Html.program
    { init = init ! []
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

-- MODEL

type alias Model =
  { score : Int
  , name : String
  }

init : Model
init =
  Model {{ score }} "{{ name }}"

-- UPDATE

type Msg
  = Noop

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Noop ->
      model ! []

-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ h2 [] [text <| toString model.score]
    , h2 [] [text model.name]
    , h2 [] [text "YAY!"]
    ]

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
