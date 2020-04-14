import QtQuick 2.12

Item {
    property int time: 0
    property double bpm: 120.0
    property int window: game_timer.elapsed - time

    // gesture serves no purpose in this version
    // property int gesture: 0

    property int left_pos: 0
    property int right_pos: 0

    id: _click

    height: note_height

    anchors {
        left: parent.left
        right: parent.right
        leftMargin: play_area.node_width * left_pos
        rightMargin: play_area.node_width * (16 - right_pos)
    }


    antialiasing: true
    visible: y > 0

    Rectangle {
        anchors.fill: parent
        color: "royalblue"
        opacity: 0.7
        radius: height / 15
    }

    y: (bpm * hispeed * window * lane_length_multiplier * speed_base_multiplier) / parent.height + (parent.height - judge_position)

    onYChanged: { if (y > parent.height) _click.destroy() }
}
