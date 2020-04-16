import QtQuick 2.12
import QtGraphicalEffects 1.0

Item {
    id: game_panel_container
    anchors.fill: parent

    property double light_opacity: 0.5

    SequentialAnimation on light_opacity {
        loops: Animation.Infinite
        NumberAnimation { duration: 1000; from: 0.5; to: 1.0; easing.type: Easing.InOutSine }
        NumberAnimation { duration: 1000; from: 1.0; to: 0.5; easing.type: Easing.InOutSine }
    }

    Item {
        id: left_panel_light
        anchors.fill: parent
        visible: false

        Image {
            anchors {
                top: parent.top
                left: parent.left
            }

            height: parent.height * 0.2
            width: parent.width / 3

            verticalAlignment: Image.AlignBottom
            horizontalAlignment: Image.AlignRight

            source: "qrc:/ui/game/image/game_data_frame.png"
            fillMode: Image.PreserveAspectCrop

        }

        layer.enabled: true
        layer.effect: OpacityMask { maskSource: left_panel; invert: true }
    }

    OpacityMask {
        anchors.fill: parent
        source: left_panel_light
        maskSource: bottom_outer
        invert: true

        opacity: light_opacity

        layer.enabled: true
        layer.effect: ColorOverlay { color: global_song_meta[5] }
    }

    Item {
        id: left_panel
        anchors.fill: parent

        Image {
            anchors {
                top: parent.top
                left: parent.left
            }

            height: parent.height * 0.2
            width: parent.width / 3

            source: "qrc:/ui/game/image/game_data_frame.png"
            fillMode: Image.PreserveAspectCrop
            verticalAlignment: Image.AlignBottom
            horizontalAlignment: Image.AlignRight

            transform: Scale { xScale: 0.98; yScale: 0.95 }

            layer.enabled: true
            layer.effect: ColorOverlay { color: "#222222" }
        }

        layer.enabled: true
        layer.effect: OpacityMask { maskSource: bottom_outer; invert: true }
    }

    Item {
        id: right_panel_light
        anchors.fill: parent
        visible: false

        Image {
            id: img
            anchors {
                top: parent.top
                right: parent.right
            }

            height: parent.height * 0.2
            width: parent.width / 3

            verticalAlignment: Image.AlignBottom
            horizontalAlignment: Image.AlignLeft

            source: "qrc:/ui/game/image/game_data_frame.png"
            fillMode: Image.PreserveAspectCrop
            mirror: true
        }

        layer.enabled: true
        layer.effect: OpacityMask { maskSource: right_panel; invert: true }
    }

    OpacityMask {
        anchors.fill: parent
        source: right_panel_light
        maskSource: bottom_outer
        invert: true

        opacity: light_opacity

        layer.enabled: true
        layer.effect: ColorOverlay { color: global_song_meta[5] }
    }

    Item {
        id: right_panel
        anchors.fill: parent

        Image {
            id: img2
            anchors {
                top: parent.top
                right: parent.right
            }

            height: parent.height * 0.2
            width: parent.width / 3

            verticalAlignment: Image.AlignBottom
            horizontalAlignment: Image.AlignLeft

            source: "qrc:/ui/game/image/game_data_frame.png"
            fillMode: Image.PreserveAspectCrop

            transform: Scale { origin.x: img.width; xScale: 0.98; yScale: 0.95 }
            mirror: true

            layer.enabled: true
            layer.effect: ColorOverlay { color: "#222222" }
        }

        layer.enabled: true
        layer.effect: OpacityMask { maskSource: bottom_outer; invert: true }
    }

    Text {
        id: score

        anchors {
            right: parent.right
            top: parent.top
            topMargin: parent.height / 15
            rightMargin: parent.width * 0.01
        }

        height: parent.height * 0.13
        width: parent.width * 0.28

        text: current_score.toString().padStart(7, "0")

        color: "#DDDDDD"
        font.family: font_Roboto_Medium.name
        font.pixelSize: height * 0.8
        font.letterSpacing: height * 0.05
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter

        fontSizeMode: Text.Fit

    }

    Item {
        id: diff_meta

        anchors {
            left: parent.left
            top: parent.top
            topMargin: parent.height * 0.08
            leftMargin: parent.width * 0.01
        }

        height: parent.height * 0.09
        width: parent.width * 0.28

        Image {
            id: small_jacket

            anchors.left: parent.left
            anchors.leftMargin: width * 0.2
            height: parent.height
            width: height

            source: "file:///" + global_song_meta[0] + "/jacket"
            fillMode: Image.PreserveAspectFit
        }

        Text {
            id: diff_txt

            anchors.left: small_jacket.right
            anchors.leftMargin: small_jacket.width / 2
            anchors.right: parent.right
            anchors.rightMargin: anchors.leftMargin
            height: parent.height

            text: global_is_expert ? ("EXPERT  " + global_song_meta[7].toString()) : ("BASIC  " + global_song_meta[6].toString())

            color: "#DDDDDD"
            font.family: font_hemi_head.name
            font.pixelSize: height * 0.8
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft

            fontSizeMode: Text.Fit

            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                spread: 0; radius: 0
                horizontalOffset: verticalOffset
                verticalOffset: diff_txt.height * 0.02
                color: global_is_expert ? "#bf3030" : "#32a632"
            }
        }

    }

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
                anchors.left: parent.left

                width: parent.width / 2

                source: "qrc:/ui/songselect/image/top_bar.png"
                fillMode: Image.PreserveAspectFit
                mirror: true
            }
        }
    }

    Item {
        id: bottom_outer
        anchors.fill: parent

        visible: false

        Loader {
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter

            width: parent.width
            height: parent.height / 15

            sourceComponent: top_bar_base
        }
    }

    Item {
        id: bottom_inner
        anchors.fill: parent

        visible: false

        Loader {
            sourceComponent: top_bar_base
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter

            width: parent.width * 0.9825
            height: parent.height / 15 * 0.875
        }
    }

    Item {
        id: top_outer
        anchors.fill: parent

        Loader {
            sourceComponent: top_bar_base
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter

            width: parent.width / 2
            height: parent.height / 15
        }

        visible: false
    }

    Item {
        id: top_inner
        anchors.fill: parent

        visible: false

        Loader {
            sourceComponent: top_bar_base
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter

            width: parent.width / 2 * 0.965
            height: parent.height / 15 * 0.875
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

        opacity: light_opacity

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
            height: parent.height / 18
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

    FontLoader {
        id: font_Roboto_Medium
        source: "/font/Roboto-Medium.ttf"
    }

    FontLoader {
        id: font_hemi_head
        source: "/font/hemi-head-bd-it.ttf"
    }
}
