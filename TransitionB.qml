import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Particles 2.12
import QtGraphicalEffects 1.0

Item {
    id: transb
    anchors.fill: parent
    property bool is_running: false
    property var transb_text_size: height * 0.05
    visible: false

    Rectangle {
        id: transb_panel
        color: "#222222"
        anchors.fill: parent

        ConicalGradient {
            id: loading_gradient
            anchors.fill: transb_img

            NumberAnimation on angle {
                running: transb.visible
                duration: 4000
                from: 0; to: 360
                loops: Animation.Infinite
            }

            gradient: Gradient {
                GradientStop { position: 0; color: "transparent" }
                GradientStop { position: 0.5; color: global_song_meta ? global_song_meta[5] : "white" }
                GradientStop { position: 0.501; color: "transparent" }
                GradientStop { position: 1; color: global_song_meta ? global_song_meta[5] : "white" }
            }

            layer.enabled: true
            layer.effect: OpacityMask { maskSource: transb_img; invert: true }
        }


        Item {
            id: transb_img
            height: parent.height / 2
            width:  height
            anchors{
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                topMargin: height / 5
            }

            Image {
                anchors.centerIn: parent
                width: height
                height: parent.height * 0.98
                fillMode: Image.PreserveAspectFit
                source: global_song_meta ? "file:///" + global_song_meta[0] + "/jacket" : ""
            }
        }

        Image {
            source: "qrc:/ui/songselect/image/difficulty_frame_" + (global_is_expert ? "expert.png" : "basic.png")
            fillMode: Image.PreserveAspectFit
            width: height * 0.75
            height: transb_img.height / 4
            anchors {
                right: transb_img.right
                top: transb_img.top
            }

            Text {
                text: global_song_meta ? global_song_meta[(global_is_expert ? 7 : 6)] : ""

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

        Item {
            height: parent.height * 0.3
            width: parent.width * 0.75
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.height * 0.1
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top
                }
                height: parent.height * 0.67
                width: parent.width
                text: global_song_meta ? global_song_meta[2] : ""
                font.family: font_Genjyuu_XP_bold.name
                font.pixelSize: height * 0.8
                minimumPixelSize: 10

                fontSizeMode: Text.Fit
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "white"
                style: Text.Raised
                styleColor: "black"
            }

            Text {
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    bottom: parent.bottom
                }
                height: parent.height * 0.33
                width: parent.width
                text: global_song_meta ? global_song_meta[1] : ""
                font.family: font_Genjyuu_XP_bold.name
                font.pixelSize: height * 0.8
                minimumPixelSize: 10

                fontSizeMode: Text.Fit
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "white"
                style: Text.Raised
                styleColor: "black"
            }
        }
    }

    ParticleSystem {
        id: transb_particle_sys

        property double particle_size: parent.height / 40

        anchors.fill: parent
        enabled: transb.visible

        layer.enabled: true
        layer.effect: ColorOverlay { color: global_song_meta ? global_song_meta[5] : "white" }

        ImageParticle {
            anchors.fill: parent
            system: transb_particle_sys
            groups: ["LS", "RS"]

            source: "qrc:/ui/songselect/image/particle.png"
        }

        Emitter {
            height: parent.height
            x: 0
            group: "LS"
            system: transb_particle_sys

            emitRate: 300
            lifeSpan: 1000

            velocity: PointDirection { x: transb_particle_sys.particle_size * 2; xVariation: 10; yVariation: transb_particle_sys.particle_size }
            acceleration: PointDirection { x: transb_particle_sys.particle_size * 10; yVariation: transb_particle_sys.particle_size }

            size: transb_particle_sys.particle_size
            sizeVariation: 5
            endSize: 1
        }

        Emitter {
            height: parent.height
            x: parent.width
            group: "RS"
            system: transb_particle_sys

            emitRate: 300
            lifeSpan: 1000

            velocity: PointDirection { x: -transb_particle_sys.particle_size * 2; xVariation: 10; yVariation: transb_particle_sys.particle_size }
            acceleration: PointDirection { x: -transb_particle_sys.particle_size * 10; yVariation: transb_particle_sys.particle_size }

            size: transb_particle_sys.particle_size
            sizeVariation: 5
            endSize: 1
        }
    }

    Rectangle{
        id: transb_bg
        anchors.fill: parent
        color: "white"
        opacity: 0
    }

    NumberAnimation{
        id: transb_anim
        target: transb_bg
        properties: "opacity"
        from:1
        to:0
        duration: 1000

        onStarted: pageloader.source = ""
    }

    NumberAnimation{
        id: fade_out
        target: transb
        properties: "opacity"
        from: 1
        to: 0
        duration: 1000
        onFinished:{
            transb.visible = false
            transb_particle_sys.stop()
            transb_particle_sys.reset()
        }
    }

    NumberAnimation {
        id: scaling
        target: transb_panel
        properties: "scale"
        from: 1.25; to: 1
        duration: 1000
        easing.type: Easing.OutCubic
    }

    function start() {
        transb_anim.restart()
        scaling.restart()
        transb_particle_sys.restart()
        transb.opacity = 1
        transb.visible = true
        is_running = true
    }

    function quit(){
        fade_out.restart()
    }

    FontLoader {
        id: font_Genjyuu_XP_bold
        source: "/font/GenJyuuGothicX-P-Bold.ttf"
    }

    FontLoader {
        id: font_hemi_head
        source: "/font/hemi-head-bd-it.ttf"
    }

    Component.onCompleted: {
        mainqml.escpress_signal.connect(() => {
            transb_anim.complete()
            scaling.complete()
            transb_particle_sys.stop()
            fade_out.complete()
            transb.visible = false
        })
    }
}

