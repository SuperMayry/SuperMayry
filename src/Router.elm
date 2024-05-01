module Router exposing (..)


type Route
    = Home
    | AboutMe
    | MyGallery
    | Contact


pathToRoute : String -> Route
pathToRoute path =
    case path of
        "/home" ->
            Home

        "/about" ->
            AboutMe

        "/gallery" ->
            MyGallery

        "/contact" ->
            Contact

        _ ->
            Home


routeToPath : Route -> String
routeToPath route =
    case route of
        Home ->
            "/home"

        AboutMe ->
            "/about"

        MyGallery ->
            "/gallery"

        Contact ->
            "/contact"
