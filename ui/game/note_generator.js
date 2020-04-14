var click_component
var hold_component
var swipe_component
var barline_component

function make_click (gesture, bpm, time, left, right) {
    if (click_component == null)
        click_component = Qt.createComponent("qrc:/ui/game/click_note.qml")


    if (click_component.status == Component.Ready) {
        var dynamicObject
        dynamicObject = click_component.createObject(click_note_container)

        if (dynamicObject == null) {
            console.log("Error on creating barline.")
            console.log(click_component.errorString())
            return false
        }

        dynamicObject.time = time + global_offset
        dynamicObject.bpm = bpm

        dynamicObject.left_pos = left
        dynamicObject.right_pos = right

        //gesture serves no purpose in this version
        //dynamicObject.gesture = gesture
    }
    else {
        console.log("Error on loading barline.")
        console.log(click_component.errorString())
        return false
    }

    return true
}

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
