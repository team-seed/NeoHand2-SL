import QtQuick 2.12
import QtGraphicalEffects 1.0

Item {
    property int time: 0
    property double bpm: 120.0
    property int window: game_timer.elapsed - time

    // gesture serves no purpose in this version
    property int gesture: 0
    property string note_color: gesture == 0 ? "orange" : "deepskyblue"

    property int left_pos: 0
    property int right_pos: 0

    id: _click

    height: note_height
    opacity: 0.75

    anchors {
        left: parent.left
        right: parent.right
        leftMargin: play_area.node_width * left_pos
        rightMargin: play_area.node_width * (16 - right_pos)
    }


    antialiasing: true
    visible: y > 0

    Rectangle {
        id: rec
        anchors.fill: parent
        color: note_color //"white"

        radius: height / 15

        Rectangle {
            anchors.centerIn: parent
            height: parent.height
            width: parent.width * 0.9

            color: "white"
        }
    }

    y: (bpm * hispeed * window * lane_length_multiplier * speed_base_multiplier) / parent.height + (parent.height - judge_position)

    //onYChanged: { if (y > parent.height) _click.destroy() }

    function hit (pos) {
        // not yet
        if (Math.abs(window) > 120) return;

        // check area
        if ( pos >= left_pos && pos < right_pos ) {
            // exact
            //if (Math.abs(window) <= 50) _click.destroy();
            // close
            //else _click.destroy();

            hitmark((Math.abs(window) <= 50) ? 2 : 1, left_pos, right_pos)

            combo++
            _click.destroy()

            //console.log("click hit")
        }
    }

    function link () {
        mainqml.click_trigger.connect(hit)

        _click.onWindowChanged.connect(()=>{ if (window > 120) {
                                               hitmark(0, left_pos, right_pos)
                                               combo = 0
                                               _click.destroy()
                                           }})
        //console.log("linked - click note")
    }

    //Component.onCompleted: link() // for test

    Component.onDestruction: {
        mainqml.click_trigger.disconnect(hit)
        //console.log("destruction - click")
        //_click.onWindowChanged.disconnect(miss)
        //console.log("click destroyed, timestamp " + time.toString())
    }
}
