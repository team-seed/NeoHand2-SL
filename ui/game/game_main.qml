import QtQuick 2.12
import QtQuick.Window 2.12
import QtGraphicalEffects 1.0

import custom.chart_maker 1.0

Item {
    id: game_main

    property double hispeed: 1.0

    anchors.fill: parent

    CustomChartMaker { id: chart_maker }

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
    }

    function to_main () {
        pageloader.source = "/ui/option/option_menu.qml"
    }

    function disconnect_all() {
        mainqml.escpress_signal.disconnect(to_main)
    }

    Component.onCompleted: {
        game_lane.generating_notes()
        mainqml.escpress_signal.connect(to_main)
    }

    Component.onDestruction: {
        disconnect_all();
    }
}
