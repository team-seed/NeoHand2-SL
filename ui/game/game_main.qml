import QtQuick 2.12
import QtQuick.Window 2.12
import QtGraphicalEffects 1.0

import custom.chart_maker 1.0
import custom.game_clock 1.0

Item {
    id: game_main

    property int duration_before_start: 3000
    property double hispeed: 1.0

    anchors.fill: parent

    CustomChartMaker { id: chart_maker }
    CustomGameClock { id: game_timer }

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

        width: 1920
        height: 1080
        anchors.centerIn: parent

        scale: game_main.width / width
    }

    Timer {
        id: game_start_countdown
        interval: duration_before_start
        onTriggered: game_timer.game_start()
    }

    function hispeed_increase () { hispeed = Math.min(9.5, hispeed + 0.5) }
    function hispeed_decrease () { hispeed = Math.max(0.5, hispeed - 0.5) }

    function to_main () { pageloader.source = "/ui/option/option_menu.qml" }

    function disconnect_all() {
        mainqml.escpress_signal.disconnect(to_main)
        mainqml.uppress_signal.disconnect(hispeed_increase)
        mainqml.downpress_signal.disconnect(hispeed_decrease)
    }

    Component.onCompleted: {
        game_timer.set_song("file:///" + global_song_meta[0] + "/audio.wav")
        game_lane.generating_notes()
        mainqml.escpress_signal.connect(to_main)
        mainqml.uppress_signal.connect(hispeed_increase)
        mainqml.downpress_signal.connect(hispeed_decrease)
    }

    Component.onDestruction: {
        disconnect_all();
    }
}
