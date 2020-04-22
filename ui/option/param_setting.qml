import QtQuick 2.12
import QtQuick.Controls 2.12

Column{
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

    ListModel {
        id: params

        ListElement {
            name: "Global offset"
            type: "integer"; value: 0
            initialize: function (i) { params.setProperty(i, "value", global_offset) }
            save: function (i) { global_offset = params.get(i).value }
        }

        ListElement {
            name: "Default HiSpeed"
            type: "half"; value: 0
            initialize: function (i) { params.setProperty(i, "value", default_hispeed) }
            save: function (i) { default_hispeed = Math.min(9.5, Math.max(0.5, params.get(i).value)) }
        }
    }

    Header{ text: "PARAM  SETTING" }

    Rectangle {
        width: 300
        height: 5
        color: "seashell"
    }

    Repeater {
        model: params

        SelectBar {
            property bool selected: select_index == index
            text: name + "\t\t\t" + (selected ? "<\t" : "\t") + value.toString() + (selected ? "\t\t>" : "")
            color: selected ? "red" : "gray"
        }
    }

    Text{
        color: "white"
        font.family: font_Genjyuu_XP_bold.name
        font.pixelSize: 40

        text:"BKSP  TO  RETURN"
    }

    Component.onCompleted: {
        for (var i = 0; i < params.count; i++) {
            params.get(i).initialize(i)
        }

        mainqml.uppress_signal.connect(up)
        mainqml.downpress_signal.connect(down)
        mainqml.leftpress_signal.connect(left)
        mainqml.rightpress_signal.connect(right)
        mainqml.bksppress_signal.connect(tomain)
    }

    function up () { select_index = (select_index + params.count - 1) % params.count }
    function down () { select_index = (select_index + 1) % params.count }
    function left () {
        var obj = params.get(select_index)
        switch (obj.type) {
        case "integer": params.setProperty(select_index, "value", obj.value - 1); break
        case "half": params.setProperty(select_index, "value", obj.value - 0.5); break
        }
    }
    function right () {
        var obj = params.get(select_index)
        switch (obj.type) {
        case "integer": params.setProperty(select_index, "value", obj.value + 1); break
        case "half": params.setProperty(select_index, "value", obj.value + 0.5); break
        }
    }
    function tomain () {pageloader.source = "option_menu.qml"}

    Component.onDestruction: {
        for (var i = 0; i < params.count; i++) {
            params.get(i).save(i)
        }
        mainqml.uppress_signal.disconnect(up)
        mainqml.downpress_signal.disconnect(down)
        mainqml.leftpress_signal.disconnect(left)
        mainqml.rightpress_signal.disconnect(right)
        mainqml.bksppress_signal.disconnect(tomain)
    }

    FontLoader { id: font_Genjyuu_XP_bold; source: "qrc:/font/GenJyuuGothicX-P-Bold.ttf" }
}
