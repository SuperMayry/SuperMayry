module Evergreen.V7.Types exposing (..)

import Browser
import Evergreen.V7.Router
import Lamdera
import Time
import Url


type alias FrontendModel =
    { key : Lamdera.Key
    , zone : Time.Zone
    , time : Time.Posix
    , route : Evergreen.V7.Router.Route
    , url : Url.Url
    }


type alias BackendModel =
    { message : String
    }


type FrontendMsg
    = UrlClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | NoOpFrontendMsg
    | Tick Time.Posix
    | AdjustTimeZone Time.Zone


type ToBackend
    = NoOpToBackend


type BackendMsg
    = NoOpBackendMsg


type ToFrontend
    = NoOpToFrontend
