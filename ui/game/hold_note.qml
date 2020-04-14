import QtQuick 2.12
import QtQuick.Shapes 1.12

Item {
    property int start_time: 0
    property int end_time: 0
    property double bpm: 120.0
    property int window: game_timer.elapsed - start_time
    property int duration: end_time - start_time

    property string shape_color: "green"

    property var start_pos: [0, 0]
    property var end_pos: [0, 0]

    property int right_spacing: 0
    property int left_spacing: 0

    // gesture serves no purpose in this version
    //property int gesture: 0

    id: _hold

    height: (bpm * hispeed * duration * lane_length_multiplier * speed_base_multiplier) / parent.height

    anchors {
        left: parent.left
        right: parent.right
        leftMargin: play_area.node_width * (Math.min(start_pos[0], end_pos[0]) + left_spacing)
        rightMargin: play_area.node_width * ((16 - Math.max(start_pos[1], end_pos[1])) + right_spacing)
    }

    antialiasing: true
    //visible: y + height > 0
    opacity: 0.75

    y: (bpm * hispeed * (window - duration) * lane_length_multiplier * speed_base_multiplier) / parent.height + (parent.height - judge_position + note_height)

    Shape {
        ShapePath {
            strokeColor: "transparent"
            strokeWidth: 5
            fillColor: shape_color

            startX: play_area.node_width * end_pos[0]; startY: 0
            PathLine { x: play_area.node_width * end_pos[1]; y: 0 }
            PathLine { x: play_area.node_width * start_pos[1]; y: height }
            PathLine { x: play_area.node_width * start_pos[0]; y: height }
            PathLine { x: play_area.node_width * end_pos[0]; y: 0 }
        }
    }

    Rectangle {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: play_area.node_width * start_pos[0]

        height: 20
        width: play_area.node_width * (start_pos[1] - start_pos[0])

        color: "lightgreen"
    }

    onWindowChanged: { if (window - duration > 500) _hold.destroy() }
}
