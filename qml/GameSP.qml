import QtQuick 1.0

Item {
    id: gameFrame
    width: parent.width; height: parent.height
    property alias game: game

    property bool lockFire: false
    property bool ailockFire: false
    property int interv: 300
    property int lvelo: 80
    property int rvelo: 20

    property bool leftRepeat: false
    property bool rightRepeat: false

    // Game (Single Player)
    Item {
        id: game; opacity: 0;
        width: parent.width; height: parent.height
        anchors.fill: parent

        //function to reset game settings
        function reset(){
            console.log("reset function called")
            score.local = 0; score.remote = 0
            lvelo = -1; rvelo = -1; //disable velocity to move players back instantly
            localPlayer.x = 150; aiPlayer.x = 450
            lvelo = 80; rvelo = 20;
        }

        // Collision Detection
        function checkLocalCollision()
        {
            localBullet.state = "stopped"
            lockFire = false
            //console.log("local bullet: " + localBullet.x)

            if( localBullet.x > aiPlayer.x-5 && localBullet.x < aiPlayer.x+35 )
            {
                gameMP.engine.playSound(2);
                score.local = score.local + 1

                if(score.local >= scorelim)
                {
                    main.state = "quit"
                }
            }
        }

        //not really remote, using it for AI
        function checkRemoteCollision()
        {
            aiBullet.state = "stopped"
            ailockFire = false
            //console.log("remote bullet: " + aiBullet.x)

            if(aiBullet.x > localPlayer.x && aiBullet.x < localPlayer.x+35)
            {
                gameMP.engine.playSound(2);
                score.remote = score.remote + 1

                if(score.remote >= scorelim)
                {
                    main.state = "quit"
                }
            }
        }

        // Show scores
        Score{ id: score; anchors.right: parent.right }

        // Bullet
        LBullet{ id: localBullet }
        RBullet{ id: aiBullet }

        // Player
        Image
        {
            width: 50
            id: localPlayer; source: "qrc:/gfx/locplayer.png"
            x: 150; anchors.bottom: parent.bottom
            Behavior on x
                {
                    SmoothedAnimation{ velocity: lvelo }
                }
        }

        // enemy + AI logic
        /* implement AI bullet logic */
        Image{
            width: 41
            id: aiPlayer; source: "qrc:/gfx/aiplayer.png"
            x: 450; anchors.top: parent.top

            Timer{
                id: timer
                interval: interv; running: main.gameTimer ? "true":"false"; repeat: true
                onTriggered:
                {   // enemy movement
                    if(aiPlayer.x > localPlayer.x){ aiPlayer.x = aiPlayer.x - 10 }
                    if(aiPlayer.x < localPlayer.x){ aiPlayer.x = aiPlayer.x + 10 }
                    if(aiPlayer.x < localPlayer.x+20 && aiPlayer.x > localPlayer.x-20 && ailockFire == false)
                       {
                        gameMP.engine.playSound(3);
                        ailockFire = true
                        aiBullet.x = aiPlayer.x + 11
                        aiBullet.visible = true
                        aiBullet.state = "running"
                       }
                }
            }

            Behavior on x { SmoothedAnimation { velocity: rvelo } }
        }

        // Player movement
        Keys.onPressed: {

            if (event.key == Qt.Key_Left){
                if(localPlayer.x > 0)
                localPlayer.x = localPlayer.x - 10
                event.accepted = true
                leftRepeat = event.isAutoRepeat
            }

            if (event.key == Qt.Key_Right){
                if(localPlayer.x < 740)
                localPlayer.x = localPlayer.x + 10
                event.accepted = true
                rightRepeat = event.isAutoRepeat
            }

            if (event.key == Qt.Key_Space && lockFire == false)
            {
                    gameMP.engine.playSound(3);
                    localBullet.x = localPlayer.x + 17.5
                    localBullet.visible = true
                    localBullet.state = "running"
                    lockFire = true
                    event.accepted = true
            }
                else if (event.key == Qt.Key_Space)
                {
                    if(leftRepeat == true)
                        if(localPlayer.x > 0)
                        localPlayer.x = localPlayer.x - 10
                    if(rightRepeat == true)
                        if(localPlayer.x < 740)
                        localPlayer.x = localPlayer.x + 10

                    event.accepted = true
                }
        }
        Keys.onReleased:
        {
            if(event.key == Qt.Key_Left)
                leftRepeat = false
                event.accepted = true

            if(event.key == Qt.Key_Right)
                rightRepeat = false
                event.accepted = true
        }

        // for calling reset function
        states: [
            State {
                name: "reset"
                StateChangeScript {
                    name: "resetScript"
                    script: reset()
                }
            }
        ]

    }


    // Hover Panel (ingame menu)
    GamePanel{ id: gamePanel; opacity: 0 }

    states: [
        State {
            name: "show"
            when: menuFrame.state == "hide"
            PropertyChanges { target: game; opacity: 1 }
            PropertyChanges { target: gamePanel; opacity: 1 }
        },
        State {
            name: "hide"
            when: menuFrame.state == "show"
            PropertyChanges { target: game; opacity: 0 }
            PropertyChanges { target: gamePanel; opacity: 0 }
        }
    ]
    transitions: [
        Transition {
            from: "show"; to: "hide"
            reversible: true
            PropertyAnimation{ target: game; properties: "opacity"; duration: 400 }
            PropertyAnimation{ target: gamePanel; properties: "opacity"; duration: 400 }
        }
    ]
}
