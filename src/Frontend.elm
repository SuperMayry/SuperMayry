module Frontend exposing (..)

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav
import Element exposing (..)
import Element.Background as Background exposing (..)
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Element.Input as Input exposing (email)
import Html
import Lamdera
import Palette.Color exposing (..)
import Router exposing (Route(..))
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
init url key =
    ( { key = key
      , zone = Time.utc
      , time = Time.millisToPosix 0
      , route = Router.pathToRoute url.path
      , url = url
      , userName = ""
      , email = ""
      , comment = ""
      }
    , Cmd.batch
        [ Task.perform AdjustTimeZone Time.here
        , Task.perform Tick Time.now -- เพิ่มเติมเวลาประเทศไทย
        ]
    )


update : FrontendMsg -> FrontendModel -> ( FrontendModel, Cmd FrontendMsg )
update msg model =
    case msg of
        NoOpFrontendMsg ->
            ( model, Cmd.none )

        UrlClicked urlRequest ->
            case urlRequest of
                Internal url ->
                    ( { model | route = Router.pathToRoute url.path }
                    , Nav.pushUrl model.key (Url.toString url)
                    )

                External url ->
                    ( model
                    , Nav.load url
                    )

        UrlChanged _ ->
            ( model, Cmd.none )

        Tick newTime ->
            ( { model | time = newTime }
            , Cmd.none
            )

        AdjustTimeZone newZone ->
            ( { model | zone = newZone }
            , Cmd.none
            )

        ChangeUsername newName ->
            ( { model | userName = newName }
            , Cmd.none
            )

        ChangEmail email ->
            ( { model | email = email }
            , Cmd.none
            )

        Chengcomment comment ->
            ( { model | comment = comment }
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
    { title = "SuperMayry 19 "
    , body =
        [ layout [ width fill, height fill ] <| displayMyWebsite model ]
    }


displayHeader :
    FrontendModel
    -> Element FrontendMsg --- Home
displayHeader ({ url } as model) =
    row
        [ width fill
        , padding 20
        , spacing 64
        ]
        [ displaySimpleClock model
        , paragraph
            [ width fill
            , Font.center
            , Font.size 38
            , Font.italic
            , Font.bold
            , Font.letterSpacing 4
            , alignTop
            , moveUp 9
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
                (text "Mayry 19 ")
            ]
        , el [ alignRight, alignTop, pointer, Events.onClick (UrlClicked <| Internal { url | path = Router.routeToPath Home }) ] <| text "Home"
        , el [ alignRight, alignTop, pointer, Events.onClick (UrlClicked <| Internal { url | path = Router.routeToPath AboutMe }) ] <| text "About Me"
        , el [ alignRight, alignTop, pointer, Events.onClick (UrlClicked <| Internal { url | path = Router.routeToPath MyGallery }) ] <| text "My Gallery"
        , el [ alignRight, alignTop, pointer, Events.onClick (UrlClicked <| Internal { url | path = Router.routeToPath Contact }) ] <| text "Contact"
        ]


displayMyWebsite : FrontendModel -> Element FrontendMsg
displayMyWebsite model =
    column [ width fill, height fill, paddingXY 48 0, Background.color smokeColor, Font.color white, spacing 64, scrollbars ]
        [ displayHeader model
        , displayRoute model
        ]


displayRoute : FrontendModel -> Element FrontendMsg
displayRoute model =
    case model.route of
        Home ->
            displayHomePage model

        AboutMe ->
            displayAboutPage model

        MyGallery ->
            displayMyGalleryPage model

        Contact ->
            displayContactPage model


displayHomePage : FrontendModel -> Element FrontendMsg
displayHomePage model =
    column [ width fill, spacing 16 ]
        [ column
            [ centerX
            , spacing 8
            , Font.shadow { offset = ( 2, 4 ), blur = 3, color = rgb255 194 204 255 }
            ]
            []
        , Element.image [ width (px 700), centerX, Border.color white ]
            { src = "/homemfixed.png", description = "homemay" }
        ]


displayAboutPage : FrontendModel -> Element FrontendMsg
displayAboutPage model =
    -- About me
    column [ width fill, spacing 16, centerX, centerY ]
        [ Element.image [ width (px 1000), height (px 450), centerX, centerY ]
            { src = "/aboutmemay.png", description = "abotmayry" }
        ]


displayMyGalleryPage : FrontendModel -> Element FrontendMsg
displayMyGalleryPage model =
    -- my GalleryPage
    text "displayMyGalleryPage"


displayContactPage : FrontendModel -> Element FrontendMsg
displayContactPage model =
    column
        [ width fill
        , spacing 10
        , centerX
        , centerY
        , Font.color black
        ]
        [ Input.username []
            { onChange = ChangeUsername
            , text = model.userName
            , placeholder = Nothing
            , label = Input.labelLeft [] (text "Name")
            }
        , Input.email []
            { onChange = ChangEmail
            , text = model.email
            , placeholder = Nothing
            , label = Input.labelLeft [] (text "Email")
            }
        , Input.multiline []
            { onChange = Chengcomment
            , text = model.comment
            , placeholder = Nothing
            , label = Input.labelAbove [] (text "comment")
            , spellcheck = True
            }
        ]


type alias Placeholder msg =
    { placeholderText : String
    , placeholderMsg : msg
    }


type alias Label msg =
    { labelText : String
    , labelMsg : msg
    }



-- usernameInput : List (Attribute msg) -> { onChange : String -> msg, text : String, placeholder : Maybe (Placeholder msg), label : Label msg } -> Element msg
-- usernameInput attrs { onChange, text, placeholder, label } =
--     column
--         ([ width Fill, spacing 10, centerX, centerY ] ++ attrs)
--         [ labelElement label
--         , Input.text
--             [ Input.value text
--             , Input.onChange (\newText -> onChange newText)
--             ]
--         , case placeholder of
--             Just ph ->
--                 Input.text
--                     [ Input.placeholder ph.placeholderText
--                     , Input.onBlur (\_ -> ph.placeholderMsg)
--                     ]
--             Nothing ->
--                 Element.none
--         ]


labelElement : Label msg -> Element msg
labelElement label =
    Element.text label.labelText


displaySimpleClock : FrontendModel -> Element FrontendMsg
displaySimpleClock model =
    let
        formatTimeValue : Int -> String
        formatTimeValue value =
            if value < 10 then
                "0" ++ String.fromInt value

            else
                String.fromInt value

        hours =
            formatTimeValue (Time.toHour model.zone model.time)

        minutes =
            formatTimeValue (Time.toMinute model.zone model.time)

        seconds =
            formatTimeValue (Time.toSecond model.zone model.time)
    in
    el [ Font.size 32, alignTop ] (text (hours ++ ":" ++ minutes ++ ":" ++ seconds))
