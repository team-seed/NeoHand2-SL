import QtQuick 2.12

Rectangle {
    property int time: 2500
    property double bpm: 120.0

    property int window: game_timer.elapsed - time

    property double map_y: (bpm * hispeed * window * lane_length_multiplier * speed_base_multiplier) / play_area.height + (play_area.height - judge_position + note_height)

    id: _barline
    height: 5
    width: play_area.node_width * 16
    opacity: 0.3

    color: "white"

    onMap_yChanged: map()
    antialiasing: true

    visible: map_y > 0

    transformOrigin: Item.BottomLeft
    scale: top_width + (1 - top_width) * (y + height - top_area) / bottom_area

    //onYChanged: { if (y > parent.height) _barline.destroy() }

    //onWindowChanged: { if (window > 0) _barline.destroy() }

    function map () {
        var p = swipe_note_container.mapFromItem(lane_container, side_left.width, map_y)
        x = p.x
        y = p.y - height
        //z = p.y / parent.height
    }

    function link () {
        _barline.onWindowChanged.connect(()=>{if (window > 0) _barline.destroy()})

        //console.log("linked - barline")

    }

    Component.onCompleted: map()

    //Component.onDestruction: console.log("destruction - barline")
}
