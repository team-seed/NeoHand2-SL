import QtQuick 2.0
import QtQuick.Shapes 1.12

import "game_process_extension.js" as GP

Shape {
    property int start_time: 0
    property int end_time: 0
    property double bpm: 120.0
    property int window: game_customtimer.clock - start_time
    property int gesture: 0
    property int duration: end_time - start_time

    property double shape_height: (bpm * hispeed * duration) / parent.height
    property string shape_color: "green"
    property double right_top: 0
    property double right_bottom: 0
    property double left_top: 0
    property double left_bottom: 0

    property double enable_time: 0
    property int total_hit_time: 0
    property bool on_hit: false

    property int left_limit: 0
    property int right_limit: 0
    property int left_end: 0
    property int right_end: 0

    property double left_barrier: left_limit + (left_end - left_limit) * (window / duration) - 0.5
    property double right_barrier: right_limit + (right_end - right_limit) * (window / duration) + 0.5

    id: shape
    antialiasing: true

    opacity: (on_hit && enable) ? 1 : 0.5

    visible: y + shape_height > 0

    y: (bpm * hispeed * (game_customtimer.clock - end_time)) / parent.height  + (parent.height + judge_height - judge_position)

    ShapePath {
        id: sPath
        strokeColor: "whitesmoke"
        strokeWidth: 4
        fillColor: shape_color

        startX: left_top; startY: 0
        PathLine { x: right_top; y: 0 }
        PathLine { x: right_bottom; y: shape_height }
        PathLine { x: left_bottom; y: shape_height }
        PathLine { x: left_top; y: 0 }
    }

    onWindowChanged: {
        /*if (on_hit) {
            if (game_container.enable) enable_time += 1

            total_hit_time += 1

            if (gesture_engine.hand_pos < left_barrier || gesture_engine.hand_pos >= right_barrier) {
                enable_time *= (window / duration)
                on_hit = false
            }

            if (end_time < game_customtimer.clock) {
                on_hit = false
            }
        }
        else {
            if (window > 90) {
                //GP.generateHitMark(2, window, total_hit_time / duration)
                GP.generateHitMark(2, window, enable_time / total_hit_time)
                shape.destroy()
            }
            else if (window >= 0) {
                if (gesture_engine.hand_pos >= left_limit && gesture_engine.hand_pos < right_limit){
                    game_process.hold_play()
                    on_hit = true
                }
            }
        }*/


        if (window >= 0) {
            total_hit_time += 1

            if (!on_hit) {
                //game_process.hold_play()
                on_hit = true
            }

            if (game_container.enable) {
                if (gesture_engine.hand_pos >= left_barrier && gesture_engine.hand_pos < right_barrier){
                    enable_time += 1
                }
            }

            if (window > duration) {
                GP.generateHitMark(2, window, enable_time / total_hit_time)
                shape.destroy()
            }
        }

    }
}
