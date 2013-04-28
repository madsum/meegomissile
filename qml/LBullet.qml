import QtQuick 1.0

Image {
    id: bullet
    source: "qrc:/gfx/lshot.png"
    smooth: true
    visible: false
    property alias fireAnimLoc: bullAnim.running

    SequentialAnimation
    {
        id: bullAnim

        NumberAnimation
        {
            target: bullet
            property: "y"
            from: bullet.parent.height - 25
            to: 0
            duration: 1000
        }

        ScriptAction { script: bullet.parent.checkLocalCollision() }
    }

    states: [
    State {
            name: "running"
            PropertyChanges { target: bullet; visible: true }
            PropertyChanges { target: bullet; fireAnimLoc: true }
        },
    State {
            name: "stopped"
            PropertyChanges { target: bullet; visible: false }
            PropertyChanges { target: bullet; fireAnimLoc: false }
        }

    ]
}
