import QtQuick 2.12
import QtGraphicalEffects 1.0
import "game_process_extension.js" as GP

Rectangle {
    property int time: 0
    property double bpm: 120.0
    property int window: game_customtimer.clock - time
    property int gesture: 0
    property int left_limit: 0
    property int right_limit: 0

    id: click
    height: judge_height * 2
    antialiasing: true

    visible: y > 0

    y: (bpm * hispeed * window) / parent.height  + (parent.height - judge_position)

    border {
        color: "whitesmoke"
        width: 2
    }

    onWindowChanged: {
        if (window > 120) {
            GP.generateHitMark(0, window)
            click.destroy()
        }
    }

    function check_hit () {
        var timing = Math.abs(window)
        if (timing > 120) return
        if (gesture_engine.hand_pos < left_limit || gesture_engine.hand_pos >= right_limit) return

        GP.generateHitMark(0, timing)
        click.destroy()
    }

    Component.onCompleted: {
        hit.connect(check_hit)
    }

    Component.onDestruction: {
        hit.disconnect(check_hit)
    }
}
