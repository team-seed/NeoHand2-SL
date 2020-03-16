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

    FontLoader { id: font_Genjyuu_XP_bold; source: "qrc:/font/GenJyuuGothicX-P-Bold.ttf" }
    Header{ id:header; text:"BUTTON  TEST" }

    Rectangle {
        width: 300
        height: 5
        color: "seashell"
    }

    MyButton{
        id: up
        Text { anchors.centerIn: parent; color: "gray"; text: "UP"; font.pixelSize: parent.height; font.family:font_Genjyuu_XP_bold.name}
    }
    MyButton{
        id: down
        Text { anchors.centerIn: parent; color: "gray"; text: "DOWN"; font.pixelSize: parent.height; font.family:font_Genjyuu_XP_bold.name}
    }
    MyButton{
        id: left
        Text { anchors.centerIn: parent; color: "gray"; text: "LEFT"; font.pixelSize: parent.height; font.family:font_Genjyuu_XP_bold.name}
    }
    MyButton{
        id: right
        Text { anchors.centerIn: parent; color: "gray"; text: "RIGHT"; font.pixelSize: parent.height; font.family:font_Genjyuu_XP_bold.name}
    }

    MyButton{
        id: enter
        Text { anchors.centerIn: parent; color: "gray"; text: "ENTER"; font.pixelSize: parent.height; font.family:font_Genjyuu_XP_bold.name}
    }

    MyButton{
        id: space
        Text { anchors.centerIn: parent; color: "gray"; text: "SPACE"; font.pixelSize: parent.height; font.family:font_Genjyuu_XP_bold.name}
    }
    MyButton{
        id: backspace
        Text { anchors.centerIn: parent; color: "gray"; text: "BKSP"; font.pixelSize: parent.height; font.family:font_Genjyuu_XP_bold.name}
    }
    MyButton{
        id: esc
        Text { anchors.centerIn: parent; color: "gray"; text: "ESC"; font.pixelSize: parent.height; font.family:font_Genjyuu_XP_bold.name}
    }

    Text{
        color: "white"
        font.family: font_Genjyuu_XP_bold.name
        font.pixelSize: 40

        text:"ESC + BKSP  TO  RETURN"
    }

    Component.onCompleted: {
        //press
        mainqml.uppress_signal.connect(uppress)
        mainqml.downpress_signal.connect(downpress)
        mainqml.leftpress_signal.connect(leftpress)
        mainqml.rightpress_signal.connect(rightpress)
        mainqml.enterpress_signal.connect(enterpress)
        mainqml.spacepress_signal.connect(spacepress)
        mainqml.bksppress_signal.connect(bksppress)
        mainqml.escpress_signal.connect(escpress)

        //release
        mainqml.uprelease_signal.connect(uprelease)
        mainqml.downrelease_signal.connect(downrelease)
        mainqml.leftrelease_signal.connect(leftrelease)
        mainqml.rightrelease_signal.connect(rightrelease)
        mainqml.enterrelease_signal.connect(enterrelease)
        mainqml.spacerelease_signal.connect(spacerelease)
        mainqml.bksprelease_signal.connect(bksprelease)
        mainqml.escrelease_signal.connect(escrelease)
    }

    function uppress(){up.state = "Pressed"}
    function downpress(){down.state = "Pressed"}
    function leftpress(){left.state = "Pressed"}
    function rightpress(){right.state = "Pressed"}
    function enterpress(){enter.state = "Pressed"}
    function spacepress(){space.state = "Pressed"}
    function bksppress(){backspace.state = "Pressed"; if (esc.state == "Pressed") {pageloader.source = "option_menu.qml"}}
    function escpress(){esc.state = "Pressed"; if (backspace.state == "Pressed") {pageloader.source = "option_menu.qml"}}

    function uprelease(){up.state = "Released"}
    function downrelease(){down.state = "Released"}
    function leftrelease(){left.state = "Released"}
    function rightrelease(){right.state = "Released"}
    function enterrelease(){enter.state = "Released"}
    function spacerelease(){space.state = "Released"}
    function bksprelease(){backspace.state = "Released"}
    function escrelease(){esc.state = "Released"}

    Component.onDestruction: {
        mainqml.uppress_signal.disconnect(uppress)
        mainqml.downpress_signal.disconnect(downpress)
        mainqml.leftpress_signal.disconnect(leftpress)
        mainqml.rightpress_signal.disconnect(rightpress)
        mainqml.enterpress_signal.disconnect(enterpress)
        mainqml.spacepress_signal.disconnect(spacepress)
        mainqml.bksppress_signal.disconnect(bksppress)
        mainqml.escpress_signal.disconnect(escpress)

        mainqml.uprelease_signal.disconnect(uprelease)
        mainqml.downrelease_signal.disconnect(downrelease)
        mainqml.leftrelease_signal.disconnect(leftrelease)
        mainqml.rightrelease_signal.disconnect(rightrelease)
        mainqml.enterrelease_signal.disconnect(enterrelease)
        mainqml.spacerelease_signal.disconnect(spacerelease)
        mainqml.escrelease_signal.disconnect(escrelease)
        mainqml.bksprelease_signal.disconnect(bksprelease)
    }
}
