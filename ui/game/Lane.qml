import QtQuick 2.12
import QtGraphicalEffects 1.0

Item {
    id: lane_main

    // We'll do the note generation OUTSIDE this qml, so aliases are needed here
    property alias hold_note_container: hold_note_container
    property alias click_note_container: click_note_container
    property alias swipe_note_container: swipe_note_container

    property double lane_angle: 52.5
    property double lane_length_multiplier: 8

    property double top_area: 0
    property double top_width: 0
    property double bottom_area: 0

    property double judge_position: 300
    property double note_height: 100

    antialiasing: true

    // the whole lane itself
    Item {
        id: lane_container
        width: parent.width
        height: parent.height * lane_length_multiplier
        anchors.bottom: parent.bottom

        // lane base
        Rectangle {
            id: play_area
            height: parent.height
            anchors.left: side_left.right
            anchors.right: side_right.left

            color: "#666666"
            opacity: 0.5
        }

        // judge line
        Rectangle {
            id: judge_line

            width: play_area.width
            height: note_height
            radius: note_height / 6
            color: "#222222"

            anchors.top: play_area.bottom
            anchors.topMargin: -judge_position
            anchors.horizontalCenter: play_area.horizontalCenter
        }

        Image {
            id: img
            anchors.fill: judge_line
            fillMode: Image.Tile
            source: "qrc:/ui/songselect/image/particle2.png"
            sourceSize {
                width: 10
                height: width
            }
            opacity: 0.15
            layer.enabled: true
            layer.effect: OpacityMask { maskSource: judge_line }
        }

        // divider
        Row {
            id: divider_container
            width: play_area.width / 2
            height: play_area.height
            anchors.centerIn: play_area
            spacing: width / 2
            Repeater {
                model: 3
                Rectangle {
                    width: 4
                    height: divider_container.height
                    color: "white"
                    antialiasing: true
                }
            }
        }

        // lane sides
        Rectangle {
            id: side_right
            height: parent.height
            width: parent.width / 25
            anchors.right: parent.right

            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.6; color: "#DDDDDD" }
                GradientStop { position: 1.0; color: "#999999" }
            }
        }

        Rectangle {
            id: side_left
            height: parent.height
            width: parent.width / 25
            anchors.left: parent.left

            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.4; color: "#DDDDDD" }
                GradientStop { position: 1.0; color: "#999999" }
            }
        }

        // note containers
        Item {
            id: hold_note_container
            anchors.fill: play_area
            z: 1
        }

        Item {
            id: click_note_container
            anchors.fill: play_area
            z: 2
        }

        transform: Rotation {
            origin.x: lane_container.width / 2; origin.y: lane_container.height
            axis: Qt.vector3d(1, 0, 0); angle: lane_angle
        }

        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: lane_mask
        }

        // lane mask
        Rectangle {
            id: lane_mask
            anchors.fill: lane_container
            visible: false
            gradient: Gradient {
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 0.2; color: "white" }
                GradientStop { position: 0.99; color: "white" }
                GradientStop { position: 1.0; color: "transparent" }
            }
        }
    }

    Item {
        id: swipe_note_container
        anchors.fill: parent
        z: 3
    }

    Component.onCompleted: {
        var left_top = swipe_note_container.mapFromItem(play_area, 0, 0)
        var right_top = swipe_note_container.mapFromItem(play_area, play_area.width, 0)
        var left_bottom = swipe_note_container.mapFromItem(play_area, 0, height * lane_length_multiplier)

        top_area = left_top.y
        top_width = Math.abs(right_top.x - left_top.x) / width
        bottom_area = 1 - top_area
    }
}
