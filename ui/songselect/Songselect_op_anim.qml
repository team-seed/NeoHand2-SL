import QtQuick 2.12
Item {
    function start() {
        anim1.start()
        anim2.start()
    }

    NumberAnimation{
        id: anim1
        alwaysRunToEnd: true
        targets: [firstlayer_listview,firstlayer_img]
        property:"x"
        from: parent.width
        to: 0
        duration: 1000
        easing.type: Easing.OutExpo
        onFinished: connect_all()
    }

    ParallelAnimation {
        id: anim2
        alwaysRunToEnd: true

        NumberAnimation{
            target: round_count
            property:"anchors.leftMargin"
            from: - parent.width / 2
            to: 0
            duration: 2000
            easing.type: Easing.OutExpo
        }
        NumberAnimation{
            target: bottombar
            property:"anchors.leftMargin"
            from: - parent.width / 2
            to: 0
            duration: 2000
            easing.type: Easing.OutExpo
        }
        NumberAnimation{
            target: bottombar
            property:"anchors.bottomMargin"
            from: - parent.height / 2
            to: 0
            duration: 2000
            easing.type: Easing.OutExpo
        }
        NumberAnimation{
            target: count_bar
            property:"anchors.rightMargin"
            from: - parent.width / 2
            to: 0
            duration: 2000
            easing.type: Easing.OutExpo
        }
        NumberAnimation{
            target: count_bar
            property:"anchors.topMargin"
            from: - parent.height / 2
            to: 0
            duration: 2000
            easing.type: Easing.OutExpo
        }
    }
}

