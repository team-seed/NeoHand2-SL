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
    property int global_track_count: 0

    property int global_offset: 0

    // soundfx handler
    CustomSoundFX { id: soundfx }

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

        onLoaded: {
            if(transitionA.is_running){
                transitionA.is_running = false
                transitionA.quit()
            }
            else if(transitionB.is_running){
                transitionB.is_running = false
                transitionB.quit()
            }
        }
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

    TransitionA {
        id: transitionA
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

    Component.onCompleted: {

    }

    Component.onDestruction: {
    }

}
