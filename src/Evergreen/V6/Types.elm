module Evergreen.V6.Types exposing (..)

import Browser
import Lamdera
import Time
import Url


type alias FrontendModel =
    { key : Lamdera.Key
    , zone : Time.Zone
    , time : Time.Posix
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
