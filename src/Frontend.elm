module Frontend exposing (..)

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav
import Element exposing (..)
import Element.Background as Background exposing (..)
import Element.Border as Border
import Element.Font as Font
import Html
import Lamdera
import Palette.Color exposing (smokeColor, white)
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
        , el [ alignRight, alignTop ] <| text "About Me"
        , el [ alignRight, alignTop ] <| text "My Gallery"
        , el [ alignRight, alignTop ] <| text "Contact"
        ]


displayMyWebsite : FrontendModel -> Element FrontendMsg
displayMyWebsite model =
    column [ width fill, height fill, paddingXY 48 24, Background.color smokeColor, Font.color white, spacing 64, scrollbars ]
        [ menu model

        -- , el [ width (px 50), height (px 50) ] (displayMyClock model)
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
            , Font.shadow { offset = ( 2, 4 ), blur = 3, color = rgb255 194 204 255 } -- shadow not Working

            -- , Font.color blue
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


displayMyClock : FrontendModel -> Element FrontendMsg
displayMyClock model =
    let
        hour =
            toFloat (Time.toHour model.zone model.time)

        minute =
            toFloat (Time.toMinute model.zone model.time)

        second =
            toFloat (Time.toSecond model.zone model.time)
    in
    html <|
        Svg.svg
            [ viewBox "0 0 400 400"
            , Svg.width "400"
            , Svg.height "400"
            ]
            [ Svg.circle [ Svg.cx "200", Svg.cy "200", Svg.r "120", Svg.fill "#1293D8" ] []
            , viewHand 6 60 (hour / 12)
            , viewHand 6 90 (minute / 60)
            , viewHand 3 90 (second / 60)
            ]


viewHand : Int -> Float -> Float -> Svg msg
viewHand width length turns =
    let
        t =
            2 * pi * (turns - 0.25)

        x =
            200 + length * cos t

        y =
            200 + length * sin t
    in
    line
        [ Svg.x1 "200"
        , Svg.y1 "200"
        , Svg.x2 (String.fromFloat x)
        , Svg.y2 (String.fromFloat y)
        , Svg.stroke "white"
        , Svg.strokeWidth (String.fromInt width)
        , Svg.strokeLinecap "round"
        ]
        []


pink : Color
pink =
    rgb255 255 192 203


blue : Color
blue =
    rgb255 194 204 255
