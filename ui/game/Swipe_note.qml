import QtQuick 2.12
import QtGraphicalEffects 1.0

import "game_process_extension.js" as GP

Rectangle {
    property int time: 0
    property double bpm: 120.0
    property int dirc: 0
    property int swipe_height: 1000

    property int window: game_customtimer.clock - time

    property int pos: 0
    property double twist_angle: -lane_angle * (y * 0.4 / (parent.height) + 0.6)
    property int arrow_angle: 0
    property int left_limit: 0
    property int right_limit: 0

    id: swipe_note
    height: judge_height * 2
    antialiasing: true

    visible: y > 0

    y: (bpm * hispeed * window) / parent.height  + (parent.height - judge_position)

    border {
        color: "whitesmoke"
        width: 2
    }

    Rectangle {
        id: shade
        width: parent.width
        height: swipe_height
        opacity: 0.5

        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }

        gradient: Gradient {
            GradientStop { position: 0; color: "transparent" }
            GradientStop { position: 1; color: swipe_note.color }
        }

        Image {
            id: arrow
            source: "qrc:/images/swipe_arrow.png"

            width: (swipe_note.dirc < 2) ? (parent.width * 2) : parent.width
            height: (swipe_note.dirc < 2) ? parent.width : (parent.width * 2)

            anchors.centerIn: parent

            layer.enabled: true
            layer.effect: ColorOverlay {
                color: swipe_note.color
            }

            transform: Rotation {
                origin.x: arrow.width / 2
                origin.y: arrow.height / 2
                axis { x:0; y:0; z:1 }
                angle: arrow_angle
            }
        }

        transform: Rotation {
            origin.x: pos
            origin.y: shade.height
            axis { x:1; y:0; z:0 } angle: twist_angle
        }
    }

    onWindowChanged: {
        if (window > 50) {
            GP.generateHitMark(1, window)
            swipe_note.destroy()
        }
    }

    function check_swipe () {
        var timing = Math.abs(window)
        if (timing > 50) return
        if (gesture_engine.hand_pos < left_limit || gesture_engine.hand_pos >= right_limit) return

        GP.generateHitMark(1, timing)
        swipe_note.destroy()
    }

    Component.onCompleted: {}

    Component.onDestruction: {
        switch (dirc) {
        case 0: swipe_up.disconnect(check_swipe); break;
        case 1: swipe_down.disconnect(check_swipe); break;
        case 2: swipe_left.disconnect(check_swipe); break;
        case 3: swipe_right.disconnect(check_swipe); break;
        }
    }
}
