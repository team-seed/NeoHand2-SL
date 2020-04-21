import QtQuick 2.0

ListModel {

    ListElement { title: "GAME  START"; script: function () {
        transitionA.start()
        change_page("qrc:/ui/songselect/songselect_main.qml", 6000)
    }}

    ListElement { title: "BUTTON  TEST"; script: function () { pageloader.source = "button_test.qml" }}

    ListElement { title: "CAMERA  TEST"; script: function () { pageloader.source = "camera_test.qml" }}

    //ListElement { title: "NETWORK  TEST"; script: function () { pageloader.source = "network_test.qml" }}

    ListElement { title: "PARAM  SETTINGS"; script: function () { pageloader.source = "param_setting.qml" }}

    ListElement { title: "QUIT"; script: function () { Qt.quit() }}

}
