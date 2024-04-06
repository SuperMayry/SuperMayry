module Frontend exposing (..)

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Html
import Html.Attributes as Attr
import Lamdera
import Types exposing (..)
import Url


type alias Model =
    FrontendModel


app =
    Lamdera.frontend
        { init = init
        , onUrlRequest = UrlClicked
        , onUrlChange = UrlChanged
        , update = update
        , updateFromBackend = updateFromBackend
        , subscriptions = \m -> Sub.none
        , view = view
        }


init : Url.Url -> Nav.Key -> ( Model, Cmd FrontendMsg )
init url key =
    ( { key = key
      }
    , Cmd.none
    )


update : FrontendMsg -> Model -> ( Model, Cmd FrontendMsg )
update msg model =
    case msg of
        UrlClicked urlRequest ->
            case urlRequest of
                Internal url ->
                    ( model
                    , Nav.pushUrl model.key (Url.toString url)
                    )

                External url ->
                    ( model
                    , Nav.load url
                    )

        UrlChanged url ->
            ( model, Cmd.none )

        NoOpFrontendMsg ->
            ( model, Cmd.none )


updateFromBackend : ToFrontend -> Model -> ( Model, Cmd FrontendMsg )
updateFromBackend msg model =
    case msg of
        NoOpToFrontend ->
            ( model, Cmd.none )


view : Model -> Browser.Document FrontendMsg
view model =
    { title = ""
    , body =
        [ layout [ width fill, height fill ] <| displayMyWebsite model
        ]
    }


displayMyWebsite : Model -> Element FrontendMsg
displayMyWebsite model =
    column [ width fill, height fill, paddingXY 48 24, Background.color smokeColor, Font.color white ]
        [ el
            [ centerX
            , Font.size 51
            ]
          <|
            text "SuperMayry 19 🏀"
        , column
            [ centerY
            , centerX
            , spacing 8
            ]
          <|
            [ el [ centerX ] <| text "Welcome to my new website!"
            , text "I hope to learn to improve this website first 🏀 LETS GOOO 😘"
            ]
        ]


smokeColor : Color
smokeColor =
    rgb255 60 60 60


white : Color
white =
    rgb255 255 255 255


black : Color
black =
    rgb255 0 0 0
