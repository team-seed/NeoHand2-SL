import QtQuick 2.12
import QtQuick.Controls 2.12

Column{
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

    Header{  text: "NETWORK  TEST" }

    Rectangle {
        width: 300
        height: 5
        color: "seashell"
    }

    Text{
        color: "white"
        font.family: font_Genjyuu_XP_bold.name
        font.pixelSize: 20

        text: "Online service is not supported in this version."
    }

    Text{
        color: "white"
        font.family: font_Genjyuu_XP_bold.name
        font.pixelSize: 40

        text:"BKSP  TO  RETURN"
    }

    Component.onCompleted:{
        mainqml.leftpress_signal.connect(tomain)
        mainqml.bksppress_signal.connect(tomain)
    }

    function tomain () {pageloader.source = "option_menu.qml"}

    Component.onDestruction: {
        mainqml.leftpress_signal.disconnect(tomain)
        mainqml.bksppress_signal.disconnect(tomain)
    }

    FontLoader { id: font_Genjyuu_XP_bold; source: "qrc:/font/GenJyuuGothicX-P-Bold.ttf" }

}
