import QtQuick 2.12
import QtQuick.Controls 2.12

Column {
    property int select_index: 0

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

    Option_list { id: op_list }

    Header { text: "NeoHand 2: SEED OF LEGGENDARIA" }

    Text {
        text: version
        color: "gray"
        font.family: font_Genjyuu_XP_bold.name
        font.pixelSize: parent.height / 30
    }

    Rectangle {
        width: 300
        height: 5
        color: "seashell"
    }

    Repeater {
        model: op_list

        SelectBar {
            text: title
            color: select_index == index ? "red" : "gray"
        }
    }

    Component.onCompleted: {
        mainqml.uppress_signal.connect(up)
        mainqml.downpress_signal.connect(down)
        mainqml.enterpress_signal.connect(page_switch)
        mainqml.rightpress_signal.connect(page_switch)
    }

    function up () { select_index = (select_index + op_list.count - 1) % op_list.count }
    function down () { select_index = (select_index + 1) % op_list.count }
    function page_switch() { op_list.get(select_index).script() }

    Component.onDestruction: {
        mainqml.uppress_signal.disconnect(up)
        mainqml.downpress_signal.disconnect(down)
        mainqml.rightpress_signal.disconnect(page_switch)
        mainqml.enterpress_signal.disconnect(page_switch)
    }

    FontLoader { id: font_Genjyuu_XP_bold; source: "qrc:/font/GenJyuuGothicX-P-Bold.ttf" }
}
