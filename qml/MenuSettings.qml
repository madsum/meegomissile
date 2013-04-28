import QtQuick 1.0

Item {
    id: menuboxsettings
    width: parent.width; height: parent.height

    signal connectButtonClicked(string ip, string port);
    property alias ip: ip
    property alias port: port

    Column {
        spacing: 15
        anchors.horizontalCenter: parent.horizontalCenter

        //Header text
        Row
        {
            spacing: 10; anchors.horizontalCenter: parent.horizontalCenter
            Text { text: "Settings"; color: "white"; font.pixelSize: 16; smooth: true; font.bold: true  }
        }

        Column
        {
            spacing: 5; y: 2
            anchors.horizontalCenter: parent.horizontalCenter

            //IP
            Row
            {
                spacing: 5;
                anchors.left: parent.left

                Text
                {
                  text: "IP:"; color: "white"; font.pixelSize: 14; smooth: true; font.bold: true
                  anchors.verticalCenter: ip.verticalCenter
                }

                LineEdit{ id: ip; width: 180; text: "127.0.0.1" }
            }

            //PORT
            Row
            {
                spacing: 5;
                anchors.left: parent.left

                Text
                {
                  text: "Port:"; color: "white"; font.pixelSize: 14; smooth: true; font.bold: true
                  anchors.verticalCenter: port.verticalCenter
                }

                LineEdit{ id: port; width: 160; text: "2000" }
            }

            //BUTTONS
            Row
            {
                spacing: 5;
                anchors.horizontalCenter: parent.horizontalCenter

                Button
                {
                    id: connect
                    text: "Connect"
                    width: 100; height: 25

                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked:
                        {
                            connectButtonClicked(ip.text,port.text)
                            main.connected = true
                        }
                    }
                }
                Button
                {
                    id: disconnect
                    text: "Disconnect"
                    width: 100; height: 25

                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked:
                        {
                            gameMP.engine.disconnect();
                            main.connected = false
                        }
                    }
                }

            }

            Image { source: "qrc:/gfx/separator2.png" }

            //more options
            Column
            {
                spacing: 5; y: 10
                anchors.horizontalCenter: parent.horizontalCenter

                Row
                {
                    spacing: 10; anchors.horizontalCenter: parent.horizontalCenter
                    Text { text: "Other options"; color: "white"; font.pixelSize: 16; smooth: true; font.bold: true  }
                }

                Row
                {
                    spacing: 5;
                    anchors.left: parent.left

                    Text
                    {
                      text: "Score limit: ";
                      color: "white";
                      font.pixelSize: 14;
                      smooth: true;
                      font.bold: true;
                      anchors.verticalCenter: sc.verticalCenter
                    }

                    LineEdit
                    {
                        id: sc; width: 50; text: "15";
                        enabled: main.gamePaused ? "false":"true"
                    }

                    Text {
                        id: status
                        text: main.scorelim
                        color: "#FF0040"
                        font.pixelSize: 14
                        font.bold: true
                        smooth: true
                    }
                }

                Text {
                    id: note
                    text: "quit the current game to edit the score limit"
                    color: "white"
                    font.pixelSize: 10
                    font.bold: true
                    smooth: true
                    visible: main.gamePaused ? "true":"false"
                }
            }
            //buttons
            Row
            {
                spacing: 5; y: 100
                anchors.horizontalCenter: parent.horizontalCenter

                Button
                {
                    id: apply
                    text: "Apply"
                    width: 100; height: 25
                    state: main.gamePaused ? "disabled":"enabled"

                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked:
                        {
                            main.scorelim = sc.text
                        }
                    }
                }

                Button
                {
                    id: cancel
                    text: "Cancel"
                    width: 100; height: 25

                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked:
                        {
                            menu.state=""
                        }
                    }
                }

            }

            //main.scorelim

            //button row
        } //column

    }
    onConnectButtonClicked:
    {
        gameMP.engine.ConnectToRemotePlayer(ip,port);
        console.log("connected to: " + ip + ":" + port);
    }
}
