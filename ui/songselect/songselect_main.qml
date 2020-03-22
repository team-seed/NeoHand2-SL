import QtQuick 2.12

import custom.songselect 1.0

Item {
    id: songselect_main_container

    property var songs_meta: dir.content
    property bool select_expert: false

    // 0 = select sorting mode , 1 = select song
    property bool current_state: false

    property var detail_display: {
        "jacket": "",
        "title": "",
        "artist": "",
        "basic_difficulty": "",
        "expert_difficulty": "",
    }

    CustomSongselect { id: dir }

    ListModel {
        id: sort_selection_list
        ListElement { title: "Artist"; sortfunc: "Artist" }
        ListElement { title: "Title"; sortfunc: "Title" }
        ListElement { title: "Level 1"; sortfunc: "Level" }
        ListElement { title: "Level 2"; sortfunc: "Level" }
        ListElement { title: "Level 3"; sortfunc: "Level" }
        ListElement { title: "Level 4"; sortfunc: "Level" }
        ListElement { title: "Level 5"; sortfunc: "Level" }
        ListElement { title: "Level 6"; sortfunc: "Level" }
        ListElement { title: "Level 7"; sortfunc: "Level" }
        ListElement { title: "Level 8"; sortfunc: "Level" }
        ListElement { title: "Level 9"; sortfunc: "Level" }
        ListElement { title: "Level 10"; sortfunc: "Level" }
    }

    //temp background
    Rectangle {
        anchors.fill: parent
        color: "#aaaaaa"

    }

    //select sort
    Item {
        id: firstlayer

        width: parent.width / 4
        height: parent.height

        anchors {
            right: parent.horizontalCenter
            rightMargin: current_state ? width : 0
            verticalCenter: parent.verticalCenter

            Behavior on rightMargin {
                NumberAnimation{
                    duration: 250
                    easing.type: Easing.OutCubic
                }
            }
        }

        //first layer bg
        Rectangle{
            anchors.fill: parent
            color: "#222222"
            opacity: 0.5
        }

        Component {
            id: firstlayer_delegate

            Item {
                width: firstlayer.width
                height: firstlayer.height / 5

                Rectangle {
                    color: "steelblue"
                    opacity: 0.6
                    anchors.fill: parent
                }

                Item {
                    height: parent.height
                    width: height
                    anchors.centerIn: parent

                    Text {
                        text: title
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        anchors.centerIn: parent
                        wrapMode: Text.WordWrap
                        width: parent.width
                        font.family: font_Genjyuu_XP_bold.name
                        font.pixelSize: parent.height / 8
                    }
                }

                function sortbythis () {
                    secondlayer_listview.model = song_sorting(sortfunc)
                }
            }   
        }

        //白外框
        Component {
            id: firstlayer_hl

            Rectangle {
                color: "transparent"
                radius: 10
                border {
                    color: "white"
                    width: 10
                }
            }
        }

        ListView {
            id: firstlayer_listview
            y: parent.height * 0.4 - currentItem.y

            height: parent.height / 5 * count
            width: firstlayer.width
            model: sort_selection_list
            delegate: firstlayer_delegate
            orientation: ListView.Vertical
            interactive: false

            highlight: firstlayer_hl
            highlightMoveDuration: 0

            Behavior on y {
                NumberAnimation {
                    duration: 250
                    easing.type: Easing.OutExpo
                }
            }
        }

    }

    //select song
    Item {
        id: secondlayer

        width: parent.width / 4
        height: parent.height
        opacity: current_state ? 1 : 0
        anchors {
            right: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }

        Behavior on opacity {
            NumberAnimation{
                duration: 250
                easing.type: Easing.OutCubic
            }
        }

        Component {
            id: secondlayer_delegate

            Item {
                width: secondlayer.width
                height: secondlayer.height / 5

                Rectangle {
                    id: title_box
                    color: "#222222"
                    opacity: 0.7
                    width: parent.width * 0.7
                    height: parent.height
                    anchors{
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                    }
                }

                Item {
                    height: parent.height
                    width: height
                    anchors.centerIn: title_box

                    Text {
                        id: cov
                        text: songs_meta[secondlayer_listview.model[index][0]][2]
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        anchors.centerIn: parent
                        wrapMode: Text.WordWrap
                        width: parent.width
                        font.family: font_Genjyuu_XP_bold.name
                        font.pixelSize: parent.height / 8
                    }
                }

            }
        }

        //白外框
        Component {
            id: secondlayer_hl
            Rectangle {
                color: "transparent"
                radius: 10
                border {
                    color: "white"
                    width: 10
                }

            }
        }

        ListView {
            id: secondlayer_listview
            y: parent.height * 0.4 - currentItem.y

            height: parent.height / 5 * count
            width: secondlayer.width
            model: []
            delegate: secondlayer_delegate
            orientation: ListView.Vertical
            interactive: false

            highlight: secondlayer_hl
            highlightMoveDuration: 0

            Behavior on y {
                NumberAnimation {
                    duration: 250
                    easing.type: Easing.OutExpo
                }
            }

            onCurrentIndexChanged: {
                if (current_state) {
                    dir.stopPreview();
                    dir.playEffect();
                    player_timer.restart();
                }
            }

            Component.onCompleted: positionViewAtIndex(0, ListView.Contain)
        }

    }

    //song information
    Item {
        id: detail_panel

        width: parent.width * 0.5
        height: parent.height

        anchors {
            left : parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }

        //jacket
        Image {
            id: current_jacket
            fillMode: Image.PreserveAspectFit
            source: "file:///" + songs_meta[secondlayer_listview.model[secondlayer_listview.currentIndex][0]][0] + "/jacket.png"

            height: parent.height * 0.5
            width: parent.width * 0.5

            anchors {
                top: parent.top
                left: parent.left
            }
        }


        Rectangle {
            id: current_bar

            color: "#222222"

            width: 20

            anchors {
                top: current_jacket.bottom
                bottom: current_artist.bottom
                left: parent.left
            }
        }

        Text {
            id: current_title
            text: songs_meta[secondlayer_listview.model[secondlayer_listview.currentIndex][0]][2]
            color: "white"
            font.family: font_Genjyuu_XP_bold.name
            font.pixelSize: height
            minimumPixelSize: 10

            fontSizeMode: Text.Fit
            verticalAlignment: Text.AlignVCenter
            style: Text.Raised
            styleColor: "#222222"

            height: current_jacket.height / 6

            anchors {
                top: current_jacket.bottom
                left: current_bar.right
            }
        }

        Text {
            id: current_artist
            text: songs_meta[secondlayer_listview.model[secondlayer_listview.currentIndex][0]][1]
            color: "white"
            font.family: font_Genjyuu_XP_bold.name
            font.pixelSize: height
            minimumPixelSize: 10

            fontSizeMode: Text.Fit
            verticalAlignment: Text.AlignVCenter
            style: Text.Raised
            styleColor: "#222222"

            height: current_jacket.height / 8

            anchors {
                top: current_title.bottom
                topMargin: 20
                left: current_bar.right
            }
        }

        Item {
            width: parent.width
            height: parent.height / 4

            anchors {
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
            }

            Rectangle {
                id: basic_token
                color: "forestgreen"
                radius: height / 2
                height: 50
                width: parent.width / 3
                anchors {
                    verticalCenter: parent.verticalCenter
                    right: parent.horizontalCenter
                }

                Text {
                    text: "BASIC  " + songs_meta[secondlayer_listview.model[secondlayer_listview.currentIndex][0]][6]
                    font.family: font_hemi_head.name
                    color: "white"
                    font.pixelSize: parent.height * 0.8

                    anchors.centerIn: parent
                }
            }

            Rectangle {
                id: expert_token
                color: "firebrick"
                radius: height / 2
                height: 50
                width: parent.width / 3
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.horizontalCenter
                }

                Text {
                    text: "EXPERT  " + songs_meta[secondlayer_listview.model[secondlayer_listview.currentIndex][0]][7]
                    font.family: font_hemi_head.name
                    color: "white"
                    font.pixelSize: parent.height * 0.8

                    anchors.centerIn: parent
                }
            }
        }
    }

    Timer {
        id: player_timer
        interval: 1000
        repeat: false
        onTriggered: {
            //dir.playPreview("file:///" + songs_meta[song_index][0] + "/audio.wav", songs_meta[song_index][4])
        }
    }

    function song_sorting (method) {
        var list = [];
        switch (method) {
            case "Artist":
                songs_meta.forEach(function(data,index){
                    list.push([index,-1])
                })
                list.sort(function(a,b){
                        if(songs_meta[a[0]][1].toUpperCase() < songs_meta[b[0]][1].toUpperCase() )
                            return -1
                        else
                            return 1
                    });
                break;

            case "Title":
                songs_meta.forEach(function(data,index){
                    list.push([index,-1])
                })
                list.sort(function(a,b){
                    if( songs_meta[a[0]][2].toUpperCase() < songs_meta[b[0]][2].toUpperCase() )
                        return -1
                    else
                        return 1
                });
                break;

            case "Level":
                for(var i = 1; i <= 10; i++ ){
                    songs_meta.forEach(function(data,index){
                        if(data[6]==i)
                            list.push([index,6])
                        if(data[7]==i)
                            list.push([index,7])
                    });
                }
                break;
        }
        return list
    }

    function right_press () {
        if (current_state == false){
            current_state = true
            firstlayer_listview.currentItem.sortbythis()
        }
    }

    function left_press () {
        if(current_state == true){
            current_state = false
            dir.stopPreview()
        }
    }

    function up_press() {
        (current_state ? secondlayer_listview : firstlayer_listview).decrementCurrentIndex()
    }

    function down_press () {
        (current_state ? secondlayer_listview : firstlayer_listview).incrementCurrentIndex()

    }

    function to_main () {
        //pageloader.source = "/ui/option/option_menu.qml"
        Qt.quit()
    }

    function select() {
        disconnect_all();
        destruct.start();
    }

    Component.onCompleted: {
        mainqml.rightpress_signal.connect(right_press)
        mainqml.leftpress_signal.connect(left_press)
        mainqml.uppress_signal.connect(up_press)
        mainqml.downpress_signal.connect(down_press)
        mainqml.escpress_signal.connect(to_main)
        mainqml.enterpress_signal.connect(select)

    }

    function disconnect_all() {
        mainqml.rightpress_signal.disconnect(right_press)
        mainqml.leftpress_signal.disconnect(left_press)
        mainqml.downpress_signal.disconnect(down_press)
        mainqml.escpress_signal.disconnect(to_main)
        mainqml.enterpress_signal.disconnect(select)
    }

    Component.onDestruction: {
        disconnect_all();
    }

    FontLoader {
        id: font_Genjyuu_XP_bold
        source: "/font/GenJyuuGothicX-P-Bold.ttf"
    }

    FontLoader {
        id: font_hemi_head
        source: "/font/hemi-head-bd-it.ttf"
    }
}
