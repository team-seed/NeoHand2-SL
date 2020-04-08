import QtQuick 2.12
import QtGraphicalEffects 1.0

import "game_extension.js" as EXT

Item {
    id: game_metadata

    property alias meta__: game_metadata_background

    anchors.fill: parent

    Rectangle {
        id: marquee_mask
        visible: false

        anchors.fill: song_title
    }

    Rectangle {
        id: marquee_mask_2
        visible: false

        anchors.fill: song_artist
    }

    Rectangle {
        id: game_metadata_background
        opacity: 0.6

        width: parent.width

        anchors {
            top: parent.top
            left: parent.left
            bottom: song_jacket.bottom
            bottomMargin: -20
            right: difficulty_frame.right
            rightMargin: -50
        }

        gradient: Gradient {
            orientation: Gradient.Horizontal

            GradientStop { position: 0.9; color: "#AAAAAA" }
            GradientStop { position: 1.0; color: "transparent" }
        }
    }

    Rectangle {
        id: meta_bar
        color: "#222222"
        width: 10

        anchors {
            top: song_title.top
            bottom: song_artist.bottom
            left: game_metadata.left
            leftMargin: 20
        }
    }

    Item {
        id: song_title
        anchors {
            top: game_metadata.top
            topMargin: 20
            leftMargin: 20
            left: meta_bar.right
            right: meta__.right
        }

        height: parent.height / 15

        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: marquee_mask
        }

        Text {
            id: ttt
            text: title
            color: "white"
            font.family: font_Genjyuu_XP_bold.name
            font.pixelSize: parent.height * 0.75
            anchors.verticalCenter: parent.verticalCenter
            //x: 0

            style: Text.Raised
            styleColor: "#222222"
            NumberAnimation {
                target: ttt
                running: EXT.long(ttt.width)
                property: "x"
                loops: Animation.Infinite
                duration: ttt.width * 12.5
                from: EXT.long(ttt.width) ? meta__.width : 0
                to: -ttt.width
            }
        }
    }

    Item {
        id: song_artist
        anchors {
            top: song_title.bottom
            topMargin: 20
            leftMargin: 20
            left: meta_bar.right
            right: meta__.right
        }

        height: parent.height / 27

        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: marquee_mask_2
        }

        Text {
            id: aaa
            text: artist
            color: "white"
            font.family: font_Genjyuu_XP_bold.name
            font.pixelSize: parent.height * 0.75
            anchors.verticalCenter: parent.verticalCenter

            style: Text.Raised
            styleColor: "#222222"
            NumberAnimation {
                target: aaa
                property: "x"
                loops: Animation.Infinite
                duration: aaa.width * 15
                from: EXT.long(aaa.width) ? meta__.width : 0
                to: -aaa.width
                running: EXT.long(aaa.width)
            }
        }
    }

    Image {
        id: song_jacket
        source: jacket
        height: parent.height / 6
        width: this.height
        fillMode: Image.PreserveAspectFit
        anchors {
            top: song_artist.bottom
            left: parent.left
            topMargin: 20
            leftMargin: 20
        }
    }

    Rectangle {
        id: difficulty_frame
        color: expert ? "firebrick" : "forestgreen"
        radius: this.height / 2
        height: game_metadata_background.height / 10
        width: difficulty_content.width + this.height
        anchors {
            top: song_jacket.top
            left: song_jacket.right
            leftMargin: 20
        }
    }

    Item {
        id: difficulty_content
        width: difficulty_name.width + difficulty_level.width + 20

        anchors.centerIn: difficulty_frame

        Text {
            id: difficulty_name
            text: difficulty
            color: "white"
            font.family: font_hemi_head.name
            font.pixelSize: difficulty_frame.height * 0.8

            anchors {
                verticalCenter: parent.verticalCenter
                left: parent.left
            }
        }

        Text {
            id: difficulty_level
            text: level.toString()
            color: "white"
            font.family: font_hemi_head.name
            font.pixelSize: difficulty_name.font.pixelSize

            anchors {
                verticalCenter: parent.verticalCenter
                left: difficulty_name.right
                leftMargin: 20
            }
        }
    }

    Text {
        id: song_bpm
        text: "BPM  " + bpm.toString()
        color: "white"
        font.family: font_hemi_head.name
        font.pixelSize: difficulty_name.font.pixelSize

        anchors {
            horizontalCenter: difficulty_frame.horizontalCenter
            //left: song_jacket.right
            topMargin: 20
            top: difficulty_frame.bottom
            //leftMargin: 20
        }
    }

    Text {
        id: hi_speed
        text: "HiSpeed  " + hispeed.toString() + "x"
        color: "white"
        font.family: font_hemi_head.name
        font.pixelSize: difficulty_name.font.pixelSize

        anchors {
            horizontalCenter: difficulty_frame.horizontalCenter
            //left: song_jacket.right
            topMargin: 10
            top: song_bpm.bottom
            //leftMargin: 20
        }
    }

    Rectangle {
        id: game_scoreboard

        opacity: 0.6

        width: meta__.width * 1.2
        height: meta__.height * 0.75

        anchors {
            right: parent.right
            top: parent.top
        }

        gradient: Gradient {
            orientation: Gradient.Horizontal

            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 0.1; color: "#AAAAAA" }
        }
    }

    Text {
        id: current_score
        text: score.numberFormat(0, '', ',')
        color: "white"
        style: Text.Raised
        styleColor: "#222222"

        font.family: font_hemi_head.name
        font.pixelSize: game_scoreboard.height / 3

        anchors {
            top: game_scoreboard.top
            right: game_scoreboard.right
            topMargin: 30
            rightMargin: 30
        }
    }

    Text {
        id: high_score
        text: "MYBEST  " + mybest.numberFormat(0, '', ',')
        color: "white"
        style: Text.Raised
        styleColor: "#222222"

        font.family: font_hemi_head.name
        font.pixelSize: current_score.font.pixelSize / 2

        anchors {
            right: game_scoreboard.right
            bottom: game_scoreboard.bottom
            rightMargin: 40
            bottomMargin: 30
        }
    }

    FontLoader {
        id: font_Genjyuu_XP_bold
        source: "/font/GenJyuuGothicX-P-Bold.ttf"
    }

    FontLoader {
        id: font_hemi_head
        source: "/font/hemi-head-bd-it.ttf"
    }
}
