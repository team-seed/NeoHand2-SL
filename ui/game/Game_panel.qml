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
                clip: true
                anchors.top: parent.top
                anchors.right: parent.right
                horizontalAlignment: Image.AlignRight

                width: parent.width / 2 + 1

                source: "qrc:/ui/songselect/image/top_bar.png"
                fillMode: Image.PreserveAspectCrop
            }

            Image {
                clip: true
                anchors.top: parent.top
                anchors.left: parent.left
                horizontalAlignment: Image.AlignRight
                width: parent.width / 2 + 1

                source: "qrc:/ui/songselect/image/top_bar.png"
                fillMode: Image.PreserveAspectCrop
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

    Item {
        id: health_bar
        width: parent.height * 0.65
        height: parent.height / 15
        anchors{
            top: parent.bottom
            topMargin: - parent.height / 8
            right: parent.right
        }

        Item{
            anchors.fill: parent
            Rectangle{
                id: health
                width: parent.width * (current_health / max_health)
                height: parent.height
                anchors{
                    top: parent.top
                    right: parent.right
                }
                gradient: Gradient{
                    GradientStop{position: 0; color: "#999999"}
                    GradientStop{position: 0.3; color: (current_health >= pass_threshold) ? "orangered" : "deepskyblue"}
                }

                Behavior on width {
                    NumberAnimation { duration: 100 }
                }
            }

            layer.enabled: true
            layer.effect: OpacityMask{
                maskSource: inner_health_bar
            }
        }

        Item {
            id:health_bar_bg
            anchors.fill: parent
            Image {
                width: parent.width * 2
                height: parent.height
                anchors{
                    top: parent.top
                    left:parent.left
                }
                source: "qrc:/ui/songselect/image/second_layer_delegate_decoration.png"
                fillMode: Image.TileHorizontally
                sourceSize.height: height
                sourceSize.width: width / 16
                verticalAlignment: Image.AlignVCenter
                horizontalAlignment: Image.AlignHCenter
                opacity: 0.5
                mirror: true
                NumberAnimation on anchors.leftMargin{
                    loops: Animation.Infinite
                    from: 0
                    to: - health_bar.width
                    duration: 10000
                    //running: false
                }
                layer.enabled: true
                layer.effect: ColorOverlay{
                    color: "gray"
                }
            }
            layer.enabled: true
            layer.effect: OpacityMask{
                maskSource: inner_health_bar
            }
        }

        Item {
            id: outer_health_bar
            anchors.fill: parent
            Item {
                anchors{
                    top: parent.top
                    left: parent.left
                }
                width: parent.width * 0.3
                height: parent.height
                Loader {
                    sourceComponent: top_bar_base
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    width: parent.width
                    height: parent.height / 2
                }
                Rectangle{
                    anchors.top: parent.top
                    anchors.left: parent.left
                    width: parent.width
                    height: parent.height / 2
                }
            }

            Item {
                anchors{
                    top: parent.top
                    right: parent.right
                }
                width: parent.width * 0.7
                height: parent.height * 0.7
                Loader {
                    sourceComponent: top_bar_base
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    width: parent.width
                    height: parent.height * 2 / 7
                }
                Rectangle{
                    anchors.top: parent.top
                    anchors.left: parent.left
                    width: parent.width
                    height: parent.height * 5 / 7
                }
            }
            layer.enabled: true
            layer.effect: OpacityMask{
                invert: true
                maskSource: inner_health_bar
                layer.enabled: true
                layer.effect: LinearGradient{
                    gradient: Gradient{
                        orientation: Gradient.Horizontal
                        GradientStop{position: 1;color:"red"}
                        GradientStop{position: 0.3;color:"orange"}
                        GradientStop{position: 0;color:"green"}
                    }
                }
            }

            opacity: 1 //light_opacity

        }

        Item {
            id: inner_health_bar
            anchors.fill: parent
            antialiasing: true
            Item {
                anchors{
                    top: parent.top
                    right: parent.left
                    rightMargin: -parent.width * 0.295
                }
                width: parent.width * 0.275
                height: parent.height * 0.8
                Loader {
                    sourceComponent: top_bar_base
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    width: parent.width
                    height: parent.height / 2
                }
                Rectangle{
                    anchors.top: parent.top
                    anchors.left: parent.left
                    width: parent.width
                    height: parent.height / 2
                }
            }

            Item {
                anchors{
                    top: parent.top
                    left: parent.right
                    leftMargin: -parent.width * 0.695
                }
                width: parent.width * 0.675
                height: parent.height * 0.48
                Loader {
                    sourceComponent: top_bar_base
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    width: parent.width
                    height: parent.height * 0.4
                }
                Rectangle{
                    anchors.top: parent.top
                    anchors.left: parent.left
                    width: parent.width
                    height: parent.height * 0.6
                }
            }

            layer.enabled: true
            layer.effect: ColorOverlay{
                color: "red"
            }
            visible: false
        }


        Text {
            height: parent.height / 2
            anchors{
                top: parent.bottom
                topMargin: -parent.height * 0.4
                left: parent.left
                leftMargin: parent.width * 0.35
            }
            text: "HEALTH BAR"
            font.pixelSize: height * 0.8
            font.family: font_hemi_head.name

            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            color: "#999999"
            rotation: 180
        }

        transformOrigin: Item.TopRight
        rotation: 90
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
