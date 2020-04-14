import QtQuick 2.12

Rectangle {
    property int time: 0
    property double bpm: 120.0

    property int window: game_timer.elapsed - time

    id: _barline
    height: 10
    anchors.left: parent.left
    anchors.right: parent.right

    color: "white"

    visible: y > 0

    y: (bpm * hispeed * window * lane_length_multiplier * 2) / parent.height + (parent.height + note_height - judge_position)

    onYChanged: { if (y > parent.height) _barline.destroy() }
}
