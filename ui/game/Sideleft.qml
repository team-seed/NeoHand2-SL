import QtQuick 2.12

Rectangle {
    id: game_screen_side_left

    antialiasing: true
    height: parent.height / 4
    width: side_length
    visible: false

    anchors {
        right: game_core.left
        top: parent.top
    }

    transform: Rotation {
        origin.x: game_screen_side_left.width
        axis { x:0; y:1; z:0 } angle: side_angle
    }
}
