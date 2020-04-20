import QtQuick 2.12
import QtGraphicalEffects 1.0
import QtQuick.Particles 2.12
import "qrc:/ui/game/note_generator.js" as NOTE_GENERATOR

Item {
    id: lane_main

    // default 45/4/4
    property double lane_angle: 47.5
    property double lane_length_multiplier: 6
    property double speed_base_multiplier: 8

    property double top_area: 0
    property double top_width: 0
    property double bottom_area: 0

    property double judge_position: 300
    property double note_height: 100

    property int combo: 1234

    property int bg_line_count : 32
    antialiasing: true
    clip: true

    ParticleSystem {
        id: side_effect
        anchors.fill: parent
        opacity: 0.5

        ImageParticle {
            system: side_effect
            groups: ["P"]

            source: "qrc:/ui/songselect/image/particle2.png"
        }

        Emitter {
            enabled: true
            id: side_effect_emitter_right
            system: side_effect
            group: "P"

            width: 1
            height: top_area
            anchors.top: parent.top
            anchors.left: parent.horizontalCenter
            anchors.leftMargin: parent.width * top_width / 2

            emitRate: 25
            lifeSpan: 1000

            onEmitParticles: {
                for (var i = 0; i<particles.length; i++) {
                    var particle = particles[i];
                    var rand = Math.random()

                    particle.initialX = side_effect_emitter_right.x + 200 * (1 - rand)
                    particle.initialY = rand * top_area
                    particle.initialVX = 100
                    particle.initialVY = 0

                    particle.alpha = 0.3
                    particle.initialAX = 3200 - 1600 * rand
                    particle.initialAY = 1800 * rand

                    particle.startSize = 10 * (1-rand) + 10
                    particle.endSize = 30 * (1-rand) + 5
                }
            }
        }

        Emitter {
            enabled: true
            id: side_effect_emitter_left
            system: side_effect
            group: "P"

            width: 1
            height: top_area
            anchors.top: parent.top
            anchors.right: parent.horizontalCenter
            anchors.rightMargin: parent.width * top_width / 2

            emitRate: 25
            lifeSpan: 1000

            onEmitParticles: {
                for (var i = 0; i<particles.length; i++) {
                    var particle = particles[i];
                    var rand = Math.random()

                    particle.initialX = side_effect_emitter_left.x - 200 * (1 - rand)
                    particle.initialY = rand * top_area
                    particle.initialVX = -100
                    particle.initialVY = 0

                    particle.alpha = 0.3
                    particle.initialAX = - 3200 + 1600 * rand
                    particle.initialAY = 1800 * rand

                    particle.startSize = 10 * (1-rand) + 10
                    particle.endSize = 30 * (1-rand) + 5
                }
            }
        }
    }

    Item {
        id: left_bg
        width: parent.width * lane_length_multiplier / 3
        height: parent.height
        anchors{
            left: parent.left
            verticalCenter:parent.verticalCenter
        }
        Item {
            anchors.fill: parent
            clip: true
            Row{
                id: left_bg_row
                width: parent.width * 2
                height: parent.height
                anchors{
                    top: parent.top
                    topMargin: -left_bg_row.height / 2
                    left: parent.left
                }
                spacing: width / bg_line_count
                Repeater{
                    model: bg_line_count / 2
                    Rectangle{
                        width: left_bg_row.width / bg_line_count
                        height: left_bg_row.height * 2
                        color: "gray"
                        transformOrigin: Item.Center
                        rotation: -45
                    }
                }
                NumberAnimation on anchors.leftMargin {
                    loops: Animation.Infinite
                    running: true
                    duration: 5000
                    from: 0
                    to: -left_bg_row.width / 2
                }
            }

        }

        transform: Rotation {
            axis: Qt.vector3d(0, 1, 0); angle: lane_angle - 4.75
        }
    }

    Item {
        id: right_bg
        width: parent.width * lane_length_multiplier / 3
        height: parent.height
        anchors{
            right: parent.right
            verticalCenter:parent.verticalCenter
        }
        Rectangle{
            anchors.fill: parent
            color: "blue"
            opacity: 0.1
        }

        transform: Rotation {
            origin.x: right_bg.width ; origin.y: 0
            axis: Qt.vector3d(0, 1, 0); angle: -(lane_angle - 4.75)
        }
    }

    Item {
        id: barline_container
        anchors.fill: parent
        antialiasing: true
        z: 0
    }

    // the whole lane itself
    Item {
        id: lane_container
        width: parent.width
        height: parent.height * lane_length_multiplier
        anchors.bottom: parent.bottom

        // lane base
        Rectangle {
            property double node_width: width / 16

            id: play_area
            height: parent.height
            anchors.left: side_left.right
            anchors.right: side_right.left

            color: "#666666"
            opacity: 0.5
        }

        // judge line
        Rectangle {
            id: judge_line

            width: play_area.width
            height: note_height
            radius: note_height / 6
            color: "#222222"

            anchors.top: play_area.bottom
            anchors.topMargin: -judge_position
            anchors.horizontalCenter: play_area.horizontalCenter
        }

        Image {
            id: img
            anchors.fill: judge_line
            fillMode: Image.Tile
            source: "qrc:/ui/songselect/image/particle2.png"
            sourceSize {
                width: 10
                height: width
            }
            opacity: 0.15
            layer.enabled: true
            layer.effect: OpacityMask { maskSource: judge_line }
        }

        // divider
        Row {
            property int line_width: 5

            id: divider_container
            width: play_area.width / 2
            height: play_area.height
            anchors.centerIn: play_area
            spacing: width / 2 - line_width
            opacity: 0.75
            Repeater {
                model: 3
                Rectangle {
                    width: divider_container.line_width
                    height: divider_container.height
                    color: "#AAAAAA"
                    antialiasing: true
                }
            }
        }

        // lane sides
        Rectangle {
            id: side_right
            height: parent.height
            width: parent.width / 25
            anchors.right: parent.right
            antialiasing: true

            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.6; color: "#DDDDDD" }
                GradientStop { position: 1.0; color: "#999999" }
            }
        }

        Rectangle {
            id: side_left
            height: parent.height
            width: parent.width / 25
            anchors.left: parent.left
            antialiasing: true

            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.4; color: "#DDDDDD" }
                GradientStop { position: 1.0; color: "#999999" }
            }
        }

        // note containers
        Item {
            id: hold_note_container
            anchors.fill: play_area
            antialiasing: true
            z: 1
        }

        Item {
            id: click_note_container
            anchors.fill: play_area
            antialiasing: true
            z: 2
        }

        transform: Rotation {
            origin.x: lane_container.width / 2; origin.y: lane_container.height
            axis: Qt.vector3d(1, 0, 0); angle: lane_angle
        }

        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: lane_mask
        }

        // lane mask
        Rectangle {
            id: lane_mask
            anchors.fill: lane_container
            visible: false
            gradient: Gradient {
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 0.2; color: "white" }
                GradientStop { position: 0.99; color: "white" }
                GradientStop { position: 1.0; color: "transparent" }
            }
        }
    }

    Item {
        id: combo_container
        width: parent.width / 2
        height: parent.height / 3
        anchors{
            left: parent.left
            leftMargin: width / 5
            verticalCenter:parent.verticalCenter
            verticalCenterOffset: height / 6
        }
        Rectangle{
            anchors.fill: parent
            color: "#222222"
            opacity: 0
            transform: Rotation {
                origin.x: 0 ; origin.y: -height / 2
                axis: Qt.vector3d(0, 1, 0); angle: lane_angle - 3.75
            }
        }
        Text {
            id: combo_text
            text: combo.toString()
            fontSizeMode: Text.Fit
            font.pixelSize: parent.height
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            transform: Rotation {
                origin.x: 0 ; origin.y: -height / 2
                axis: Qt.vector3d(0, 1, 0); angle: lane_angle - 3.75
            }
        }

    }

    Item {
        id: swipe_note_container
        anchors.fill: parent
        z: 3
    }

    Rectangle {
        id: hand_indicator

        color: "transparent"
        border.width: 5
        border.color: "white"
        radius: note_height / 15

        opacity: 0.5

        height: width * 9 / 16
    }

    function generating_notes () {
        chart_maker.song_chart_parse(global_song_meta[0] + (global_is_expert ? "/expert.json" : "/basic.json"))
        chart_maker.chart.forEach (value => {
                                       if (Array.isArray(value)) {
                                           switch (value[0]) { // note type
                                               case 0: NOTE_GENERATOR.make_click(value[1], value[2], value[3], value[4], value[5]); break
                                               case 1: NOTE_GENERATOR.make_hold(value[1], value[2], value[3], value[4], value[5], value[6], value[7], value[8]); break
                                               case 2: NOTE_GENERATOR.make_swipe(value[6], value[2], value[3], value[4], value[5]);
                                               // NOTE_GENERATOR.make_click(value[1], value[2], value[3], value[4], value[5]);
                                               break
                                               case -1: NOTE_GENERATOR.make_barline(value[1], value[2]); break
                                           }

                                           //if (value[0] != -1) total_note_count += 1
                                       }
                                       else {
                                           console.log(value);
                                       }
                                   })

        // do something more?
        game_start_countdown.restart();
    }

    Component.onCompleted: {
        var left_top = swipe_note_container.mapFromItem(lane_container, 0, 0)
        var right_top = swipe_note_container.mapFromItem(lane_container, width, 0)
        var left_bottom = swipe_note_container.mapFromItem(lane_container, 0, height * lane_length_multiplier)

        top_area = left_top.y
        top_width = Math.abs(right_top.x - left_top.x) / width
        bottom_area = height - top_area

        var judge_left = swipe_note_container.mapFromItem(lane_container,
                                                          side_left.width,
                                                          lane_container.height - judge_position + note_height)

        var judge_right = swipe_note_container.mapFromItem(lane_container,
                                                           side_left.width + judge_line.width,
                                                           lane_container.height - judge_position + note_height)

        hand_indicator.width = judge_right.x - judge_left.x
        hand_indicator.x = judge_left.x
        hand_indicator.y = judge_left.y - hand_indicator.height


        console.log(judge_left, judge_right)
    }
}
