import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

Rectangle{
    color: "white"
    Loader{
        id:pageloader
        anchors.fill:parent
        focus: true
        source: "option_menu.qml"
    }
}
