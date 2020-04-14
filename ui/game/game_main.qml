import QtQuick 2.12
import QtQuick.Window 2.12
import QtGraphicalEffects 1.0



import "qrc:/ui/game/note_generator.js" as NOTE_GENERATOR

Item {
    id: game_main

    anchors.fill: parent

    // temporary backgrond
    Rectangle {
        anchors.fill: parent
        color: "#222222"
    }

    Text {
        id: name
        text: global_song_meta.toString()
        color: "white"
    }

    Lane {
        id: game_lane

        width: 1600
        height: 900
        anchors.centerIn: parent

        scale: game_main.width / width

        function generating_notes () {

        }
    }

    function to_main () {
        pageloader.source = "/ui/option/option_menu.qml"
    }

    function disconnect_all() {
        mainqml.escpress_signal.disconnect(to_main)
    }

    Component.onCompleted: {
        mainqml.escpress_signal.connect(to_main)
    }

    Component.onDestruction: {
        disconnect_all();
    }
}
