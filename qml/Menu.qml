import QtQuick 1.0

Item {
    id: menuFrame
    width: parent.width; height: parent.height
    property alias sp: menuGame.isgamesp

    // menu frame
    Rectangle
    {
        width: parent.width / 2; height: parent.height /2;
        radius: 10; smooth: true
        anchors.centerIn: parent
        border { width: 2; color: "steelblue" }

        gradient: Gradient
        {
            GradientStop { position: 0.0; color: "#001c42" }
            GradientStop { position: 1.0; color: "#013298" }
        }

        MouseArea{
             transformOrigin: Item.Center
             anchors.fill: parent
             onClicked: {
                 //block clicks from going under the hider to the game frame
             }
         }

        //Menu
        Item
        {
            id: menu
            width: parent.width; height: parent.height

            Row
            {
                anchors.left: parent.left; anchors.right: parent.right
                anchors.top: parent.top; anchors.bottom: parent.bottom
                anchors.margins: 10; spacing: 10

                // Left side of menu: button column
                Column
                {
                    spacing: 20
                    anchors.verticalCenter: parent.verticalCenter

                    Button
                    {
                        id: bNewGame
                        text: "New Game"

                        MouseArea
                        {
                            anchors.fill: parent
                            onClicked:{ menu.state="showGame" }
                        }
                    }

                    Button
                    {
                        id: bSettings
                        text: "Settings"

                        MouseArea
                        {
                            anchors.fill: parent
                            onClicked:{ menu.state="showSettings" }
                        }
                    }

                    //state of continue button (enabled/disabled) depends on gamePaused boolean in main
                    Button
                    {
                        id: bContinue
                        text: "Continue"
                        state: main.gamePaused ? "enabled" : "disabled"

                        MouseArea
                        {
                            anchors.fill: parent;
                            onClicked:{ main.state="spgame" }
                        }
                    }

                    Button
                    {
                       id: bQuit
                       text: "Quit"

                        MouseArea
                        {
                            anchors.fill: parent
                            onClicked:{ Qt.quit() }
                        }
                    }

                } //Column end

                Image { source: "qrc:/gfx/separator.png" }

                // Right side of menu - contents
                Item{
                    id: menuBoxArea; width: 250; height: 220
                    Image { id: menuDefault; source: "qrc:/gfx/title.png" }
                    MenuSettings { id: menuSettings; opacity: 0 }
                    MenuNewGame { id: menuGame; opacity: 0 }
                }

            }//row end

            states:
            [
                State
                {
                    name: "showGame"
                    PropertyChanges { target: menuGame; opacity: 1 }
                    PropertyChanges { target: menuDefault; opacity: 0 }
                    PropertyChanges { target: menuGame.namefield; focus: true }
                },
                State
                {
                    name: "showSettings"
                    PropertyChanges { target: menuSettings; opacity: 1 }
                    PropertyChanges { target: menuDefault; opacity: 0 }
                },
                State
                {
                    name: "enablePause"
                    PropertyChanges { target: bContinue; state: "enabled" }
                    PropertyChanges { target: menuDefault; opacity: 0 }
                }
            ]

            transitions: Transition
            {
                from: "*"; to: "*"
                reversible: true
                PropertyAnimation { target: menuGame; properties: "opacity"; duration: 400 }
                PropertyAnimation { target: menuSettings; properties: "opacity"; duration: 400 }
                PropertyAnimation { target: menuDefault; properties: "opacity"; duration: 400 }
            }

        } //end of menu
    } //end of menu frame


    states: [
        State {
            name: "hide"
            PropertyChanges{ target: menuFrame; opacity: 0 }
        },
        State {
            name: "show"
            PropertyChanges{ target: menuFrame; opacity: 1 }
        }
    ]

    transitions: Transition {
        reversible: true
        PropertyAnimation { target: menuFrame; properties: "opacity"; duration: 500 }
    }
}
