import QtQuick 2.12
import QtQuick.Window 2.12
import QtGraphicalEffects 1.0

Item {
    id: game_main

    anchors.fill: parent

    property double lane_angle: 45
    property double lane_length_multiplier: 8

    property double judge_margin: height / 3
    property double lane_bottom_margin: height / 9

    Rectangle {
        id: red_rec
        height: parent.height / 3
        width: parent.width / 3

        anchors.centerIn: parent

        color: "red"

        Rectangle {
            id: test_block
            height: 25
            width: 25

            anchors.centerIn: parent

            color: "white"
        }

        transform: Rotation {
            origin.x: red_rec.width
            axis {x:1; y:0; z:0} angle: 45
        }
    }

    Text {
        id: name
        text: qsTr(test_block.x.toString() + " , " + test_block.y.toString())
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }

        font.pixelSize: 150
        color: "white"
    }

    /*Rectangle {
        anchors.fill: parent
        color: "steelblue"
    }

    Item {
        id: lane

        width: parent.width
        height: parent.height * lane_length_multiplier

        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }

        //color: "white"
        //opacity: 0.5

        transform: [
            Rotation {
                origin.x: lane.width / 2
                origin.y: lane.height //- judge_margin
                axis: Qt.vector3d(1,0,0); angle: lane_angle
            },
            Scale {
                origin.x: width / 2
                origin.y: height //- judge_margin
                xScale: 1
            }
        ]

        Rectangle {
            width: parent.width
            height: parent.height - judge_margin

            anchors {
                top: parent.top
                horizontalCenter: parent.horizontalCenter
            }

            color: "white"
            opacity: 0.5

            Rectangle {
                width: parent.width
                height: 50

                anchors {
                    bottom: parent.bottom
                    horizontalCenter: parent.horizontalCenter
                }

                color: "gray"
            }
        }

        Rectangle {
            width: parent.width
            height: judge_margin

            anchors {
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
            }

            color: "red"
            opacity: 0.5
        }

        Rectangle {
            id: left_side

            width: parent.width
            height: parent.height

            anchors {
                right: parent.left
                bottom: parent.bottom
            }

            color: "blue"
            border {
                width: 50
                color: "green"
            }

            //rotation: 45
            transform: Rotation {
                origin.x: left_side.width
                origin.y: left_side.height / 2
                axis: Qt.vector3d(1,0,0); angle: 68.5
            }



        }
    }*/


}
