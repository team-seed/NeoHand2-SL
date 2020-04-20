import QtQuick 2.12
import QtQuick.Shapes 1.12
//import QtGraphicalEffects 1.0

Item {
    property int time: 0
    property int end_time: 0
    property double bpm: 120.0
    property int window: game_timer.elapsed - time
    property int duration: end_time - time

    property string shape_color: gesture == 0 ? "orange" : "deepskyblue"
    property string line_color: gesture == 0 ? "yellow" : "palegreen"

    property var start_pos: [0, 0]
    property var end_pos: [0, 0]

    property int right_spacing: 0
    property int left_spacing: 0

    // gesture serves no purpose in this version
    property int gesture: 0

    id: _hold

    height: (bpm * hispeed * duration * lane_length_multiplier * speed_base_multiplier) / parent.height

    anchors {
        left: parent.left
        right: parent.right
        leftMargin: play_area.node_width * (Math.min(start_pos[0], end_pos[0]) + left_spacing)
        rightMargin: play_area.node_width * ((16 - Math.max(start_pos[1], end_pos[1])) + right_spacing)
    }

    antialiasing: true

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

        opacity: 0.5
    }

    Rectangle {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: play_area.node_width * start_pos[0]

        height: 20
        width: play_area.node_width * (start_pos[1] - start_pos[0])
        radius: height

        color: line_color
    }

    function check_hold () {
        if (window < 0) return
        if (window > 60) {
            hitmark(0, start_pos[0] + left_spacing, start_pos[1] + left_spacing)
            shape_color = "gray"
            _hold.onWindowChanged.disconnect(check_hold)
        }

        var L = start_pos[0] + left_spacing
        var R = start_pos[1] + left_spacing

        if ((handA.gesture == 1 && handA.position >= L && handA.position < R)
             || (handB.gesture == 1 && handB.position >= L && handB.position < R)) {

            hitmark(2, L, R)
            _hold.onWindowChanged.disconnect(check_hold)
        }
    }

    function link () {
        _hold.onWindowChanged.connect(check_hold)
        _hold.onWindowChanged.connect(()=>{ if (window - duration > 0) _hold.destroy() })
    }
}
