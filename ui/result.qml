import QtQuick 2.12
import QtQuick.Shapes 1.12
import QtGraphicalEffects 1.0
import custom.songselect 1.0
import QtQuick.Particles 2.12
Item {
    property var current_song_meta: dir.content[1]

    property int song_index: 1
    property var songs_meta: dir.content
    property double pulse_bpm: 60
    property string song_color: mainqml.global_song_meta ? mainqml.global_song_meta[5] : "white"
    property bool is_expert: true
    property string text_color: "#DDDDDD"


    property var score: 0987654
    property var best_score: 999999
    property color bgcolor: "#222222"

    property var exact_number: 123
    property var close_number: 4567
    property var break_number: 8907
    property var max_combo: 2345

    CustomSongselect { id: dir }

    // temp background

    ParticleSystem {
        id: particle_sys
        anchors.fill: parent

        layer.enabled: true
        layer.effect: ColorOverlay { color: song_color }

        ImageParticle {
            anchors.fill: parent
            system: particle_sys
            groups: ["R"]

            source: "qrc:/ui/songselect/image/particle2.png"
        }

        Emitter {

            id: glow
            system: particle_sys
            group: "R"

            x: 0
            height: 1 //parent.height / 20
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -parent.height / 4

            emitRate: 300

            lifeSpan: 5000

            onEmitParticles: {
                for (var i = 0; i<particles.length; i++) {
                    var particle = particles[i]
                    var rand = Math.random()

                    particle.startSize = Math.floor(rand * 5) * 5 + 15
                    particle.endSize = particle.startSize
                    particle.alpha = 0.6 - rand * 0.3
                    particle.x = particle_sys.width * ((1 - rand) * -0.2)
                    particle.initialVX = particle_sys.width * (rand * 0.04 + 0.25)
                    particle.initialVY = particle_sys.height * ((rand * 0.4) + 0.1)

                }
            }
        }

        Affector {
            system: particle_sys
            groups: ["R"]
            anchors.fill: parent
            onAffectParticles: {
                for (var i = 0; i<particles.length; i++) {
                    var particle = particles[i]
                    particle.ay = (particle_sys.height / 4 - particle.y) * 20 + particle.x * 6
                    particle.update = true
                }
            }
        }
    }

    Rectangle{
        id: background
        anchors.fill: parent
        opacity: 0.75
        color: "#222222"
    }
    // top bar, finalized
    Item {
        id: top_bar
        z: 100
        width: parent.width * 0.45
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
            color: "white"

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

    // song difficult
    Image {
        id: diff
        source: "qrc:/ui/songselect/image/difficulty_frame_" +  (is_expert ? "expert.png" : "basic.png")
        //fillMode: Image.PreserveAspectFit
        width : height * 0.6
        height: parent.height / 4
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

            color: text_color
            horizontalAlignment: Text.AlignHCenter
            font.family: font_hemi_head.name
            font.pixelSize: parent.height * 0.3

        }
    }
    // jacket_container
    Item{
        id: jacket_container
        width: parent.width * 0.4
        height: parent.height - top_bar.height
        anchors {
            bottom: parent.bottom
            left: parent.left
        }

        // jacket
        Image {
            width: parent.width * 0.85
            height: width
            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
                horizontalCenterOffset:  parent.width * 0.025
            }

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

    //Right panel
    Item {
        property double panel_margin: width / 16
        height: parent.height
        width: parent.width * 0.6
        anchors{
            top: parent.top
            right: parent.right
        }

        ///
        // song_information
        ///
        Item {
            id: song_information

            height: parent.height * 0.125
            width: parent.width * 0.8
            anchors {
                left: parent.left
                top:parent.top
                topMargin: parent.panel_margin * 1.75
                leftMargin: parent.panel_margin * 1.5
            }

            //bar
            Rectangle {
                id: current_bar
                height: parent.height
                width : parent.width / 50
                anchors{
                    top: parent.top
                    left: parent.left
                }
                color: song_color
            }

            // title & artist
            Item {
                height: parent.height
                width: parent.width * 0.8
                anchors {
                    top: current_bar.top
                    left: current_bar.right
                    leftMargin: parent.parent.panel_margin / 2
                }
                //title
                Text {
                    id: current_title
                    height: current_artist.height * 2
                    width: parent.width
                    anchors {
                        top: parent.top
                        left: parent.left
                    }
                    text: current_song_meta[2]
                    color: text_color
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
                    color: text_color
                    font.family: font_Genjyuu_XP_bold.name
                    font.pixelSize: height
                    minimumPixelSize: 10

                    fontSizeMode: Text.Fit
                    verticalAlignment: Text.AlignVCenter
                    style: Text.Raised
                    styleColor: "black"
                }

            }
        }

        ///
        // score_panel
        ///
        Item {
            id: score_panel
            height: parent.height * 0.25
            width: parent.width * 0.91
            layer.enabled: true
            layer.effect: OpacityMask{
                maskSource: mask_rec
            }
            anchors{
                top: song_information.bottom
                topMargin: parent.panel_margin * 0.75
                left: parent.left
            }
            Item {
                id: s_panel
                height: parent.height
                width: parent.width
                anchors{
                    top: parent.top
                    right: parent.right
                }
                Image {
                    id: score_panel_img
                    source: "qrc:/ui/songselect/image/result_score_frame.png"
                    anchors.fill: parent
                    fillMode: Image.Stretch
                    horizontalAlignment: Image.AlignLeft
                    visible: false
                }
                LinearGradient{
                    anchors.fill: score_panel_img

                    gradient: Gradient{
                        orientation: Gradient.Horizontal
                        GradientStop{ position: 1; color: song_color }
                        GradientStop{ position: 0.1; color: "#222222"}
                        GradientStop{ position: 0; color: "transparent" }
                    }
                    opacity: 0.5
                    layer.enabled: true
                    layer.effect: OpacityMask{

                        maskSource : score_panel_img
                    }
                }

                // score_txt
                Text {
                    id: score_text
                    property int cur_score: 0
                    anchors.fill:parent
                    text: parent.scoreStr(cur_score)
                    color: text_color

                    font.family: font_Roboto_Medium.name
                    font.pixelSize: height
                    minimumPixelSize: 10

                    fontSizeMode: Text.Fit
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    style: Text.Raised
                }

                SequentialAnimation
                {
                    id:cal
                    loops: 1
                    NumberAnimation{
                        target: s_panel
                        property: "anchors.rightMargin"
                        from: score_panel.width
                        to : 0
                        duration: 500
                        easing.type: Easing.OutExpo
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

                function scoreStr(cur_score)    // append 0
                {
                   if(cur_score.toString().length>=7)
                       return cur_score
                   else
                       return scoreStr("0"+cur_score)
                }
            }

        }
        //score panel mask
        Item {
            id: mask_rec
            anchors.fill: score_panel
            visible: false
            Rectangle{
                height: parent.height
                width: parent.width
                anchors.left: parent.left
                anchors.top: parent.top
            }
        }

        // best_score_bar
        Item{
            id:best
            height: parent.height * 0.05
            width: parent.width * 0.5
            anchors{
                top: score_panel.bottom
                right: parent.right
                rightMargin:  parent.parent.width / 12.28
            }
            Item{
                width: parent.width / 1.5
                height: parent.height * 2
                transform: Rotation { origin.x: best.width / 2; axis { x:0; y:1; z:0 } angle: 180}
                Image {
                    id: delta_score_bg
                    source: "qrc:/ui/songselect/image/top_bar.png"
                    fillMode: Image.PreserveAspectCrop
                    horizontalAlignment: Image.AlignRight
                    anchors.fill: parent
                }
                ColorOverlay{
                    anchors.fill: parent
                    source: delta_score_bg
                    color: "#444444"
                }

            }
            Item{
                anchors.fill: parent
                transform: Rotation { origin.x: best.width / 2; axis { x:0; y:1; z:0 } angle: 180}
                Image {
                    id: best_score_bg
                    source: "qrc:/ui/songselect/image/top_bar.png"
                    fillMode: Image.PreserveAspectCrop
                    horizontalAlignment: Image.AlignRight
                    anchors.fill: parent
                }
                ColorOverlay{
                    id:tmp
                    anchors.fill: parent
                    source: best_score_bg
                    color: "#b82523"
                }
                ColorOverlay{
                    anchors.fill: parent
                    source: tmp
                    color: "#222222"
                    opacity: 0.5
                }
            }

            Text{
                text: "BEST"
                width: parent.width * 0.4
                height:  parent.height
                anchors{
                    right: parent.right
                    rightMargin: width * 1.55
                    top: parent.top
                }
                color: text_color
                font.family: font_Roboto_Medium.name
                font.pixelSize: height
                minimumPixelSize: 10

                fontSizeMode: Text.Fit
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
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
                color: text_color
                font.family: font_Roboto_Medium.name
                font.pixelSize: height
                font.letterSpacing: width / 50
                minimumPixelSize: 10

                fontSizeMode: Text.Fit
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
                style: Text.Raised
                styleColor: "black"
            }

            Text{
                id: delta_score
                text: ((score >= best_score) ? "+" :"-") + Math.abs(score- best_score).toString().padStart(7,"0")
                height: parent.height
                anchors{
                    top: best_score_txt.bottom
                    left: best_score_txt.left
                    right: best_score_txt.right
                }
                color: text_color
                font.family: font_Roboto_Medium.name
                font.letterSpacing: width / 50
                font.pixelSize: height
                minimumPixelSize: 10

                fontSizeMode: Text.Fit
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
                style: Text.Raised
                styleColor: "black"
            }
        }

        //  exact, close, break
        Row {
            id:detail_row
            height: parent.height * 0.325
            width: parent.width * 0.125
            spacing: 0//height * 0.05
            anchors{
                top:  score_panel.bottom
                topMargin: parent.panel_margin
                left: parent.left
                leftMargin: parent.panel_margin * 1.5
            }
            Column{
                id: result_list
                spacing: height * 0.1
                height: parent.height
                width: parent.width
                anchors{
                    top:  parent.top
                }
                Text {
                    id: exact_txt
                    text: "EXACT "
                    height: parent.height/5
                    color: text_color
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
                    text: "CLOSE "
                    height: parent.height/5
                    color: text_color
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
                    text: "BREAK "
                    height: parent.height/5

                    color: text_color
                    font.family: font_Genjyuu_XP_bold.name
                    font.pixelSize: height
                    minimumPixelSize: 10

                    fontSizeMode: Text.Fit
                    verticalAlignment: Text.AlignVCenter
                    style: Text.Raised
                    styleColor: "black"
                }
            }
            Column{
                spacing: height * 0.1
                height: parent.height
                width: parent.width
                anchors{
                    top: parent.top
                }
                Text {
                    text:  exact_number
                    height: parent.height/5
                    width: parent.width
                    color: text_color
                    font.family: font_Genjyuu_XP_bold.name
                    font.pixelSize: height
                    minimumPixelSize: 10

                    fontSizeMode: Text.Fit
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                    style: Text.Raised
                    styleColor: "black"
                }
                Text {
                    text:  close_number
                    height: parent.height/5
                    width: parent.width
                    color: text_color
                    font.family: font_Genjyuu_XP_bold.name
                    font.pixelSize: height
                    minimumPixelSize: 10

                    fontSizeMode: Text.Fit
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                    style: Text.Raised
                    styleColor: "black"
                }
                Text {
                    text:  break_number
                    height: parent.height/5
                    width: parent.width
                    color: text_color
                    font.family: font_Genjyuu_XP_bold.name
                    font.pixelSize: height
                    minimumPixelSize: 10

                    fontSizeMode: Text.Fit
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                    style: Text.Raised
                    styleColor: "black"
                }
            }
        }

        // max combo
        Text{
            id: combo
            text:"MAX COMBO"
            height: parent.height * 0.1
            anchors{
                bottom: combo_score.top
                right: best.right
            }
            color: text_color
            font.family: font_Genjyuu_XP_bold.name
            font.pixelSize: height * 0.6
            minimumPixelSize: 10

            fontSizeMode: Text.Fit
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
            style: Text.Raised
            styleColor: "black"
        }
        Text{
            id: combo_score
            text: max_combo
            height: combo.height * 1.1
            anchors{
                bottom: detail_row.bottom
                bottomMargin: parent.panel_margin / 1.5
                right: combo.right
            }
            color: text_color
            font.family: font_Genjyuu_XP_bold.name
            font.pixelSize: height
            minimumPixelSize: 10

            fontSizeMode: Text.Fit
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
            style: Text.Raised
            styleColor: "black"
        }
    }

    FontLoader {
        id: font_Roboto_Medium
        source: "/font/Roboto-Medium.ttf"
    }

    FontLoader {
        id: font_Genjyuu_XP_bold
        source: "/font/GenJyuuGothicX-P-Bold.ttf"
    }

    FontLoader {
        id: font_hemi_head
        source: "/font/hemi-head-bd-it.ttf"
    }

    function select(){
        cal.restart()
        //change_page("qrc:/ui/songselect/songselect_main.qml")
    }

    function to_main(){
        Qt.quit()
    }

    function disconnect_all (){
        mainqml.enterpress_signal.disconnect(select)
        mainqml.escpress_signal.disconnect(to_main)
    }
    Component.onCompleted:{
        mainqml.enterpress_signal.connect(select)
        mainqml.escpress_signal.connect(to_main)
        cal.start()
    }
    Component.onDestruction: {
        disconnect_all();
    }
}
