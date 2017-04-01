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
  , questions : List Question
  }

type alias Question =
  { title : String
  , prompt : String
  , score : Int
  , id : Int
  , userStatus : Status
  }

type Status
  = Upvoted
  | Downvoted
  | Neutral

init : Model
init =
  Model {{ score }} "{{ name }}" questions

-- UPDATE

type Msg
  = Noop
  | Upvote Question
  | Downvote Question

increaseScore : Question -> Question
increaseScore question =
  { question | score = question.score + 1 }

decreaseScore : Question -> Question
decreaseScore question =
  { question | score = question.score - 1 }

setStatus : Status -> Question -> Question
setStatus newStatus question =
  { question | userStatus = newStatus }

undoExistingVote : Question -> Question
undoExistingVote question =
  case question.userStatus of
    Upvoted ->
      question
        |> decreaseScore
        |> setStatus Neutral
    Downvoted ->
      question
        |> increaseScore
        |> setStatus Neutral
    Neutral ->
      question


updateQuestion : Status -> Question -> Question
updateQuestion newStatus question =
  case newStatus of
    Upvoted ->
      question
        |> undoExistingVote
        |> increaseScore
        |> setStatus Upvoted
    Downvoted ->
      question
        |> undoExistingVote
        |> decreaseScore
        |> setStatus Downvoted
    _ ->
      question
        |> setStatus Neutral

updateQuestions : List Question -> Int -> Status -> List Question
updateQuestions questions id newStatus =
  case questions of
    [] ->
      []
    first :: rest ->
      if first.id == id then
        updateQuestion newStatus first :: updateQuestions rest id newStatus
      else
        first :: updateQuestions rest id newStatus

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Noop ->
      model ! []

    Upvote question ->
      { model | questions = (updateQuestions model.questions question.id Upvoted) }
        ! []

    Downvote question ->
      { model | questions = (updateQuestions model.questions question.id) Downvoted}
        ! []

-- VIEW

upvoteButton : Question -> Html Msg
upvoteButton question =
  case question.userStatus of
    Upvoted ->
      button [ onClick <| Upvote question, class "disabled btn cyan lighten-3 waves-effect waves-light" ] [icon "arrow_drop_up"]

    _ ->
      button [ onClick <| Upvote question, class "btn cyan lighten-3 waves-effect waves-light" ] [icon "arrow_drop_up"]

downvoteButton : Question -> Html Msg
downvoteButton question =
  case question.userStatus of
    Downvoted ->
      button [ onClick <| Downvote question, class "disabled btn cyan lighten-3 waves-effect waves-light" ] [icon "arrow_drop_down"]

    _ ->
      button [ onClick <| Downvote question, class "btn cyan lighten-3 waves-effect waves-light" ] [icon "arrow_drop_down"]

card : Question -> Html Msg
card question =
  div [ class "row" ]
    [ div [ class "col s10 offset-s1" ]
      [ div [ class "card-panel cyan lighten-1 row" ]
        [ div [ class "col s9 m10" ]
          [ h4 [ class "white-text thin" ] [ text question.title ]
          , span [ class "white-text" ] [ text question.prompt ]
          ]
        , div [ class "col s3 m2 white-text center" ]
          [ upvoteButton question
          , h4 [ class "thin" ] [ text <| toString question.score ]
          , downvoteButton question
          ]
        ]
      ]     
    ]

icon : String -> Html Msg
icon name =
  i [ class "material-icons" ] [ text name ]

createButton : Html Msg
createButton =
  div [ class "fixed-action-btn" ]
    [ button [ class "btn-floating btn-large waves-effect waves-light cyan lighten-3" ]
      [ icon "add"
      ]
    ]

navbar : Html Msg
navbar =
  div [ class "navbar-fixed" ]
    [ nav []
      [ div [ class "nav-wrapper cyan lighten-3" ]
        [ a [ class "brand-logo center" ] [ text "Vogo" ]
        ]
      ]
    ]

questions : List Question
questions =
  [ Question "Title of Q" "lorem ipsum dolor sit amet" 0 1 Neutral
  , Question "Second Q" "lorem ipsum dolor sit amet" 0 2 Neutral
  , Question "Second Q" "lorem ipsum dolor sit amet" 0 3 Neutral
  , Question "Second Q" "lorem ipsum dolor sit amet" 0 2 Neutral
  , Question "Second Q" "lorem ipsum dolor sit amet" 0 5 Neutral
  ]

view : Model -> Html Msg
view model =
  div [ class "cyan lighten-5" ]
    [ navbar
    , createButton
    {--
    , h2 [] [text <| toString model.score]
    , h2 [] [text model.name]
    , h2 [] [text "YAY!"]
    --}
    , div [] (List.map card model.questions)
    ]

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
