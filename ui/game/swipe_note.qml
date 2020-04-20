import QtQuick 2.12
import QtGraphicalEffects 1.0

Item {
    property int time: 2500
    property double bpm: 120.0
    property int window: game_timer.elapsed - time

    property int direction: 0
    property var swipe_color: ["#FF1111", "yellow", "darkturquoise", "chartreuse"]
    property var swipe_angle: [-90, 90, 180, 0]
    property int swipe_height: note_height * 6

    property int left_pos: 0
    property int right_pos: 0

    property double map_x: play_area.node_width * left_pos + side_left.width
    property double map_y: (bpm * hispeed * window * lane_length_multiplier * speed_base_multiplier) / play_area.height + (play_area.height - judge_position + note_height)

    id: _swipe

    height: swipe_height
    width: play_area.node_width * (right_pos - left_pos)

    antialiasing: true
    visible: map_y > 0

    onMap_yChanged: map()

    Rectangle {
        anchors.fill: parent
        opacity: 0.05

        gradient: Gradient {
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 0.25; color: swipe_color[direction] }
        }

        layer.enabled: true
        layer.effect: OpacityMask { maskSource: img; invert: true }
    }

    Item {
        id: img

        property double light: 0.0

        NumberAnimation on light {
            from: 0.0; to: 1.0
            loops: Animation.Infinite
            duration: 500
        }

        anchors.fill: parent

        Item {
            anchors.fill: parent

            Image {
                id: arrow
                source: "qrc:/ui/game/image/swipe_arrow_new.png"

                anchors.fill: parent
                fillMode: Image.PreserveAspectFit

                opacity: 0.6
            }

            LinearGradient {
                source: arrow
                anchors.fill: parent
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: img.light - 0.1; color: "transparent" }
                    GradientStop { position: img.light; color: "white" }
                    GradientStop { position: img.light + 0.1; color: "transparent" }
                }
                opacity: 1
            }

            rotation: swipe_angle[direction]
            scale: 0.5
        }


        Image {
            source: "qrc:/ui/game/image/swipe_note_bg.png"

            height: note_height * 2
            width: parent.width
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            fillMode: Image.Stretch

            opacity: 0.2
        }

        layer.enabled: true
        layer.effect: ColorOverlay { color: swipe_color[direction] }
    }

    Rectangle {
        opacity: 0.5
        height: note_height / 4
        width: parent.width
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        color: swipe_color[direction]
    }

    transformOrigin: Item.BottomLeft
    scale: top_width + (1 - top_width) * (y + height - top_area) / bottom_area

    onYChanged: { if (y > parent.height) _swipe.destroy() }

    function map () {
        var p = swipe_note_container.mapFromItem(lane_container, map_x, map_y)
        x = p.x
        y = p.y - height
        z = p.y / parent.height + 3
    }

    function hit (id, pos) {
        // not yet
        if (Math.abs(window) > 80) return;

        // check area, exact
        if ( id == direction && pos >= left_pos && pos < right_pos) {
            hitmark(2, left_pos, right_pos)
            _swipe.destroy();
        }
    }

    function link () {
        mainqml.swipe_trigger.connect(hit)
        _swipe.onWindowChanged.connect(()=>{ if (window > 80) {
                                               hitmark(0, left_pos, right_pos)
                                               _swipe.destroy()
                                           }})
    }

    Component.onCompleted: map()

    Component.onDestruction: mainqml.swipe_trigger.disconnect(hit)
}
