module Evergreen.V2.Types exposing (..)

import Browser
import Browser.Navigation
import Url


type alias FrontendModel =
    { key : Browser.Navigation.Key
    }


type alias BackendModel =
    { message : String
    }


type FrontendMsg
    = UrlClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | NoOpFrontendMsg


type ToBackend
    = NoOpToBackend


type BackendMsg
    = NoOpBackendMsg


type ToFrontend
    = NoOpToFrontend
