import QtQuick 1.0

Item {
    id: menugame
    width: parent.width; height: parent.height
    property bool isgamesp: true
    property alias namefield: name

    Column
    {
        spacing: 12
        anchors.horizontalCenter: parent.horizontalCenter

        // Header text + name field
        Row
        {
            spacing: 10; anchors.horizontalCenter: parent.horizontalCenter
            Text { text: "New Game"; color: "white"; font.pixelSize: 16; smooth: true; font.bold: true  }
        }

        Row
        {
            spacing: 5; anchors.horizontalCenter: parent.horizontalCenter

            Text
            {
                text: "Name:"
                color: "white"
                font.pixelSize: 14
                smooth: true
                anchors.verticalCenter: name.verticalCenter
            }

            LineEdit{ id: name; width: 200; text: "name"; focus: true }
        }

        // Buttons (Start game / cancel)
        Row
        {
            spacing: 10; anchors.horizontalCenter: parent.horizontalCenter

            Button
            {
                id: startbutton; text: "Start";

                MouseArea
                {
                    anchors.fill: parent;
                    onClicked:
                    {
                        gameSP.game.reset()
                        main.state = isgamesp ? "spgame" : "mpgame"
                        main.name = name.text
                    }
                }
            }

            Button
            {
                text: "Cancel";

                MouseArea
                {
                    anchors.fill: parent;
                    onClicked: { menu.state="" } //go to default state
                }
            }

            //states to disable start button if name field is empty
            states:
            [
                State
                {
                    name: "empty"; when:  name.text === ""
                    PropertyChanges {target: startbutton; state: "disabled"}
                },
                State
                {
                    name: "notempty"; when:  name.text !== ""
                    PropertyChanges {target: startbutton; state: "enabled"}
                }
            ]
        }


        // Game mode checkboxes (Single/Multi)
        Row
        {
            spacing: 10; anchors.horizontalCenter: parent.horizontalCenter
            Text { text: "Game Mode"; color: "white"; font.pixelSize: 16; smooth: true; font.bold: true  }
        }

        Row
        {
            spacing: 10;
            CheckBox
            {
                id: spcheck; checked:true

                MouseArea
                {
                    anchors.fill: parent;
                    onClicked: { menugame.state="singleplayer" }
                }
            }

            Text { text: "Single Player"; color: "white"; font.pixelSize: 14; smooth: true;
                    anchors.verticalCenter: spcheck.verticalCenter}
        }

        Row
        {
            spacing: 10;
            CheckBox
            {
                id: mpcheck;

                MouseArea
                {
                    anchors.fill: parent;
                    onClicked: { menugame.state="multiplayer" }
                }
            }

            Text { id: multiplayer; text: "Multi Player"; color: "white"; font.pixelSize: 14; smooth: true
                    anchors.verticalCenter: mpcheck.verticalCenter}

            Text { id: status; text: ""; color: "#FF0040"; font.pixelSize: 14; smooth: true
                    anchors.verticalCenter: mpcheck.verticalCenter}

            states:
            [
                State
                {
                    name: "connected"; when:  main.connected === true
                    PropertyChanges {target: mpcheck; enabled: true}
                    PropertyChanges {target: mpcheck; opacity: 1}
                    PropertyChanges {target: multiplayer; opacity: 1}
                    PropertyChanges {target: status; text: "Connected!"}
                    PropertyChanges {target: status; color: "#00FF00"}

                    PropertyChanges { target: mpcheck; checked: "true" }
                    PropertyChanges { target: spcheck; checked: "false" }
                    PropertyChanges { target: menugame; isgamesp: "false" }
                },
                State
                {
                    name: "notconnected"; when:  main.connected === false
                    PropertyChanges {target: mpcheck; enabled: false}
                    PropertyChanges {target: mpcheck; opacity: 0.5}
                    PropertyChanges {target: multiplayer; opacity: 0.5}
                    PropertyChanges {target: status; text: "Not connected!"}

                    PropertyChanges { target: spcheck; checked: "true" }
                    PropertyChanges { target: mpcheck; checked: "false" }
                    PropertyChanges { target: menugame; isgamesp: "true" }
                }
            ]
        }

     } // column end

    states: [
        State {
            name: "singleplayer"
            PropertyChanges { target: spcheck; checked: "true" }
            PropertyChanges { target: mpcheck; checked: "false" }
            PropertyChanges { target: menugame; isgamesp: "true" }
        },
        State {
            name: "multiplayer"
            PropertyChanges { target: mpcheck; checked: "true" }
            PropertyChanges { target: spcheck; checked: "false" }
            PropertyChanges { target: menugame; isgamesp: "false" }
        }
    ]
}
