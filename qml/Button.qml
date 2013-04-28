import QtQuick 1.0

Item
{
    id: container
    width: 100; height: 40
    property string text

    Rectangle
    {
        id: button
        anchors.fill: parent; radius: 15; border.color: "black"; smooth: true

        gradient:
          Gradient{
              GradientStop { position: 0.0; color:  "#001c42" }
              GradientStop { position: 1.0; color:  "#013298" }
          }

        Text {
            id: bText
            anchors.centerIn: parent
            text:  container.text
            font.bold: true; font.pixelSize: 12; color: "white"
        }
    }


    states: [
    State {
            name: "disabled"
            PropertyChanges { target: container; enabled: false; }
            PropertyChanges { target: button; opacity: 0.5}
        },
        State {
            name: "enabled"
            PropertyChanges { target: container; enabled: true; }
            PropertyChanges { target: button; opacity: 1}
        }
    ]
    Transition {
        from: "enabled"; to: "disabled"
        reversible: true
        PropertyAnimation{
            target: button; properties: "opacity"; duration: 500
        }
    }
}
