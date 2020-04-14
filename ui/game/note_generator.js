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
            console.log("Error on creating click note.")
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
        console.log("Error on loading click note.")
        console.log(click_component.errorString())
        return false
    }

    return true
}

function make_hold (gest, bpm, s_time, s_left, s_right, e_time, e_left, e_right) {
    if (hold_component == null)
        hold_component = Qt.createComponent("qrc:/ui/game/hold_note.qml")


    if (hold_component.status == Component.Ready) {
        var dynamicObject
        dynamicObject = hold_component.createObject(hold_note_container)

        if (dynamicObject == null) {
            console.log("Error on creating hold note.")
            console.log(hold_component.errorString())
            return false
        }

        var ls = Math.min(s_left, e_left), rs = 16 - Math.max(s_right, e_right)

        dynamicObject.start_time = s_time + global_offset
        dynamicObject.end_time = e_time + global_offset
        dynamicObject.bpm = bpm

        dynamicObject.left_spacing = ls
        dynamicObject.right_spacing = rs

        dynamicObject.start_pos = [s_left - ls, s_right - ls]
        dynamicObject.end_pos = [e_left - ls, e_right - ls]

        //gesture serves no purpose in this version
        //dynamicObject.gesture = gesture
    }
    else {
        console.log("Error on loading hold note.")
        console.log(hold_component.errorString())
        return false
    }

    return true
}

function make_swipe (dirc, bpm, time, left, right) {
    if (swipe_component == null)
        swipe_component = Qt.createComponent("qrc:/ui/game/swipe_note.qml")


    if (swipe_component.status == Component.Ready) {
        var dynamicObject
        dynamicObject = swipe_component.createObject(swipe_note_container)

        if (dynamicObject == null) {
            console.log("Error on creating swipe note.")
            console.log(swipe_component.errorString())
            return false
        }

        dynamicObject.time = time + global_offset
        dynamicObject.bpm = bpm

        dynamicObject.left_pos = left
        dynamicObject.right_pos = right

        dynamicObject.direction = dirc

        //gesture serves no purpose in this version
        //dynamicObject.gesture = gesture
    }
    else {
        console.log("Error on loading swipe note.")
        console.log(swipe_component.errorString())
        return false
    }

    return true
}

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
