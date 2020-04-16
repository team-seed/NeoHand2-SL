import QtQuick 2.12
import QtGraphicalEffects 1.0

Item {
    anchors.fill: parent

    Component {
        id: top_bar_base

        Item {
            clip: true
            //visible: false

            Image {
                anchors.top: parent.top
                anchors.right: parent.right

                width: parent.width / 2

                source: "qrc:/ui/songselect/image/top_bar.png"
                fillMode: Image.PreserveAspectFit
            }

            Image {
                anchors.top: parent.top
                anchors.right: parent.right

                width: parent.width / 2

                source: "qrc:/ui/songselect/image/top_bar.png"
                fillMode: Image.PreserveAspectFit

                transform: Rotation { axis: Qt.vector3d(0, 1, 0); angle: 180 }
            }
        }
    }

    Item {
        id: bottom_outer
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter

        width: parent.width
        height: parent.height / 15

        visible: false

        Loader {
            sourceComponent: top_bar_base
            anchors.fill: parent
        }
    }

    Item {
        id: bottom_inner
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter

        visible: false

        width: parent.width
        height: parent.height / 15

        Loader {
            sourceComponent: top_bar_base
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter

            width: parent.width * 0.9825
            height: parent.height * 0.875
        }
    }

    Item {
        id: top_outer
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter

        width: parent.width
        height: parent.height / 15

        Loader {
            sourceComponent: top_bar_base
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter

            width: parent.width / 2
            height: parent.height
        }

        visible: false
    }

    Item {
        id: top_inner
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter

        width: parent.width
        height: parent.height / 15

        visible: false

        Loader {
            sourceComponent: top_bar_base
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter

            width: parent.width / 2 * 0.965
            height: parent.height * 0.875
        }
    }

    OpacityMask {
        id: inner_light
        anchors.fill: source
        source: top_outer
        maskSource: top_inner
        invert: true

        visible: false
    }

    OpacityMask {
        id: content_panel
        anchors.fill: source
        source: bottom_inner
        maskSource: inner_light
        invert: true

        layer.enabled: true
        layer.effect: ColorOverlay { color: "#222222" }
    }

    OpacityMask {
        id: content_panel_light
        anchors.fill: source
        source: bottom_outer
        maskSource: content_panel
        invert: true

        SequentialAnimation on opacity {
            loops: Animation.Infinite
            NumberAnimation { duration: 1000; from: 0.5; to: 1.0; easing.type: Easing.InOutSine }
            NumberAnimation { duration: 1000; from: 1.0; to: 0.5; easing.type: Easing.InOutSine }
        }

        layer.enabled: true
        layer.effect: ColorOverlay { color: global_song_meta[5] }
    }

    Text {
        id: track_counter

        height: parent.height / 18
        width: parent.width / 5

        anchors {
            left: parent.left
            leftMargin: parent.width * 0.04
            top: parent.top
        }


        text: switch (global_track_count) {
              case 0: return "Event Mode"
              case 1: return "1st track"
              case 2: return "2nd track"
              case 3: return "3rd track"
              case 4: return "EX track"
              }

        color: "#999999"
        font.family: font_Genjyuu_XP_bold.name
        font.pixelSize: height * 0.8
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

    }

    Text {
        id: hispeed_marker

        height: parent.height / 18
        width: parent.width / 5

        anchors {
            right: parent.right
            rightMargin: parent.width * 0.04
            top: parent.top
        }


        text: "HiSpeed x" + hispeed.toFixed(1).toString()

        color: "#999999"
        font.family: font_Genjyuu_XP_bold.name
        font.pixelSize: height * 0.8
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

    }

    Item {
        id: title_and_artist
        anchors.fill: top_inner

        Text {
            id: txt
            height: parent.height * 5 / 6
            text: global_song_meta[2] + " / " + global_song_meta[1]
            font.family: font_Genjyuu_XP_bold.name
            font.pixelSize: height * 0.8
            color: "#DDDDDD"

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: 0

            NumberAnimation on anchors.horizontalCenterOffset {
                running: txt.width > title_and_artist.width * 0.45
                loops: Animation.Infinite
                from: (title_and_artist.width / 2 + txt.width) / 2 ; to: -from
                duration: txt.width * 20
            }
        }

        layer.enabled: true
        layer.effect: OpacityMask { maskSource: top_inner; }
    }

    FontLoader {
        id: font_Genjyuu_XP_bold
        source: "/font/GenJyuuGothicX-P-Bold.ttf"
    }
}
