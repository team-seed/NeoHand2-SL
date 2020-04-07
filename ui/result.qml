import QtQuick 2.12
import QtQuick.Shapes 1.12
import QtGraphicalEffects 1.0
import custom.songselect 1.0

Item {
    property var current_song_meta: dir.content[1]

    property int song_index: 1
    property var songs_meta: dir.content
    property double pulse_bpm: 60
    property string song_color: "white"
    property bool is_expert: true
    property var score: 0987654
    property var best_score: 0
    property color bgcolor: "#778899"

    property var exact_number: 0123
    property var close_number: 4567
    property var break_number: 8907
    property var max_combo: 2345

    CustomSongselect { id: dir }

    // temp background
    Rectangle{
        id: background
        anchors.fill: parent
        color: bgcolor
    }

    // top bar, finalized
    Item {
        id: top_bar
        z: 100
        width: parent.width * 0.5
        height: parent.height * 0.15
        anchors{
            top: parent.top
            left: parent.left
        }

        Image {
            id: topbar_frame
            source: "qrc:/ui/songselect/image/top_bar.png"
            fillMode: Image.PreserveAspectCrop
            horizontalAlignment: Image.AlignRight
            anchors.fill: parent
            mipmap: true
            visible: false
        }

        Item {
            id: topbar_img
            anchors.fill: parent

            Image {
                property double mg: parent.height / 10

                source: "qrc:/ui/songselect/image/top_bar.png"
                fillMode: Image.PreserveAspectCrop
                horizontalAlignment: Image.AlignRight
                anchors.fill: parent
                mipmap: true


                anchors {
                    rightMargin: mg * 3
                }
            }

            visible: false
        }

        OpacityMask {
            id: topbar_masked
            anchors.fill: parent
            source: topbar_frame
            maskSource: topbar_img
            invert: true
            visible: false
            opacity: 0.5
        }

        ColorOverlay {
            id: topbar_light
            anchors.fill: parent
            source: topbar_masked
            color: song_color

            NumberAnimation on opacity {
                id: topbar_light_animation
                duration: 60000 / pulse_bpm
                loops: Animation.Infinite
                from: 0.9
                to: 0.5
                easing.type: Easing.OutCubic
            }
        }

        ColorOverlay{
            id: topbar_overlay
            anchors.fill: topbar_img
            source: topbar_img
            color: "#222222"
        }

        Item {
            id: topbar_text
            anchors.fill: parent
            Text {
                id: topbar_number
                text: "Results"
                anchors.left: parent.left
                anchors.leftMargin: parent.height * 0.35

                color: "white"
                font.family: font_hemi_head.name
                font.pixelSize: parent.height * 0.8
            }
        }

        DropShadow {
            anchors.fill: parent
            source: topbar_text
            horizontalOffset: parent.height * 0.04
            verticalOffset: horizontalOffset
            color: "#666666"
        }

    }

    // jacket_container
    Rectangle{
        id: jacket_container
        width: parent.width * 0.4
        anchors {
            top: top_bar.bottom
            bottom: parent.bottom
            left: parent.left
        }
        color: "gray"

        // jacket
        Image {
            width: parent.width * 0.85
            height: width
            anchors.centerIn: parent

            fillMode: Image.PreserveAspectFit
            source: "file:///" + current_song_meta[0] + "/jacket"
        }
    }

    //  Failed, Clear, Full Combo, Perfect
    //  ==========================!! TO BE REPLACED !!===============================
    /*Rectangle{
        z:101
        height: parent.width * 0.2
        width: parent.height
        anchors{
            bottom: parent.verticalCenter
            left: parent.left
        }
        color: "white"
        transform: Rotation { origin.x: 0; origin.y: 0 ; axis { x: 0; y: 0; z: 1 } angle: 45}
        Text{
            anchors.fill: parent
            text: "CLEAR"
            font.family: font_Genjyuu_XP_bold.name
            font.pixelSize: height
            minimumPixelSize: 10

            fontSizeMode: Text.Fit
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            style: Text.Raised
            styleColor: "black"
        }
    }*/

    ///
    // song_information
    ///
    Item {
        id: song_information
        property double panel_margin: width / 16
        height: parent.height * 0.25
        anchors {
            left: jacket_container.right
            right: parent.right
            top:parent.top
        }

        //bar
        Rectangle {
            id: current_bar

            height: parent.height / 2
            width : parent.width / 50
            anchors{
                top: parent.top
                left: parent.left
                margins: song_information.panel_margin
            }
            color: "#222222"
        }

        // title & artist
        Item {
            anchors {
                top: current_bar.top
                bottom: current_bar.bottom
                right: diff.left
                rightMargin: song_information.panel_margin
                left: current_bar.right
                leftMargin: song_information.panel_margin / 2
            }

            //title
            Text {
                id: current_title
                height: current_artist.height * 2
                width: parent.width

                anchors {
                    top: parent.top
                    left: parent.left
                    //right: parent.right
                }

                text: current_song_meta[2]
                color: "white"
                font.family: font_Genjyuu_XP_bold.name
                font.pixelSize: height
                minimumPixelSize: 10

                fontSizeMode: Text.Fit
                verticalAlignment: Text.AlignVCenter
                style: Text.Raised
                styleColor: "black"
            }

            //artist
            Text {
                id: current_artist

                height: parent.height / 3
                width: parent.width

                anchors {
                    bottom: parent.bottom
                    left: parent.left
                    //right: parent.right
                }

                text: current_song_meta[1]
                color: "white"
                font.family: font_Genjyuu_XP_bold.name
                font.pixelSize: height
                minimumPixelSize: 10

                fontSizeMode: Text.Fit
                verticalAlignment: Text.AlignVCenter
                style: Text.Raised
                styleColor: "black"
            }

        }

        // song difficult
        Image {
            id: diff
            source: "qrc:/ui/songselect/image/difficulty_frame_" +  (is_expert ? "expert.png" : "basic.png")
            //fillMode: Image.PreserveAspectFit
            width : height * 0.6
            height: parent.height
            anchors {
                right: parent.right
                top  : parent.top
            }

            Text {
                text: is_expert ? current_song_meta[7] : current_song_meta[6]

                width: parent.width * 0.7
                height: width

                anchors.right: parent.right
                anchors.top: parent.top

                color: "white"
                horizontalAlignment: Text.AlignHCenter
                font.family: font_hemi_head.name
                font.pixelSize: parent.height * 0.3

            }
        }

    }

    ///
    // score_panel
    ///
    Rectangle {
        id: score_panel
        height: parent.height * 0.25
        anchors{
            top: song_information.bottom
            left: song_information.left
            right: parent.right
            rightMargin:  parent.width / 20
        }
        color: "white"
        // score_txt
        Text {
            id: score_text
            property int cur_score: 0
            anchors.fill:parent
            text: score_panel.scoreStr(cur_score)

            font.family: font_Genjyuu_XP_bold.name
            font.pixelSize: height
            minimumPixelSize: 10

            fontSizeMode: Text.Fit
            verticalAlignment: Text.AlignVCenter
            style: Text.Raised
            styleColor: "black"

            Component.onCompleted:
            {
                cal.start()
            }
            SequentialAnimation
            {
                id:cal
                XAnimator{
                    target: score_panel
                    from:jacket_container.width - score_panel.width
                    to :jacket_container.width - score_panel.width
                    duration: 500
                }
                XAnimator{
                    target: score_panel
                    from: jacket_container.width - score_panel.width
                    to :jacket_container.width - score_panel.width * 0.1
                    duration: 150
                }
                XAnimator{
                    target: score_panel
                    from:jacket_container.width - score_panel.width * 0.1
                    to :song_information.x
                    duration: 200
                }
                NumberAnimation {
                    target: score_text
                    property: "cur_score"
                    duration: 1000
                    from: 0
                    to: score
                    easing.type: Easing.InOutQuad
                }
            }
        }

        function scoreStr(cur_score)    // append 0
        {
           if(cur_score.toString().length>=7)
               return cur_score
           else
               return scoreStr("0"+cur_score)
        }
    }

    ///
    // bottom_panel
    ///
    Item {
        id: bottom_panel
        anchors{
            top: score_panel.bottom
            bottom: parent.bottom
            left: jacket_container.right
            right: parent.right
        }
        // best_score_bar
        Rectangle{
            id:best
            property var top_margin: best.height * 0.7
            height: bottom_panel.height * 0.15
            width: bottom_panel.width * 0.6
            anchors{
                top: bottom_panel.top
                right: bottom_panel.right
            }
            color: "white"
            Text{
                text: "BEST"
                width: parent.width *0.4
                height:  parent.height
                anchors{
                    left: parent.left
                    top: parent.top
                }
                font.family: font_Genjyuu_XP_bold.name
                font.pixelSize: height
                minimumPixelSize: 10

                fontSizeMode: Text.Fit
                verticalAlignment: Text.AlignVCenter
                style: Text.Raised
                styleColor: "black"
            }
            Text{
                id:best_score_txt
                text: best_score.toString().padStart(7, "0")
                width: parent.width * 0.6
                height:  parent.height
                anchors{
                    right: parent.right
                    top: parent.top
                }
                font.family: font_Genjyuu_XP_bold.name
                font.pixelSize: height
                minimumPixelSize: 10

                fontSizeMode: Text.Fit
                verticalAlignment: Text.AlignVCenter
                style: Text.Raised
                styleColor: "black"
            }
            Text{
                id: delta_score
                text: ((score - best_score)>0 ? "+" :"")+(score- best_score)
                height: best_score_txt.height * 0.8
                anchors{
                    top: best_score_txt.bottom
                    left: best_score_txt.left
                    right: best_score_txt.right
                }
                font.family: font_Genjyuu_XP_bold.name
                font.pixelSize: height
                minimumPixelSize: 10

                fontSizeMode: Text.Fit
                verticalAlignment: Text.AlignVCenter
                style: Text.Raised
                styleColor: "black"
            }
        }
        //  exact, close, break
        Column{
            id: result_list
            spacing: height * 0.1
            width: parent.width * 0.4
            anchors{
                top:  parent.top
                bottom: parent.bottom
                left: parent.left
                leftMargin: parent.width * 0.1
                topMargin: parent.height * 0.2
                bottomMargin: parent.height * 0.2
            }
            Text {
                id: exact_txt
                text: "EXACT " + exact_number
                width: parent.width
                height: parent.height/5
                font.family: font_Genjyuu_XP_bold.name
                font.pixelSize: height
                minimumPixelSize: 10

                fontSizeMode: Text.Fit
                verticalAlignment: Text.AlignVCenter
                style: Text.Raised
                styleColor: "black"
            }
            Text{
                id: close_txt
                text: "CLOSE " + close_number
                width: parent.width
                height: parent.height/5
                font.family: font_Genjyuu_XP_bold.name
                font.pixelSize: height
                minimumPixelSize: 10

                fontSizeMode: Text.Fit
                verticalAlignment: Text.AlignVCenter
                style: Text.Raised
                styleColor: "black"
            }
            Text{
                id: break_txt
                text: "BREAK " + break_number
                width: parent.width
                height: parent.height/5

                font.family: font_Genjyuu_XP_bold.name
                font.pixelSize: height
                minimumPixelSize: 10

                fontSizeMode: Text.Fit
                verticalAlignment: Text.AlignVCenter
                style: Text.Raised
                styleColor: "black"
            }
        }
        // max combo
        Text{
            id: combo
            text:"MAX COMBO"
            height: bottom_panel.height * 0.3
            anchors{
                top: best.bottom
                topMargin: best.top_margin
                left: best.left
                right: best.right
            }
            font.family: font_Genjyuu_XP_bold.name
            font.pixelSize: height
            minimumPixelSize: 10

            fontSizeMode: Text.Fit
            verticalAlignment: Text.AlignVCenter
            style: Text.Raised
            styleColor: "black"
        }
        Text{
            text: max_combo
            height: combo.height * 0.7
            anchors{
                top: combo.bottom
                left: combo.left
                leftMargin: combo.width * 0.3
                right: combo.right
            }
            font.family: font_Genjyuu_XP_bold.name
            font.pixelSize: height
            minimumPixelSize: 10

            fontSizeMode: Text.Fit
            verticalAlignment: Text.AlignVCenter
            style: Text.Raised
            styleColor: "black"
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
