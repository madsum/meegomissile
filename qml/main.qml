import QtQuick 1.0

Item
{
    id: main
    width: 800
    height: 480

    property bool connected: false
    property bool gameTimer // for singleplayer mode only
    property bool gamePaused
    property int scorelim: 15
    property string name

    // Background
    Image { source: "qrc:/gfx/bg.jpg"; fillMode: "PreserveAspectFit" }

    //SinglePlayer game
    GameSP
    {
        id: gameSP
        focus: false
        enabled: main.state == "spgame" ? "true" : "false"
        visible: main.state == "spgame" ? "true" : "false"
        anchors.fill: parent
    }

    //Multiplayer game
    GameMP
    {
        id: gameMP
        focus: false
        enabled: main.state == "mpgame" ? "true" : "false"
        visible: main.state == "mpgame" ? "true" : "false"
        anchors.fill: parent
    }

    //hider (semi transparent black background)
    Rectangle
    {
        id: hider
        anchors.fill: parent
        color: "black"
        opacity: 0.5

        //mousearea: block interaction with elements below hider
        MouseArea{
            anchors.fill: parent
            hoverEnabled: true
            onEntered: hider.enabled="false"
        }

        states:
        [
            State
            {
                name: "hide"

                PropertyChanges
                {
                    target: hider
                    opacity: 0
                }
            }
        ]
        transitions: Transition
        {
            PropertyAnimation { target: hider; properties: "opacity"; duration: 500 }
        }

    }//hider

    //Main menu
    Menu
    {
        id: menuFrame
    }

    //states for handling game mode / visible windows
    //can probably be implemented in a cleaner way with less code, but this works..
    states:
    [
        State
        {
            name: "spgame"
            PropertyChanges { target: main; gameTimer: "true" }
            PropertyChanges { target: gameSP.game; focus: true }
            PropertyChanges { target: menuFrame; state: "hide" }
            PropertyChanges { target: hider; state: "hide" }
        },
        State
        {
            name: "mpgame"
            PropertyChanges { target: menuFrame; state: "hide" }
            PropertyChanges { target: gameMP.game; focus: true }
            PropertyChanges { target: hider; state: "hide" }
        },
        State
        {
            name: "pause"
            PropertyChanges { target: main; gamePaused: "true" }
            PropertyChanges { target: main; gameTimer: "false" }
            PropertyChanges { target: gameSP.game; focus: false }
            //PropertyChanges { target: menuFrame; state: "show" }
        },
        State
        {
            name: "quit"
            PropertyChanges { target: main; gamePaused: "false" }
            PropertyChanges { target: main; gameTimer: "false" }
            PropertyChanges { target: gameMP.game; focus: false }
            PropertyChanges { target: gameSP.game; focus: false }
            PropertyChanges { target: main; connected: false }

            //PropertyChanges { target: menuFrame; state: "show" }
        }
    ]
}
