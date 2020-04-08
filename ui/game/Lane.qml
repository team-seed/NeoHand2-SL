import QtQuick 2.0
import QtGraphicalEffects 1.0

import "game_process_extension.js" as GP

Item {
    id: lane_full
    property alias game_lane: lane_full

    property int side_width: parent.width / 40
    property int judge_height: side_width
    property int separater_width: 1
    property int lane_count: 4
    property int partitions_per_lane: 4
    property double part_width: lane_row.width / lane_count / partitions_per_lane
    property double judge_position: parent.height / 12

    Rectangle {
        id: object_mask
        visible: false
        anchors.fill: lane_row
        gradient: Gradient {
            GradientStop { position: 0.00; color: "transparent" }
            GradientStop { position: 0.20; color: "white" }
            GradientStop { position: 0.95; color: "white" }
            GradientStop { position: 0.99; color: "transparent" }
        }
    }

    Item {
        id: lane_row
        height: parent.height
        anchors {
            left: lane_side_left.right
            right: lane_side_right.left
        }
    }

    LinearGradient {
        id: gradient_lane_mask
        antialiasing: true
        opacity: 0.4
        anchors.fill: lane_row
        gradient: Gradient {
            GradientStop { position: 0.00; color: "transparent" }
            GradientStop { position: 0.20; color: "white" }
            GradientStop { position: 0.95; color: "white" }
            GradientStop { position: 0.99; color: "transparent" }
        }
    }

    Blend {
        anchors.fill: lane_row
        source: lane_row
        foregroundSource: gradient_lane_mask
        mode: "hue"
    }

    Rectangle {
        id: hand_mark
        anchors.bottom: judge_line.bottom
        x: part_width * gesture_engine.hand_pos + side_width
        visible: gesture_engine.hand_pos >= 0

        width: part_width
        height: parent.height / 2
        opacity: 0.75
        z: 1000
        gradient: Gradient {
            GradientStop { position: 0; color: "transparent" }
            GradientStop { position: 1; color: enable ? "skyblue" : "whitesmoke" }
        }
    }

    Rectangle {
        id: lane_side_left
        antialiasing: true
        height: parent.height
        width: side_width
        opacity: 0.9

        anchors {
            left: parent.left
        }

        gradient: Gradient {
            GradientStop { position: 0.00; color: "transparent" }
            GradientStop { position: 0.20; color: "#444444" }
            GradientStop { position: 0.95; color: "#222222" }
            GradientStop { position: 0.98; color: "transparent" }
        }

    }

    Rectangle {
        id: lane_side_right
        antialiasing: true
        height: parent.height
        width: side_width
        opacity: lane_side_left.opacity

        anchors {
            right: parent.right
        }

        gradient: Gradient {
            GradientStop { position: 0.00; color: "transparent" }
            GradientStop { position: 0.20; color: "#444444" }
            GradientStop { position: 0.95; color: "#222222" }
            GradientStop { position: 0.98; color: "transparent" }
        }
    }

    Row {
        opacity: 0.7
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
        }
        height: parent.height
        spacing: lane_row.width / lane_count - separater_width

        Repeater {
            model: 3

            Rectangle {
                antialiasing: true
                height: parent.height
                width: separater_width
                gradient: Gradient {
                    GradientStop { position: 0.00; color: "transparent" }
                    GradientStop { position: 0.30; color: "#BBBBBB" }
                    GradientStop { position: 0.90; color: "#DDDDDD" }
                    GradientStop { position: 0.97; color: "transparent" }
                }
            }
        }
    }

    Rectangle {
        id: judge_line

        color: "#353535"
        opacity: 0.8

        height: judge_height
        width: parent.width - side_width * 2

        anchors {
            left: lane_side_left.right
            right: lane_side_right.left
            bottom: parent.bottom
            bottomMargin: judge_position - height
            verticalCenterOffset: -height
        }
    }

    Item {
        id: hold_note_container
        anchors.fill: lane_row

        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: object_mask
        }
    }

    Text {
        text: "NO  HAND"
        height: judge_line.height * 2
        visible: !hand_mark.visible

        font.family: font_good_times.name
        font.pixelSize: height * 0.8
        color: "whitesmoke"
        style: Text.Outline
        styleColor: "firebrick"

        anchors.centerIn: judge_line
    }

    function make_chart () {
        game_process.chart.reverse().forEach(value => {
            if (Array.isArray(value)) {
                switch (value[0]) {
                case 0:
                    GP.generateNote(value[1], value[2], value[3], value[4], value[5])
                    break
                case 1:
                    GP.generateHold(value[1], value[2], value[3], value[4], value[5], value[6], value[7], value[8])
                    break
                case 2:
                    GP.generateSwipe(value[6], value[2], value[3], value[4], value[5])
                    break
                case -1:
                    GP.generateBarline(value[1], value[2]);
                    break
                }

                if (value[0] != -1) total_note_count += 1
            }
            else {
                console.log(value);
            }
        });
    }

    FontLoader {
        id: font_good_times
        source: "/font/good-times-rg.ttf"
    }

}
