import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

Item {
    id: mainqml
    visible: true

    width: Screen.width
    height: Screen.height

    property string version: "NH2:SL2.20200309.1b"

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
        focus: true
        asynchronous: true

        source: "/ui/game/game_main.qml"
    }

    // insert animations here

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