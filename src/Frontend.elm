module Frontend exposing (..)

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav
import Element exposing (..)
import Element.Background as Background exposing (..)
import Element.Border as Border
import Element.Font as Font
import Html
import Lamdera
import Palette.Color exposing (..)
import Svg exposing (Svg, line)
import Svg.Attributes as Svg exposing (viewBox)
import Task
import Time
import Types exposing (..)
import Url


app =
    Lamdera.frontend
        { init = init
        , onUrlRequest = UrlClicked
        , onUrlChange = UrlChanged
        , update = update
        , updateFromBackend = updateFromBackend
        , subscriptions = subscriptions
        , view = view
        }


init : Url.Url -> Nav.Key -> ( FrontendModel, Cmd FrontendMsg )
init _ key =
    ( { key = key, zone = Time.utc, time = Time.millisToPosix 0 }
    , Cmd.batch
        [ Task.perform AdjustTimeZone Time.here
        , Task.perform Tick Time.now -- เพิ่มเติมเวลาประเทศไทย
        ]
    )


update : FrontendMsg -> FrontendModel -> ( FrontendModel, Cmd FrontendMsg )
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

        UrlChanged _ ->
            ( model, Cmd.none )

        NoOpFrontendMsg ->
            ( model, Cmd.none )

        Tick newTime ->
            ( { model | time = newTime }
            , Cmd.none
            )

        AdjustTimeZone newZone ->
            ( { model | zone = newZone }
            , Cmd.none
            )


updateFromBackend : ToFrontend -> FrontendModel -> ( FrontendModel, Cmd FrontendMsg )
updateFromBackend msg model =
    case msg of
        NoOpToFrontend ->
            ( model, Cmd.none )


subscriptions : FrontendModel -> Sub FrontendMsg
subscriptions _ =
    Time.every 1000 Tick


view : FrontendModel -> Browser.Document FrontendMsg
view model =
    { title = "SuperMayry 19 🏀"
    , body =
        [ layout [ width fill, height fill ] <| displayMyWebsite model ]
    }


menu : FrontendModel -> Element FrontendMsg
menu model =
    row
        [ width fill
        , padding 20
        , spacing 64
        ]
        [ displaySimpleClock model
        , el [ alignRight, alignTop, pointer ] <| text "Home"
        , el [ alignRight, alignTop, pointer ] <| text "About Me"
        , el [ alignRight, alignTop, pointer ] <| text "My Gallery"
        , el [ alignRight, alignTop, pointer ] <| text "Contact"
        ]


displayMyWebsite : FrontendModel -> Element FrontendMsg
displayMyWebsite model =
    column [ width fill, height fill, paddingXY 48 24, Background.color smokeColor, Font.color white, spacing 64, scrollbars ]
        [ menu model
        , paragraph
            [ width fill
            , Font.center
            , Font.size 51
            , Font.italic
            , Font.bold
            , Font.letterSpacing 13
            ]
            [ el
                [ centerX
                , Font.color pink
                ]
                (text "Super")
            , el
                [ centerX
                , Font.color blue
                ]
                (text "Mayry 19 🏀")
            ]
        , column
            [ centerX
            , spacing 8
            , Font.shadow { offset = ( 2, 4 ), blur = 3, color = rgb255 194 204 255 }
            ]
            [ el [ centerX ] (text "Welcome to my new website!")
            , text "I hope to learn to improve this website first 🏀 LETS GOOO 😘"
            ]
        , Element.image [ width (px 400), centerX ]
            { src = "https://scontent.fvte2-2.fna.fbcdn.net/v/t1.18169-9/46447_10200235267985360_400189615_n.jpg?_nc_cat=108&ccb=1-7&_nc_sid=5f2048&_nc_eui2=AeHJZw9IPbK9Brz2SdlTLokD1ykEY9zMxsTXKQRj3MzGxIjUlK5KDJbo23fll31-vjo&_nc_ohc=B6Xhb1fx6zcAb7PnvAp&_nc_ht=scontent.fvte2-2.fna&oh=00_AfCrVAOmGY9hLMTh2p35KBuUlrAl-_8dqXQf_pYZ8eUTPA&oe=664C10A5"
            , description = "Basketballmayry"
            }
        ]


displaySimpleClock : FrontendModel -> Element FrontendMsg
displaySimpleClock model =
    let
        hour =
            String.fromInt (Time.toHour model.zone model.time)

        minute =
            String.fromInt (Time.toMinute model.zone model.time)

        second =
            String.fromInt (Time.toSecond model.zone model.time)
    in
    el [ Font.size 32 ] (text (hour ++ ":" ++ minute ++ ":" ++ second))
