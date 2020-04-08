import QtQuick 2.12
import QtQuick.Window 2.12
Item {
    width: Screen.width
    height: Screen.height
    property var transb_text_size: height * 0.05

    Rectangle {
        id: transb_panel
        color: "white"
        anchors.fill: parent
        visible: false

        Image {
            id: transb_img
            height: parent.height / 2
            width:  height
            anchors{
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                topMargin: height / 10
            }
            fillMode: Image.PreserveAspectFit
            source: global_song_meta ? "file:///" + global_song_meta[0] + "/jacket" : ""
        }
        Text {
            id:transb_artist
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: transb_img.bottom
                topMargin: parent.height / 10
            }
            text: global_song_meta ? global_song_meta[2] : ""
            font.family: font_Genjyuu_XP_bold.name
            font.pixelSize: transb_text_size
        }

        Text {
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: transb_artist.bottom
                topMargin: parent.height / 10
            }
            text: global_song_meta ? global_song_meta[1] : ""
            font.family: font_Genjyuu_XP_bold.name
            font.pixelSize: transb_text_size
        }
    }

    Rectangle{
        id: transb_bg
        visible: false
        anchors.fill: parent
        color: "white"
        opacity: 0
    }

    NumberAnimation{
        id:transb_anim
        target: transb_bg
        properties: "opacity"
        from:1
        to:0
        duration: 1000
    }

    NumberAnimation{
        id:fade_out
        target: transb_bg
        properties: "opacity"
        from:0
        to:1
        duration: 1000
        onFinished:{
            transb_bg.visible = false
            transb_panel.visible = false
        }
    }

    function start() {
        transb_bg.visible = true
        transb_panel.visible = true
        transb_anim.start()
    }

    function quit(){
        fade_out.start()
    }

    FontLoader {
        id: font_Genjyuu_XP_bold
        source: "/font/GenJyuuGothicX-P-Bold.ttf"
    }

}

