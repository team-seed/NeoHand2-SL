import QtQuick 2.12

Rectangle {
    property int time: 0
    property double bpm: 120.0

    property int window: game_timer.elapsed - time

    property double map_y: (bpm * hispeed * window * lane_length_multiplier * speed_base_multiplier) / play_area.height + (play_area.height - judge_position + note_height)

    id: _barline
    height: 5
    width: play_area.node_width * 16
    opacity: 0.5

    color: "white"

    onWindowChanged: {
        var p = swipe_note_container.mapFromItem(lane_container, side_left.width, map_y)
        x = p.x
        y = p.y - height
        //z = p.y / parent.height
    }

    visible: map_y > 0

    //y: (bpm * hispeed * window * lane_length_multiplier * speed_base_multiplier) / parent.height + (parent.height + note_height - judge_position)

    transformOrigin: Item.BottomLeft
    scale: top_width + (1 - top_width) * (y + height - top_area) / bottom_area

    onYChanged: { if (y > parent.height) _barline.destroy() }
}
