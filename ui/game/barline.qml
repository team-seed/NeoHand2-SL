import QtQuick 2.12

Rectangle {
    property int time: 0
    property double bpm: 120.0

    property int window: 0

    id: barline
    height: 2
    anchors.left: parent.left
    anchors.right: parent.right

    antialiasing: true
    color: "white"

    visible: y > 0

    y: (bpm * hispeed * window) / parent.height + (parent.height + note_height - judge_position)

    onYChanged: { if (y > parent.height) barline.destroy() }
}
