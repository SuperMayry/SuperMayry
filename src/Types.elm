module Types exposing (..)

import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Dict exposing (keys)
import Lamdera exposing (Key)
import Router exposing (Route)
import Time
import Url exposing (Url)


type alias FrontendModel =
    { key : Key
    , zone : Time.Zone -- เก็บข้อมูลเขตเวลาของผู้ใช้
    , time : Time.Posix -- เก็บเวลาปัจจุบัน
    , route : Route
    , url : Url
    }


type alias BackendModel =
    { message : String
    }


type FrontendMsg
    = UrlClicked UrlRequest
    | UrlChanged Url
    | NoOpFrontendMsg
    | Tick Time.Posix
    | AdjustTimeZone Time.Zone


type ToBackend
    = NoOpToBackend


type BackendMsg
    = NoOpBackendMsg


type ToFrontend
    = NoOpToFrontend
