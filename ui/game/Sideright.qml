import QtQuick 2.12

Rectangle {
    id: game_screen_side_right

    antialiasing: true
    height: parent.height / 4
    width: side_length
    visible: false

    anchors {
        left: game_core.right
        top: parent.top
    }

    transform: Rotation {
        axis { x:0; y:1; z:0 } angle: -side_angle
    }
}
