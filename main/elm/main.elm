-- Read more about this program in the official Elm guide:
-- https://guide.elm-lang.org/architecture/effects/http.html

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode

main =
  Html.programWithFlags
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

-- MODEL

type alias Flags =
  { score : String
  , name : String
  }

type alias Model =
  { score : Int
  , name : String
  }

init : Flags -> (Model, Cmd Msg)
init flags =
  Model
    (String.toInt flags.score |> Result.toMaybe |> Maybe.withDefault 0)
    flags.name
    ! []

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
    ]



-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
