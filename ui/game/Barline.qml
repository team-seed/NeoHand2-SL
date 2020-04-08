import QtQuick 2.0
import QtGraphicalEffects 1.0

Rectangle {
    property int time: 0
    property double bpm: 120.0

    property int window: game_customtimer.clock - time

    id: barline
    height: 1
    antialiasing: true
    color: "white"

    visible: y > 0

    y: (bpm * hispeed * window) / parent.height  + (parent.height + judge_height - judge_position)

    onYChanged: {
        if (y > parent.height) barline.destroy()
    }
}
