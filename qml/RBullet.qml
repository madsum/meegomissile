import QtQuick 1.0

Image {
    id: bullet
    source: "qrc:/gfx/rshot.png"
    smooth: true
    visible: false
    property alias fireAnimRem: bullAnim.running

    SequentialAnimation
    {
        id: bullAnim

        NumberAnimation
        {
            target: bullet
            property: "y"
            from: 25
            to: bullet.parent.height - 25
            duration: 1000
        }

        ScriptAction { script: bullet.parent.checkRemoteCollision() }
    }

    states: [
    State {
            name: "running"
            PropertyChanges { target: bullet; visible: true }
            PropertyChanges { target: bullet; fireAnimRem: true }
        },
    State {
            name: "stopped"
            PropertyChanges { target: bullet; visible: false }
            PropertyChanges { target: bullet; fireAnimRem: false }
        }

    ]
}
