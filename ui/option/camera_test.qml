import QtQuick 2.12
import QtQuick.Controls 2.12
import QtMultimedia 5.12

Column{
    id: column
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

    Header{ text:"CAMERA  TEST" }
    Rectangle {
        width: 300
        height: 5
        color: "seashell"
    }

    Camera{
        id: cam
        imageProcessing.whiteBalanceMode: CameraImageProcessing.WhiteBalanceFlash
        flash.mode: Camera.FlashRedEyeReduction

        exposure {
            exposureCompensation: -1.0
            exposureMode: Camera.ExposurePortrait
        }

        imageCapture.onImageCaptured: photoPreview.source = preview
    }

    Item {
        height: parent.height / 2
        width: height * 16 / 9

        VideoOutput{

            id: video
            source: cam
            focus: visible
            anchors.fill: parent
            fillMode: VideoOutput.PreserveAspectFit
        }

        Text {
            id: banr
            font.family: font_Genjyuu_XP_bold.name
            text: "UP / DOWN  TO  CHANGE  CAMERA"
            color: "white"
            anchors {
                top: video.top
                left: video.right
                leftMargin: 50
            }
        }

        ListView {
            id: camera_list
            model: QtMultimedia.availableCameras
            anchors {
                top: banr.bottom
                left: video.right
                leftMargin: 50
            }

            highlight: Rectangle {
                color: "transparent"
                border {
                    color: "red"
                    width: 2
                }
            }

            delegate: Rectangle{
                width: 300
                height: 30
                color: "transparent"
                Text {
                    text: modelData.displayName
                    font.family: font_Genjyuu_XP_bold.name
                    anchors.centerIn: parent
                    color: "white"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: cam.deviceId = modelData.deviceId
                    }
                }
            }
        }
    }

    Image{ id: photoPreview }

    Text{
        color: "white"
        font.family: font_Genjyuu_XP_bold.name
        font.pixelSize: 40

        text:"BKSP  TO  RETURN"
    }

    Component.onCompleted:{
        mainqml.bksppress_signal.connect(tomain)
        mainqml.uppress_signal.connect(prev_camera)
        mainqml.downpress_signal.connect(next_camera)
    }

    function tomain(){pageloader.source = "option_menu.qml"}
    function prev_camera() { camera_list.decrementCurrentIndex(); cam.deviceId = camera_list.currentItem.deviceId }
    function next_camera() { camera_list.incrementCurrentIndex(); cam.deviceId = camera_list.currentItem.deviceId }

    Component.onDestruction: {
        mainqml.bksppress_signal.disconnect(tomain)
        mainqml.uppress_signal.disconnect(prev_camera)
        mainqml.downpress_signal.disconnect(next_camera)
    }

    FontLoader { id: font_Genjyuu_XP_bold; source: "qrc:/font/GenJyuuGothicX-P-Bold.ttf" }
}
