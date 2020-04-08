import QtQuick 2.12


Item {
    property string src: ""

    id: mark
    y: judge_line.y
    anchors.horizontalCenter: parent.horizontalCenter

    Image {
        id: mark_image
        anchors.horizontalCenter: parent.horizontalCenter

        source: src
        height: 30
        fillMode: Image.PreserveAspectFit
        opacity: 0.75
    }

    SequentialAnimation {
        running: true
        alwaysRunToEnd: true

        NumberAnimation {
            target: mark
            property: "y"
            to: judge_line.y - 50
            easing.type: Easing.OutExpo
            duration: 250
        }
        NumberAnimation {
            target: mark
            property: "opacity"
            to: 0
            duration: 250
        }
    }
}


