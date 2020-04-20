import QtQuick 2.12
import QtQuick.Controls 2.12
import QtMultimedia 5.12

Column{
    id: column
    spacing: 20

    anchors {
        top: parent.top
        bottom: parent.bottom
        left: parent.left
        right: parent.right
        topMargin: 90
        bottomMargin: 90
        leftMargin: 160
        rightMargin: 160
    }

    Header{ text:"CAMERA  TEST" }
    Rectangle {
        width: 300
        height: 5
        color: "seashell"
    }

    Rectangle {
        width: parent.width / 2
        height: width * 9 / 16

        color: "transparent"
        border { color: "red"; width: 5 }

        Item {
            visible: handA.gesture != -2

            anchors.fill: parent

            Rectangle {
                height: width
                width: 30

                color: handA.gesture != -1 ? "yellow" : "transparent"
                border { color: "lightgreen"; width: 2 }

                anchors.verticalCenter: hA_horizontal.verticalCenter
                anchors.horizontalCenter: hA_vertical.horizontalCenter
            }

            Rectangle {
                id: hA_horizontal
                color: "lightgreen"
                height: 2
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter

                y: parent.height * handA.normY
            }

            Rectangle {
                id: hA_vertical
                color: "lightgreen"
                height: parent.height
                width: 2
                anchors.verticalCenter: parent.verticalCenter

                x: parent.width * handA.normX
            }
        }

        Item {
            visible: handB.gesture != -2

            anchors.fill: parent

            Rectangle {
                height: width
                width: 30

                color: handB.gesture != -1 ? "yellow" : "transparent"
                border { color: "lightgreen"; width: 2 }

                anchors.verticalCenter: hB_horizontal.verticalCenter
                anchors.horizontalCenter: hB_vertical.horizontalCenter
            }

            Rectangle {
                id: hB_horizontal
                color: "lightgreen"
                height: 2
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter

                y: parent.height * handB.normY
            }

            Rectangle {
                id: hB_vertical
                color: "lightgreen"
                height: parent.height
                width: 2
                anchors.verticalCenter: parent.verticalCenter

                x: parent.width * handB.normX
            }
        }
    }

    Text{
        color: "white"
        font.family: font_Genjyuu_XP_bold.name
        font.pixelSize: 40

        text:"BKSP  TO  RETURN"
    }

    Component.onCompleted:{
        mainqml.bksppress_signal.connect(tomain)
        gesture_engine_start()
    }

    function tomain(){ pageloader.source = "option_menu.qml" }

    Component.onDestruction: {
        mainqml.bksppress_signal.disconnect(tomain)
        gesture_engine_stop()
    }

    FontLoader { id: font_Genjyuu_XP_bold; source: "qrc:/font/GenJyuuGothicX-P-Bold.ttf" }
}
