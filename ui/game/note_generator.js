var click_component
var hold_component
var swipe_component
var barline_component = null

function make_click (gesture, bpm, time, left, right) {}

function make_hold (gest, bpm, s_time, s_left, s_right, e_time, e_left, e_right) {}

function make_swipe (dirc, bpm, time, left, right) {}

function make_barline (bpm, time) {
    if (barline_component == null)
        barline_component = Qt.createComponent("qrc:/ui/game/barline.qml")


    if (barline_component.status == Component.Ready) {
        var dynamicObject
        dynamicObject = barline_component.createObject(barline_container)

        if (dynamicObject == null) {
            console.log("Error on creating barline.")
            console.log(barline_component.errorString())
            return false
        }

        dynamicObject.time = time + global_offset
        dynamicObject.bpm = bpm
    }
    else {
        console.log("Error on loading barline.")
        console.log(barline_component.errorString())
        return false
    }

    return true
}
