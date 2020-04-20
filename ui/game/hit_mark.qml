import QtQuick 2.12

Item {
    id: _hitmark
    height: 30
    width: parent.width
    anchors.bottom: parent.bottom

    property int type: 0
    property double left_pos: 0
    property double right_pos: 0

    opacity: 0.75

    Text {
        id: mark_txt
        height: parent.height
        width: 500
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: parent.width * left_pos / 16
        anchors.rightMargin: parent.width * (16 - right_pos) / 16

        color: switch (type) {
               case 0: return "red"
               case 1: return "deepskyblue"
               case 2: return "yellow"
               }
        text:   switch (type) {
                case 0: return "BREAK"
                case 1: return "CLOSE"
                case 2: return "EXACT"
                }

        font.family: font_good_times.name
        font.pixelSize: height
        font.letterSpacing: 10

        horizontalAlignment: Text.AlignHCenter
    }

    SequentialAnimation {
        running: true

        ParallelAnimation {
            NumberAnimation {
                target: mark_txt
                property: "anchors.bottomMargin"
                from: 0; to: 80
                duration: 200
                easing.type: Easing.OutExpo
            }
            NumberAnimation {
                target: mark_txt
                property: "opacity"
                from: 0; to: 1
                duration: 200
                easing.type: Easing.OutExpo
            }
        }

        PauseAnimation { duration: 100 }

        ParallelAnimation {
            NumberAnimation {
                target: mark_txt
                property: "font.letterSpacing"
                from: 10; to: 50
                duration: 200
                easing.type: Easing.InExpo
            }
            NumberAnimation {
                target: mark_txt
                property: "opacity"
                from: 1; to: 0
                duration: 200
                easing.type: Easing.InSine
            }
        }

        onFinished: _hitmark.destroy()
    }
}
