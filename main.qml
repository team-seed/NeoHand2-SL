import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

import custom.soundfx 1.0

Item {
    id: mainqml
    visible: true

    width: Screen.width
    height: Screen.height

    property string version: "NH2:SL2.20200418.1b"

    property var global_song_meta: null
    property bool global_is_expert: false
    property int final_score: 0

    property int global_track_count: 0

    property int global_offset: 0

    // soundfx handler
    CustomSoundFX { id: soundfx }

    Item {
        id: handA
        property double normX: 0.0
        property double normY: 0.0
        property int gesture: -2
        property int position: -2

        onGestureChanged: {
            if (gesture == -2) console.log("Hand A left.")
        }
    }

    Item {
        id: handB
        property double normX: 0.0
        property double normY: 0.0
        property int gesture: -2
        property int position: -2

        onGestureChanged: {
            if (gesture == -2) console.log("Hand B left.")
        }
    }

    // disable mouse functions
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.BlankCursor
        enabled: false
    }

    // black background cover
    Rectangle {
        anchors.fill: parent
        color: "black"
    }

    // loader for page switching
    Loader {
        id: pageloader
        height: parent.height
        width: height * 16/9
        anchors.centerIn: parent
        //focus: true
        asynchronous: true

        //source: "qrc:/ui/result.qml"
        source: "qrc:/ui/option/option_menu.qml"
        //source: "qrc:/ui/game/game_main.qml"

        onLoaded:  gesture_engine_start()//transitionB.quit()
    }

    Timer {
        property string next_page: ""

        id: page_change_timer
        interval: 2000
        onTriggered: {
            pageloader.source = next_page
        }
    }

    // insert animations here
    TransitionB {
        id: transitionB
    }

    function change_page (path) {
        page_change_timer.next_page = path
        page_change_timer.restart()
    }

    // press signal
    signal uppress_signal()
    signal downpress_signal()
    signal leftpress_signal()
    signal rightpress_signal()
    signal enterpress_signal()
    signal spacepress_signal()
    signal bksppress_signal()
    signal escpress_signal()

    // release signal
    signal uprelease_signal()
    signal downrelease_signal()
    signal leftrelease_signal()
    signal rightrelease_signal()
    signal enterrelease_signal()
    signal spacerelease_signal()
    signal bksprelease_signal()
    signal escrelease_signal()

    //hand engine
    signal click_trigger(var position)
    signal click_untrigger()
    signal swipe_trigger(var id, var position)
    function handA_update(x, y, ges, position){
        handA.normX = x
        handA.normY = y
        handA.gesture = ges
        handA.position = position

        //console.log("Hand A ", x.toFixed(10), y.toFixed(10), ges, position)
    }
    function handB_update(x, y, ges, position){
        handB.normX = x
        handB.normY = y
        handB.gesture = ges
        handB.position = position

        //console.log("Hand B ", x.toFixed(10), y.toFixed(10), ges, position)
    }

    //hand engine (output signal)
    signal gesture_engine_start()
    signal gesture_engine_stop()

    Component.onCompleted: {
    }

    Component.onDestruction: {
    }

}
