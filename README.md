- 👋 Hi, I’m @SuperMayry 19 
- 👀 I’m interested in BacketBall as I've been a professional BasketBall player for a long long time.
- 🌱 I’m currently learning elm/lamdera

Let's gather here all the shortcuts I learn:

1) in vscode : cmd + p -> Open another file
2) on website, on any part : ctrl + option + x -> Go to the function
3) in vscode, on a function : press cmd + click -> Go to the definition of the function


- 💞️ I’m looking to collaborate on ...
- 📫 How to reach me ...
- 😄 Pronouns: ...
- ⚡ Fun fact: ...

<!---
SuperMayry/SuperMayry is a ✨ special ✨ repository because its `README.md` (this file) appears on your GitHub profile.
You can click the Preview link to take a look at your changes.
--->



<!-- displayMyClock : FrontendModel -> Element FrontendMsg
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
        [] -->