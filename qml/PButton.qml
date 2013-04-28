import QtQuick 1.0

Item {
    id: container
    width: 90; height: 25
    property string text

    Rectangle {
        id: button
        anchors.fill: parent; radius: 5; border.color: "black"; smooth: true
        gradient: Gradient{
            GradientStop { position: 0.0; color:  "#dad8d8" }
            GradientStop { position: 1.0; color:  "#9e9e9e" }
        }
        Text {
            id: bText
            anchors.centerIn: parent
            text:  container.text
            font.bold: true; font.pixelSize: 12; color: "black"
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
