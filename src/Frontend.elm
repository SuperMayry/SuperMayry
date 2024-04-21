module Frontend exposing (..)

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav
import Element exposing (..)
import Element.Background as Background exposing (..)
import Element.Border as Border
import Element.Font as Font
import Html
import Html.Attributes as Attr
import Lamdera
import Palette.Color exposing (smokeColor, white)
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
    ( { key = key }
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
    { title = "SuperMayry 19 🏀"
    , body =
        [ layout [ width fill, height fill ] <| displayMyWebsite model
        ]
    }


displayMyWebsite : Model -> Element FrontendMsg
displayMyWebsite model =
    column [ width fill, height fill, paddingXY 48 24, Background.color smokeColor, Font.color white, spacing 64 ]
        [ el
            [ centerX
            , Font.size 51
            , Font.italic
            , Font.bold
            , Font.letterSpacing 13
            ]
            (text "SuperMayry 19 🏀")
        , column
            [ centerX
            , spacing 8
            ]
            [ el [ centerX ] (text "Welcome to my new website!")
            , text "I hope to learn to improve this website first 🏀 LETS GOOO 😘"
            ]
        , Element.image [ width (px 400), centerX ]
            { src = "https://scontent.fvte2-2.fna.fbcdn.net/v/t1.18169-9/46447_10200235267985360_400189615_n.jpg?_nc_cat=108&ccb=1-7&_nc_sid=5f2048&_nc_eui2=AeHJZw9IPbK9Brz2SdlTLokD1ykEY9zMxsTXKQRj3MzGxIjUlK5KDJbo23fll31-vjo&_nc_ohc=B6Xhb1fx6zcAb7PnvAp&_nc_ht=scontent.fvte2-2.fna&oh=00_AfCrVAOmGY9hLMTh2p35KBuUlrAl-_8dqXQf_pYZ8eUTPA&oe=664C10A5"
            , description = "Basketballmayry"
            }
        ]
