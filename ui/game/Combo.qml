import QtQuick 2.0

Item {
    id: combo_box
    opacity: 0.7

    width: parent.width / 4
    height: parent.height / 4

    property double pointheight: this.height / 20
    property int max_combo: 0
    property int total_combo: 0

    Text {
        id: combo_max
        text: "MAX " + max_combo.toString()
        color: "white"

        font.family: font_good_times.name
        font.pixelSize: pointheight * 2

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
        }
    }

    Text {
        id: combo_count

        text: total_combo.toString();
        color: "white"

        font.family: font_good_times.name
        font.pixelSize: pointheight * 8


        anchors {
            horizontalCenter: parent.horizontalCenter
            top: combo_max.bottom
        }
    }

    Text {
        id: combo
        text: "COMBO"
        color: "white"

        font.family: font_good_times.name
        font.pixelSize: pointheight * 3

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: combo_count.bottom
        }
    }

    function add_combo () {
        if (total_combo == max_combo) max_combo++
        total_combo++
    }

    function break_combo () {
        total_combo = 0
    }

    Behavior on total_combo {
        NumberAnimation {
            duration: 4
        }
    }

    FontLoader {
        id: font_good_times
        source: "/font/good-times-rg.ttf"
    }
}
