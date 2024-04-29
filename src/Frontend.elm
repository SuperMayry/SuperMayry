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
    ( { key = key }
    , Cmd.none
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


updateFromBackend : ToFrontend -> FrontendModel -> ( FrontendModel, Cmd FrontendMsg )
updateFromBackend msg model =
    case msg of
        NoOpToFrontend ->
            ( model, Cmd.none )


subscriptions : FrontendModel -> Sub FrontendMsg
subscriptions _ =
    Sub.none


view : FrontendModel -> Browser.Document FrontendMsg
view model =
    { title = "SuperMayry 19 🏀"
    , body =
        [ layout [ width fill, height fill ] <| displayMyWebsite model
        ]
    }


menu : Element msg
menu =
    row
        [ width fill
        , padding 20
        , spacing 20
        ]
        [ el [ alignRight ] <| text "About Me"
        , el [ alignRight ] <| text "My Gallery"
        , el [ alignRight ] <| text "Contect"
        ]


displayMyWebsite : FrontendModel -> Element FrontendMsg
displayMyWebsite _ =
    column [ width fill, height fill, paddingXY 48 24, Background.color smokeColor, Font.color white, spacing 64, scrollbars ]
        [ menu -- call Fucntion Menu
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
            ]
            [ el [ centerX ] (text "Welcome to my new website!")
            , text "I hope to learn to improve this website first 🏀 LETS GOOO 😘"
            ]
        , Element.image [ width (px 400), centerX ]
            { src = "https://scontent.fvte2-2.fna.fbcdn.net/v/t1.18169-9/46447_10200235267985360_400189615_n.jpg?_nc_cat=108&ccb=1-7&_nc_sid=5f2048&_nc_eui2=AeHJZw9IPbK9Brz2SdlTLokD1ykEY9zMxsTXKQRj3MzGxIjUlK5KDJbo23fll31-vjo&_nc_ohc=B6Xhb1fx6zcAb7PnvAp&_nc_ht=scontent.fvte2-2.fna&oh=00_AfCrVAOmGY9hLMTh2p35KBuUlrAl-_8dqXQf_pYZ8eUTPA&oe=664C10A5"
            , description = "Basketballmayry"
            }
        ]


pink : Color
pink =
    rgb255 255 192 203


blue : Color
blue =
    rgb255 194 204 255



-- rgb 1 0.8 0.9
-- textWithColor :String -> String -> Html msg
-- textWithColor content color =
--     div [ style [("color", color)] ]
--         [ text content ]
-- main : Html msg
-- main =
--     div []
--         [ textWithColor "Super" "red"
--         , textWithColor "Mayry 19 🏀 " "blue"
--         ]
--         , column
--             [ centerX
--             , spacing 8
--             ]
--             [ el [ centerX ] (text "Welcome to my new website!")
--             , text "I hope to learn to improve this website first 🏀 LETS GOOO 😘"
--             ]
--         , Element.image [ width (px 400), centerX ]
--             { src = "https://scontent.fvte2-2.fna.fbcdn.net/v/t1.18169-9/46447_10200235267985360_400189615_n.jpg?_nc_cat=108&ccb=1-7&_nc_sid=5f2048&_nc_eui2=AeHJZw9IPbK9Brz2SdlTLokD1ykEY9zMxsTXKQRj3MzGxIjUlK5KDJbo23fll31-vjo&_nc_ohc=B6Xhb1fx6zcAb7PnvAp&_nc_ht=scontent.fvte2-2.fna&oh=00_AfCrVAOmGY9hLMTh2p35KBuUlrAl-_8dqXQf_pYZ8eUTPA&oe=664C10A5"
--             , description = "Basketballmayry"
--             }
--         ]
-- 1) YOU NEED TO DO THE COMMANDS BELOW BUT YOU NEED TO REPLACE `elm` by `lamdera`
-- Show an analog clock for your time zone.
--
-- Dependencies:
--   elm install elm/svg
--   elm install elm/time
--
-- For a simpler version, check out:
--   https://elm-lang.org/examples/time
--
-- 2) add the missing imports on the top of this file
-- import Html exposing (Html)
-- import Svg exposing (..)
-- import Svg.Attributes exposing (..)
-- import Task
-- import Time
-- -- MODEL
-- 3) add this to your FrontendModel
-- type alias Model =
--   { zone : Time.Zone
--   , time : Time.Posix
--   }
-- 4) add the zone and the time in the init
-- 5) add also the 2 Task.perform
-- init : () -> (Model, Cmd Msg)
-- init _ =
--   ( { zone = Time.utc, time = Time.millisToPosix 0 }
--   , Cmd.batch
--       [ Task.perform AdjustTimeZone Time.here
--       , Task.perform Tick Time.now
--       ]
--   )
-- -- UPDATE
-- 6) add Tick and AdjustTimeZone Msgs into your FrontendMsg
-- type Msg
--   = Tick Time.Posix
--   | AdjustTimeZone Time.Zone
-- 7) add into your update these 2 cases :  Tick newTime -> and AdjustTimeZone newZone ->
-- update : Msg -> Model -> (Model, Cmd Msg)
-- update msg model =
--   case msg of
--     Tick newTime ->
--       ( { model | time = newTime }
--       , Cmd.none
--       )
--     AdjustTimeZone newZone ->
--       ( { model | zone = newZone }
--       , Cmd.none
--       )
-- -- SUBSCRIPTIONS
-- 8) For an horloge, you need to subscribe to time, to do that you need to do this: Time.every 1000 Tick : I ALREADY DID THAT FOR YOU!!! I HOPE YOU READ ME !!!!! :D
-- subscriptions : Model -> Sub Msg
-- subscriptions model =
--   Time.every 1000 Tick
-- -- VIEW
-- 9) ask me now yo add that to your view
-- view : Model -> Html Msg
-- view model =
--   let
--     hour   = toFloat (Time.toHour   model.zone model.time)
--     minute = toFloat (Time.toMinute model.zone model.time)
--     second = toFloat (Time.toSecond model.zone model.time)
--   in
--   svg
--     [ viewBox "0 0 400 400"
--     , width "400"
--     , height "400"
--     ]
--     [ circle [ cx "200", cy "200", r "120", fill "#1293D8" ] []
--     , viewHand 6 60 (hour/12)
--     , viewHand 6 90 (minute/60)
--     , viewHand 3 90 (second/60)
--     ]
-- viewHand : Int -> Float -> Float -> Svg msg
-- viewHand width length turns =
--   let
--     t = 2 * pi * (turns - 0.25)
--     x = 200 + length * cos t
--     y = 200 + length * sin t
--   in
--   line
--     [ x1 "200"
--     , y1 "200"
--     , x2 (String.fromFloat x)
--     , y2 (String.fromFloat y)
--     , stroke "white"
--     , strokeWidth (String.fromInt width)
--     , strokeLinecap "round"
--     ]
--     []
