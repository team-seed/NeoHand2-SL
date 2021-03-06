import QtQuick 2.12
import QtGraphicalEffects 1.0
Item {
    id:transA
    anchors.fill: parent
    visible: false
    property bool is_running: false
    property double len: Math.sqrt(Math.pow(width,2) + Math.pow(height,2))

    property double marg: len
    property double ang: 0
    property double gra_end: 0

    property alias end_anim: end_anim

    property var index: [
        "You'll get better response from your camera by swiping your hands gently.",
        "Keep your hands open to catch HOLD notes.",
        "You can catch all the notes with either your right or left hand.",
        "Open your hand at the correct timing to catch CLICK notes.",
        "Welcome to NeoHand.\nWe wish you a pleasant gameplay experience.",
        "Good luck! We believe in you and your hands.",
        "If you can't achieve great score, take a rest. It should help.",
        "Can't hit SWIPE notes?\nTry to move your camera closer or further.",
        "You can go back to the options menu at any time by hitting ESC.",
        "Starting from BASIC difficulties is recommended if you're new to this game."
    ]

    //bg
    Item {
        anchors.centerIn: parent
        height: len
        width: height
        //right
        Item {
            height: parent.height
            width: height
            //color: "deepskyblue"
            anchors.left: parent.horizontalCenter
            anchors.leftMargin: marg
            Rectangle{
                height: parent.height
                width: height / 400
                anchors.left: parent.left
                gradient:Gradient{
                    GradientStop{position: gra_end+0.5;color:"#222222"}
                    GradientStop{position: gra_end+0.501;color:"transparent"}
                    GradientStop{position: 0.5;color:"transparent"}
                    GradientStop{position: -gra_end+0.499;color:"transparent"}
                    GradientStop{position: -gra_end+0.5;color:"#222222"}
                }
            }
            ConicalGradient {
                anchors.fill: parent
                horizontalOffset: - width * 2
                verticalOffset: - height / 2
                gradient: Gradient{
                    //orientation: Gradient.Vertical
                    GradientStop{ position: 1; color: "#ff5555" }
                    GradientStop{ position: 0.667; color: "#6666bb"}
                    GradientStop{ position: 0.334; color: "#66cc66" }
                    GradientStop{ position: 0; color: "#ff5555" }
                }
                NumberAnimation on angle {
                    running: transA.visible
                    duration: 15000
                    from: 0
                    to: 360
                    loops: Animation.Infinite
                }
            }
        }
        //left
        Rectangle {
            height: parent.height
            width: height
            color: "#222222"
            anchors.right: parent.horizontalCenter
            anchors.rightMargin: marg
            Rectangle{
                height: parent.height
                width: height / 400
                anchors.right: parent.right
                gradient:Gradient{
                    GradientStop{position: gra_end+0.5;color:"white"}
                    GradientStop{position: gra_end+0.501;color:"transparent"}
                    GradientStop{position: 0.5;color:"transparent"}
                    GradientStop{position: -gra_end+0.499;color:"transparent"}
                    GradientStop{position: -gra_end+0.5;color:"white"}
                }
            }
        }
        rotation: ang
    }
    //logo
    Image {
        id: logo
        source: "qrc:/ui/songselect/image/neohand2logoonly.png"
        fillMode: Image.PreserveAspectFit
        width: transA.width * 0.5
        anchors{
            top: transA.top
            topMargin: parent.height * 0.05
            left: transA.left
            leftMargin: -width
        }
    }
    //tips
    Rectangle{
        id: tip_box
        width: transA.width / 3
        height: transA.height / 4
        anchors{
            bottom: transA.bottom
            bottomMargin: parent.height * 0.05
            right: transA.right
            rightMargin: - width * 1.2
        }
        color: "#222222"
        opacity: 0.3

        Text {
            id: tip_txt
            //width: parent.width
            //height: parent.height
            anchors.fill: parent
            anchors.margins: parent.height * 0.1

            color: "white"
            font.family: font_Genjyuu_XP_bold.name
            font.pixelSize: parent.height * 0.12
            fontSizeMode: Text.Fit
            wrapMode: Text.Wrap
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            text: index[0]

            opacity: 0
        }
    }
    Rectangle{
        id: tip_bg
        height: tip_box.height
        width: tip_box.width / 100
        color: "#222222"
        anchors{
            right: tip_box.left
            top: tip_box.top
        }
        layer.enabled: true
        layer.effect:LinearGradient{
            start: Qt.point(0,0)
            end: Qt.point(tip_bg.width,tip_bg.height)
            gradient: Gradient{
                GradientStop{ position: 1; color: "transparent" }
                GradientStop{
                    color: "pink"
                    SequentialAnimation on position{
                        running: transA.visible
                        loops: Animation.Infinite
                        NumberAnimation {
                            duration: 1000
                            from: 0
                            to: 1
                        }
                        NumberAnimation {
                            duration: 1000
                            from: 1
                            to: 0
                        }
                    }
                }
                GradientStop{ position: 0; color: "transparent" }
            }

            layer.enabled: true
            layer.effect: HueSaturation {
                lightness: 0.5
                NumberAnimation on hue {
                    loops: Animation.Infinite
                    duration: 1000
                    from: -1
                    to: 1
                }
            }
        }
    }

    //start anim
    SequentialAnimation{
        id: start_anim

        ParallelAnimation{
            NumberAnimation {
                target: transA
                property: "marg"
                duration: 1000
                from: len
                to: 0
                easing.type: Easing.OutCubic
            }

            NumberAnimation{
                target: transA
                property: "ang"
                duration: 1000
                from: -90
                to: 45
                easing.type: Easing.OutCubic
            }
        }

        ParallelAnimation{
            NumberAnimation{
                target: transA
                property: "gra_end"
                duration: 1000
                from: 0
                to: 2.5
            }
            NumberAnimation{
                target: logo
                property: "anchors.leftMargin"
                duration: 1000
                from: -logo.width
                to: transA.width * 0.025
                easing.type: Easing.OutCubic
            }
            NumberAnimation{
                target: tip_box
                property: "anchors.rightMargin"
                duration: 1000
                from: -tip_box.width * 1.2
                to: transA.width * 0.025
                easing.type: Easing.OutCubic
            }
        }

        onFinished: if (transA.visible) pageloader.source = ""
    }
    //end anim
    SequentialAnimation{
        id: end_anim

        NumberAnimation{
            target: transA
            property: "gra_end"
            duration: 1000
            from: 2.5
            to: 0
            easing.type: Easing.OutExpo
        }

        ParallelAnimation{
            NumberAnimation {
                target: transA
                property: "marg"
                duration: 1000
                from: 0
                to: len
                easing.type: Easing.InBack
            }
            NumberAnimation{
                target: logo
                property: "anchors.leftMargin"
                duration: 750
                from: transA.width * 0.025
                to: -logo.width
                easing.type: Easing.InBack
            }
            NumberAnimation{
                target: tip_box
                property: "anchors.rightMargin"
                duration: 750
                from: transA.width * 0.025
                to: -tip_box.width * 1.2
                easing.type: Easing.InBack
            }
        }
        onFinished: {
            transA.visible = false
            text_anim.stop()
        }
    }
    //text anim
    SequentialAnimation{
        id:text_anim
        running: transA.visible

        NumberAnimation{
            id:text_in
            target: tip_txt
            property: "opacity"
            duration: 250
            from: 0
            to: 1
        }

        PauseAnimation {
            duration: 3000
        }

        NumberAnimation{
            id:text_out
            target: tip_txt
            property: "opacity"
            duration: 250
            from: 1
            to: 0
        }
        /*PauseAnimation {
            duration: 500
        }*/
        onFinished:{
            text_change()
            text_anim.start()
        }

        onStarted: text_change()
    }

    function text_change(){
        for (var i = 0; i < index.length; i++) {
            var j = i + Math.floor(Math.random() * (index.length - 1 - i));
            [index[i], index[j]] = [index[j], index[i]]
        }
        //var j = 1 + Math.floor(Math.random() * (index.length - 1));
        //[index[0], index[j]] = [index[j], index[0]]
        tip_txt.text = index[Math.floor(Math.random() * (index.length - 1))]
    }

    function start(){
        start_anim.restart()
        visible = true
        is_running= true
    }

    function quit(){

        end_anim.restart()
    }

    Component.onCompleted: {
        mainqml.escpress_signal.connect(() => {
            transA.visible = false
            start_anim.complete()
            end_anim.complete()
            text_anim.complete()
            //transA.visible = false
        })
    }

    FontLoader {
        id: font_Genjyuu_XP_bold
        source: "/font/GenJyuuGothicX-P-Bold.ttf"
    }

}
