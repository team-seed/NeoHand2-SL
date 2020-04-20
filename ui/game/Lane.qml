import QtQuick 2.12
import QtQuick.Shapes 1.12
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

    property int bg_line_count : 16

    property string bg_effect_color: "lightblue"

    antialiasing: true
    clip: true

    Item {
        id: left_bg
        width: parent.width * lane_length_multiplier / 3
        height: parent.height
        anchors{
            left: parent.left
            verticalCenter:parent.verticalCenter
        }

        Item {
            id: bg_effect_left
            anchors.fill: parent
            opacity: 0.25

            Item {
                width: parent.width * 2
                height: parent.height

                anchors.left: parent.left
                anchors.top: parent.top

                Repeater {
                    model: bg_line_count

                    Item {
                        height: parent.height * 2
                        width: parent.width / bg_line_count

                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: width * index

                        Rectangle {
                            anchors.fill: parent

                            gradient: Gradient {
                                orientation: Gradient.Horizontal
                                GradientStop { position: 0; color: "white" }
                                GradientStop { position: 0.25; color: "transparent" }
                            }

                            transformOrigin: Item.BottomLeft
                            rotation: -35
                        }
                    }

                }

                NumberAnimation on anchors.leftMargin {
                    loops: Animation.Infinite
                    from: 0; to: -width/2
                    running: true
                    duration: 5000
                }
            }

            Item {
                height: parent.height
                width: parent.width * 2
                anchors.top: parent.top
                anchors.left: parent.left

                Repeater {
                    model: 8

                    Item {
                        height: parent.height / 8
                        width: parent.width
                        anchors.left: parent.left
                        anchors.top: parent.bottom

                        Rectangle {
                            anchors.fill: parent

                            gradient: Gradient {
                                GradientStop { position: 0; color: "white" }
                                GradientStop { position: 0.75; color: "transparent" }
                            }

                            transformOrigin: Item.TopRight
                            rotation: -2.5 * index + 10
                        }
                    }

                }

                transformOrigin: Item.BottomRight

                NumberAnimation on rotation {
                    loops: Animation.Infinite
                    from: 0; to: 10
                    running: true
                    duration: 5000
                }
            }

            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: left_mask
                layer.enabled: true
                layer.effect: ColorOverlay { color: bg_effect_color }
            }
        }

        LinearGradient {
            id: left_mask
            anchors.fill: parent
            start: Qt.point(width, 0)
            end: Qt.point(width / 2, height)
            visible: false

            gradient: Gradient {
                GradientStop { position: 0.5; color: "transparent" }
                GradientStop { position: 1; color: "white" }
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

        clip: true

        Item {
            id: bg_effect_right
            anchors.fill: parent
            opacity: 0.25

            Item {
                width: parent.width * 2
                height: parent.height

                anchors.right: parent.right
                anchors.top: parent.top
                visible: true

                Repeater {
                    model: bg_line_count

                    Item {
                        height: parent.height * 2
                        width: parent.width / bg_line_count

                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: width * index

                        Rectangle {
                            anchors.fill: parent

                            gradient: Gradient {
                                orientation: Gradient.Horizontal
                                GradientStop { position: 1; color: "white" }
                                GradientStop { position: 0.75; color: "transparent" }
                            }

                            transformOrigin: Item.BottomRight
                            rotation: 35
                        }
                    }

                }

                NumberAnimation on anchors.rightMargin {
                    loops: Animation.Infinite
                    from: 0; to: -width/2
                    running: true
                    duration: 5000
                }
            }

            Item {
                height: parent.height
                width: parent.width * 2
                anchors.top: parent.top
                anchors.right: parent.right

                Repeater {
                    model: 8

                    Item {
                        height: parent.height / 8
                        width: parent.width
                        anchors.right: parent.right
                        anchors.top: parent.bottom

                        Rectangle {
                            anchors.fill: parent

                            gradient: Gradient {
                                GradientStop { position: 0; color: "white" }
                                GradientStop { position: 0.75; color: "transparent" }
                            }

                            transformOrigin: Item.TopLeft
                            rotation: 2.5 * index - 10
                        }
                    }

                }

                transformOrigin: Item.BottomLeft

                NumberAnimation on rotation {
                    loops: Animation.Infinite
                    from: 0; to: -10
                    running: true
                    duration: 5000
                }
            }

            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: right_mask
                layer.enabled: true
                layer.effect: ColorOverlay { color: bg_effect_color }
            }
        }

        LinearGradient {
            id: right_mask
            anchors.fill: parent
            start: Qt.point(0, 0)
            end: Qt.point(width / 2, height)
            visible: false

            gradient: Gradient {
                GradientStop { position: 0.5; color: "transparent" }
                GradientStop { position: 1; color: "white" }
            }
        }

        transform: Rotation {
            origin.x: right_bg.width ; origin.y: 0
            axis: Qt.vector3d(0, 1, 0); angle: -(lane_angle - 4.75)
        }
    }


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

        //opacity: 0.5

        height: width * 9 / 16

        Rectangle {
            height: parent.height
            width: 50

            anchors.verticalCenter: parent.verticalCenter
            opacity: 0.25

            visible: handA.gesture != -2

            x: parent.width * handA.normX

            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 0.5; color: handA.gesture != -1 ? "orange" : "gray" }
                GradientStop { position: 1.0; color: "transparent" }
            }

            Rectangle {
                width: parent.width
                height: width
                radius: width
                anchors.horizontalCenter: parent.horizontalCenter

                visible: handA.gesture != -2

                //x: parent.width * handA.normX
                y: parent.height * handA.normY

                color: handA.gesture != -1 ? "orange" : "gray"
            }
        }

        Rectangle {
            height: parent.height
            width: 50

            anchors.verticalCenter: parent.verticalCenter
            opacity: 0.25

            x: parent.width * handB.normX

            visible: handB.gesture != -2

            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 0.5; color: handB.gesture != -1 ? "orange" : "gray" }
                GradientStop { position: 1.0; color: "transparent" }
            }

            Rectangle {
                width: parent.width
                height: width
                radius: width
                anchors.horizontalCenter: parent.horizontalCenter

                visible: handA.gesture != -2

                //x: parent.width * handB.normX
                y: parent.height * handB.normY

                color: handB.gesture != -1 ? "orange" : "gray"
            }
        }

        ParticleSystem {
            id: hit_particle_sys
            anchors.fill: parent

            ImageParticle {
                system: hit_particle_sys
                groups: ["E"]

                source: "qrc:/ui/songselect/image/particle2.png"
                opacity: 0.5
                color: "yellow"
            }

            ImageParticle {
                system: hit_particle_sys
                groups: ["C"]

                source: "qrc:/ui/songselect/image/particle2.png"
                opacity: 0.5
                color: "deepskyblue"
            }

            Row {
                anchors.bottom: parent.bottom
                width: parent.width
                height: 1

                Repeater {
                    id: emitters_exact
                    model: 16

                    Emitter {
                        enabled: false
                        width: hit_particle_sys.width / 16
                        height: 1

                        system: hit_particle_sys
                        group: "E"

                        lifeSpan: 300
                        lifeSpanVariation: 50

                        velocity: PointDirection { y: -150; yVariation: 100; x: 0; xVariation: 100 }
                        acceleration: PointDirection { y: 100 }

                        size: 15
                        sizeVariation: 3
                    }
                }
            }

            Row {
                anchors.bottom: parent.bottom
                width: parent.width
                height: 1

                Repeater {
                    id: emitters_close
                    model: 16

                    Emitter {
                        enabled: false
                        width: hit_particle_sys.width / 16
                        height: 1

                        system: hit_particle_sys
                        group: "C"

                        lifeSpan: 300
                        lifeSpanVariation: 50

                        velocity: PointDirection { y: -150; yVariation: 100; x: 0; xVariation: 100; }
                        acceleration: PointDirection { y: 100 }

                        size: 15
                        sizeVariation: 3
                    }
                }
            }
        }

        Item { id: hit_mark_container; anchors.fill: parent }
    }

    Timer {
        id: dynamic_linker
        interval: 1000
        triggeredOnStart: true
        repeat: true
        onTriggered: NOTE_GENERATOR.dynamic_link()
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

                                           if (value[0] != -1) total_object++
                                       }
                                       else {
                                           console.log(value);
                                       }
                                   })

        NOTE_GENERATOR.sort_queue()

        // do something more?
        game_start_countdown.restart();
    }

    function hitmark (type, left, right) {
        NOTE_GENERATOR.make_hitmark(type, left, right)

        switch (type) {
        case 0:
            current_health = Math.min(max_health, Math.max(0, current_health - 20));
            combo = 0;
            break_count++;
            return
        case 1:
            current_health = Math.min(max_health, Math.max(0, current_health + 10));
            close_count++
            break
        case 2:
            current_health = Math.min(max_health, Math.max(0, current_health + 20));
            exact_count++
            break
        }

        combo++

        for (var i = left; i < right; i++) {
            (type == 2 ? emitters_exact : emitters_close).itemAt(i).burst(50)
        }
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

        dynamic_linker.start()

        mainqml.bksppress_signal.connect(()=>NOTE_GENERATOR.make_hitmark(0, Math.floor(Math.random()*16), Math.floor(Math.random()*16)))

        //mainqml.click_trigger.connect(NOTE_GENERATOR.click_hit)
    }

    FontLoader {
        id: font_good_times
        source: "qrc:/font/good-times-rg.ttf"
    }
}
