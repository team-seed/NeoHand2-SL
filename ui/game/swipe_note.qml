import QtQuick 2.12

Item {
    property int time: 0
    property double bpm: 120.0
    property int window: game_timer.elapsed - time

    property int direction: 0
    property int swipe_height: 500

    property int left_pos: 0
    property int right_pos: 0

    property double map_x: play_area.node_width * left_pos + side_left.width
    property double map_y: (bpm * hispeed * window * lane_length_multiplier * speed_base_multiplier) / play_area.height + (play_area.height - judge_position + note_height)

    id: _swipe

    height: swipe_height
    width: play_area.node_width * (right_pos - left_pos)

    antialiasing: true
    visible: map_y > 0

    onWindowChanged: {
        var p = swipe_note_container.mapFromItem(lane_container, map_x, map_y)
        x = p.x
        y = p.y - height
        z = p.y / parent.height
    }

    Rectangle {
        anchors.fill: parent
        opacity: 0.5
        //color: "yellow"

        gradient: Gradient {
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 1.0; color: "yellow" }

        }
    }

    transformOrigin: Item.BottomLeft
    scale: top_width + (1 - top_width) * (y + height - top_area) / bottom_area

    onYChanged: { if (y > parent.height) _swipe.destroy()  }
}
