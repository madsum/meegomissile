import QtQuick 1.0

Item
{
    id: container
    width: 15; height: parent.height/2
    anchors.verticalCenter: parent.verticalCenter
    anchors.right: parent.right

    Rectangle
    {
        anchors.fill: parent;
        anchors.margins: 1; smooth: true
        border {width:1; color: "black"}

        gradient: Gradient
        {
            GradientStop { position: 0.0; color:  "#9e9e9e" }
            GradientStop { position: 1.0; color:  "#dad8d8" }
        }

        MouseArea
        {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: container.state= "panelShow"
            onExited: container.state= "panelHide"
        }

        //Panel contents
        Item
        {
            id: panel;
            width: parent.width-1;
            height: parent.height-4
            opacity: 0

          //Populate from top down
          Column
          {
             anchors.horizontalCenter: parent.horizontalCenter
             spacing: 2; anchors.top: parent.top

             Text
             {
                 text: "Menu"; font.bold: true; font.pixelSize: 14; color:"black"
                 anchors.horizontalCenter: parent.horizontalCenter; smooth: true
             }
             Text
             {
                 text: "Player name:"; font.bold: true; font.pixelSize: 10; color:"black"
                 anchors.horizontalCenter: parent.horizontalCenter; smooth: true
             }
             Text
             {
                 text: main.name; font.pixelSize: 10; color:"black"
                 anchors.horizontalCenter: parent.horizontalCenter; smooth: true
             }
          }

          //Populate from bottom up
          Column
          {
              anchors.horizontalCenter: parent.horizontalCenter
              anchors.bottom: parent.bottom
              spacing: 2

              PButton
              {
                  width: 80; height: 25
                  anchors.horizontalCenter: parent.horizontalCenter
                  text: "Pause";
                  //state: menuFrame.sp ? "enabled":"disabled" //disable if game is multiplayer
                  //if main.state == spgame, Pause button state is enabled
                  state: main.state === "spgame" ? "enabled":"disabled"

                  MouseArea
                  {
                      anchors.fill: parent
                      onClicked:{ main.state="pause" }
                  }
              }

              PButton
              {
                  width: 80; height: 25
                  anchors.horizontalCenter: parent.horizontalCenter
                  text: "Quit"

                  MouseArea
                  {
                      anchors.fill: parent
                      onClicked:
                      {
                          main.state="quit"
                          gameMP.game.reset()
                          //main.connected = false
                      }
                  }
              }
          }

        } //panel contents (item)
    } //rectangle

    // states for expanding panel on hover
    states:
    [
        State {
            name: "panelShow"
            PropertyChanges { target: container; width: 90 }
            PropertyChanges { target: panel; opacity: 1 }
        },

        State {
            name: "panelHide"
            PropertyChanges { target: container; width: 15 }
            PropertyChanges { target: panel; opacity: 0 }
        }
    ]

    transitions:

        Transition
        {
            from: "*"; to: "*"; reversible: true
            PropertyAnimation{ target: container; properties: "width"; duration: 100 }
            PropertyAnimation{ target: panel; properties: "opacity"; duration: container.state == "panelShow" ? "200":"50" }
        }
}
