import QtQuick 2.12
import QtQuick.Window 2.12
import QtGraphicalEffects 1.0

import custom.chart_maker 1.0
import custom.game_clock 1.0

Item {
    id: game_main

    //property int duration_before_start: 3000
    property double hispeed: 1.0
    property int current_score: 0

    property int total_object: 0
    property int current_life: 0

    anchors.fill: parent

    CustomChartMaker { id: chart_maker }
    CustomGameClock {
        id: game_timer
        onGame_finished: game_end_countdown.start()
    }

    // temporary backgrond
    Rectangle {
        anchors.fill: parent
        color: "#222222"
    }

    Lane {
        id: game_lane

        width: 1920
        height: 1080
        anchors.centerIn: parent

        scale: game_main.width / width
    }

    Game_panel { id: game_panel }

    Timer {
        id: game_start_countdown
        interval: game_timer.duration_before_start
        onTriggered: game_timer.game_start()
    }

    Timer {
        id: game_end_countdown
        interval: 2000
        onTriggered: {
            transitionA.start()
            change_page("qrc:/ui/result.qml", 6000)
        }
    }

    function hispeed_increase () { hispeed = Math.min(9.5, hispeed + 0.5) }
    function hispeed_decrease () { hispeed = Math.max(0.5, hispeed - 0.5) }

    function to_main () { pageloader.source = "/ui/option/option_menu.qml" }

    function disconnect_all() {
        mainqml.uppress_signal.disconnect(hispeed_increase)
        mainqml.downpress_signal.disconnect(hispeed_decrease)
        mainqml.spacepress_signal.disconnect(skip)
    }

    function skip () {
        transitionA.start()
        change_page("qrc:/ui/result.qml", 6000)
    }

    Component.onCompleted: {
        game_timer.set_song("file:///" + global_song_meta[0] + "/audio.wav")
        game_lane.generating_notes()
        mainqml.uppress_signal.connect(hispeed_increase)
        mainqml.downpress_signal.connect(hispeed_decrease)
        mainqml.spacepress_signal.connect(skip)

        gesture_engine_start()
    }

    Component.onDestruction: {
        disconnect_all();

        gesture_engine_stop()
    }
}
