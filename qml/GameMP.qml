import QtQuick 1.0
import MeeGoMissile 1.0

Item {
    id: gameFrame
    width: parent.width; height: parent.height

    property alias game: game
    property alias engine: engine
    property bool lockFire: false
    property bool leftRepeat: false
    property bool rightRepeat: false

    // create object MissileEngine
    MissileEngine
    {
        id: engine

        //slot to catch Q_SIGNAL RemoteMissileFired from MissileEngine
        onRemoteMissileFired:
        {
            if (isFired)
            {
                gameMP.engine.playSound(3);
                remoteBullet.x = remotePlayer.x + 17.5
                remoteBullet.state="running"
            }
            remotePlayer.x = remote_x
        }

        onRemoteConnectionRequestedBy:
        {
            console.log("Connected peer: "+remoteIP);
            game.reset();
            main.connected = true;
        }

        onConnectionDisconnected:
        {
            console.log("Disconnected.. ");
            game.reset();
            main.connected = false;
            main.state = "quit";
        }
    }

    // Game (Multi Player)
    Item
    {
        //property alias engine: engine
        id: game
        width: parent.width; height: parent.height
        anchors.fill: parent


        //function to reset game settings
        function reset()
        {
            console.log("reset function called")
            score.local = 0; score.remote = 0
            localPlayer.x = 300; remotePlayer.x = 300
        }

        // Collision Detection
        function checkLocalCollision()
        {
            localBullet.state = "stopped"
            lockFire = false
            //console.log("local bullet: " + localBullet.x)

            if(localBullet.x > remotePlayer.x && localBullet.x < remotePlayer.x+35)
            {
                gameMP.engine.playSound(2);
                score.local = score.local + 1

                if(score.local >= scorelim)
                {
                    main.state = "quit"
                }
            }
        }

        function checkRemoteCollision()
        {
            remoteBullet.state = "stopped"
            //console.log("remote bullet: " + remoteBullet.x)

            if(remoteBullet.x > localPlayer.x && remoteBullet.x < localPlayer.x+35)
            {
                gameMP.engine.playSound(2);
                score.remote = score.remote + 1

                if(score.remote >= scorelim)
                {
                    main.state = "quit"
                }
            }
        }

        // Scores
        Score{ id: score; anchors.right: parent.right }

        // Bullets
        LBullet{ id: localBullet  }
        RBullet{ id: remoteBullet }

        // Players
        Image
        {
            width: 50
            id: localPlayer; source: "qrc:/gfx/locplayer.png"
            x: 300; anchors.bottom: parent.bottom
        }

        Image
        {
            width: 50
            id: remotePlayer; source: "qrc:/gfx/remplayer.png"
            x: 300; anchors.top: parent.top
        }

        // Player movement
        Keys.onPressed:
        {

            if (event.key == Qt.Key_Left)
            {
                if(localPlayer.x > 0)
                    localPlayer.x = localPlayer.x - 5

                engine.fireMissile(localPlayer.x,false); //send data to remote player
                leftRepeat = event.isAutoRepeat
                //console.log("local: " + localPlayer.x + " remote: " + remotePlayer.x)
            }

            if (event.key == Qt.Key_Right)
            {
                if(localPlayer.x < 740)
                    localPlayer.x = localPlayer.x + 5
                engine.fireMissile(localPlayer.x,false);
                rightRepeat = event.isAutoRepeat
                //console.log("local: " + localPlayer.x + " remote: " + remotePlayer.x)
            }

            if (event.key == Qt.Key_Space && lockFire == false)
            {
                gameMP.engine.playSound(3);
                engine.fireMissile(localPlayer.x,true);
                localBullet.x = localPlayer.x + 17.5
                localBullet.state = "running"
                lockFire = true
            }
            else if (event.key == Qt.Key_Space)
            {
                if(leftRepeat == true)
                {
                    if(localPlayer.x > 0)
                    {
                        localPlayer.x = localPlayer.x - 10
                        engine.fireMissile(localPlayer.x,false);
                    }
                }
                if(rightRepeat == true)
                {
                    if(localPlayer.x < 740)
                    {
                        localPlayer.x = localPlayer.x + 10
                        engine.fireMissile(localPlayer.x,false);
                    }
                }
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

    } //game (item)


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
