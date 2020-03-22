import QtQuick 2.12

import custom.songselect 1.0

Item {
    id: songselect_container

    property variant songs_meta: dir.content
    property int song_index: select_list.currentIndex[0]
    property int page_count: 4
    property bool select_expert: false
    property variant sort_text: ["Artist","Title","Level 1","Level 2","Level 3","Level 4","Level 5","Level 6","Level 7","Level 8","Level 9","Level 10"]

    // 0 = select sorting mode , 1 = select song
    property bool current_state: false
    // 0 = artist , 1 = title , 2 = basic , 3 = expert
    property int sort_type : 0
    // artist/tilte : [[index,-1]] , level : [[index,dif(6=basic,7=expert)] ]
    property variant after_sort: []

    CustomSongselect { id: dir }

    Rectangle {
        anchors.fill: parent
        color: "#aaaaaa"

    }


    //select sort
    Item {
        id: sort_select_bar
        property double select_bar_margin: 0
        z: 2

        width: parent.width / 4
        height: parent.height

        anchors {
            right: parent.horizontalCenter
            rightMargin: current_state ?  width : 0
            verticalCenter: parent.verticalCenter
        }

        Behavior on anchors.rightMargin {
            NumberAnimation{
                duration: 250
                easing.type: Easing.OutCubic
            }
        }
        Rectangle{
            anchors.fill: parent
            color: "#222222"
            opacity: 0.5
        }
        Component {
            id: sort_list_delegate

            Item {
                width: sort_select_bar.width
                height: sort_select_bar.height / 5

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
                        id: sort_cov
                        text: sort_text[index]
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        anchors.centerIn: parent
                        wrapMode: Text.WordWrap
                        width: parent.width
                        font.family: font_Genjyuu_XP_bold.name
                        font.pixelSize: parent.height / 8
                    }
                }

                Image {
                    id: sort_delegate_left
                    source: "qrc:/ui/songselect/image/layer1_outer_frame_new.png"// This is available in all editors.
                    width: parent.width / 10
                    height: parent.height
                    anchors{
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                    }
                    fillMode: Image.TileVertically
                    verticalAlignment: Image.AlignVCenter
                }

                Image {
                    id: sort_delegate_right
                    source: "qrc:/ui/songselect/image/layer1_outer_frame_new.png"// This is available in all editors.
                    width: parent.width / 10
                    height: parent.height
                    anchors{
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                    }
                    fillMode: Image.TileVertically
                    verticalAlignment: Image.AlignVCenter
                }
                Rectangle{
                    color: "#222222"
                    width: parent.width
                    height: parent.height / 36
                    anchors{
                        bottom: parent.bottom
                        horizontalCenter: parent.horizontalCenter
                    }
                }
                Rectangle{
                    color: "#222222"
                    width: parent.width
                    height: parent.height / 36
                    anchors{
                        top: parent.top
                        horizontalCenter: parent.horizontalCenter
                    }

                }

            }
        }
        //白外框
        Component {
            id: sort_list_hl

            Rectangle {
                color: "transparent"
                radius: 10
                z: 3
                border {
                    color: "white"
                    width: 10
                }
                visible: false
            }
        }

        ListView {
            id: sort_select_list
            y: parent.height * 0.4 - sort_select_list.currentItem.y

            height: parent.height / 5 * songs_meta.length
            width: sort_select_bar.width
            model: sort_text
            delegate: sort_list_delegate
            orientation: ListView.Vertical
            interactive: false

            highlight: sort_list_hl
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
        id: song_select_bar
        z: 0
        width: parent.width/4
        height: parent.height
        opacity: current_state ? 1 : 0
        anchors {
            right: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }

        Behavior on opacity {
            NumberAnimation{
                duration:250
                easing.type: Easing.OutCubic
            }
        }

        Component {
            id: list_delegate

            Item {
                width: song_select_bar.width
                height: song_select_bar.height / 5

                Rectangle{
                    anchors.fill:parent
                    radius: height / 8

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

                    Text {
                        id: dif_value
                        text: after_sort[index][1] == -1 ? "0" : songs_meta[after_sort[index][0]][after_sort[index][1]].toString()
                        color: "#222222"
                        anchors {
                            left: parent.left
                            verticalCenter: parent.verticalCenter
                        }
                        font.family: font_Genjyuu_XP_bold.name
                        font.pixelSize: parent.height / 2
                    }

                    Item {
                        height: parent.height
                        width: height
                        anchors.centerIn: title_box

                        Text {
                            id: cov
                            text: songs_meta[after_sort[index][0]][2]
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
        }
        //白外框
        Component {
            id: list_hl
            Rectangle {
                color: "transparent"
                radius: 10
                z: 1
                border {
                    color: "white"
                    width: 10
                }

            }
        }

        ListView {
            id: select_list
            y: parent.height * 0.4 - currentItem.y

            height: parent.height / 5 * songs_meta.length
            width: song_select_bar.width
            //model: after_sort
            delegate: list_delegate
            orientation: ListView.Vertical
            interactive: false

            highlight: list_hl
            highlightMoveDuration: 0

            Behavior on y {
                NumberAnimation {
                    duration: 250
                    easing.type: Easing.OutExpo
                }
            }

            onCurrentIndexChanged: {
                if(current_state == 1){
                    dir.stopPreview();
                    dir.playEffect();
                    player_timer.restart();
                }
            }
        }

    }
    //song imformation
    Item {
        property double cont_margin: 40
        property double temp: 0

        id: data_panel
        width: parent.width * 0.5
        height: parent.height

        anchors {
            left : parent.horizontalCenter
            leftMargin: temp
            verticalCenter: parent.verticalCenter
        }

        Behavior on temp {
            NumberAnimation {
                duration: 500
                easing.type: Easing.OutCubic
            }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: 500
                easing.type: Easing.InOutExpo
            }
        }

        Image {
            id: current_jacket
            fillMode: Image.PreserveAspectFit
            source:"file:///" + songs_meta[after_sort[select_list.currentIndex][0]][0] + "/jacket.png"

            height: parent.height * 0.5
            width: parent.width * 0.5

            anchors {
                top: parent.top
                topMargin: data_panel.cont_margin
                left: parent.left
                leftMargin: data_panel.cont_margin
            }
        }

        Rectangle {
            id: current_bar

            color: "#222222"

            width: 20

            anchors {
                top: current_jacket.bottom
                topMargin: data_panel.cont_margin
                bottom: current_artist.bottom
                left: parent.left
                leftMargin: data_panel.cont_margin
            }
        }

        Text {
            id: current_title
            text: songs_meta[after_sort[select_list.currentIndex][0]][2]
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
                topMargin: data_panel.cont_margin
                left: current_bar.right
                leftMargin: data_panel.cont_margin
            }
        }

        Text {
            id: current_artist
            text: songs_meta[after_sort[select_list.currentIndex][0]][1]
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
                leftMargin: data_panel.cont_margin
            }
        }


        Rectangle {
            color: "white"
            opacity: 0

            anchors.fill: difficulty_frame
        }

        Item {
            id: difficulty_frame

            anchors {
                top: current_artist.bottom
                topMargin: 40
                left: parent.left
                leftMargin: data_panel.cont_margin*2
                bottom: parent.bottom
                bottomMargin: data_panel.cont_margin
                right: parent.right
                rightMargin: data_panel.cont_margin * 2
            }

            property double frame_margin: difficulty_frame.height / 4

            Row {
                spacing: parent.frame_margin *1.5
                anchors {
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }

                Item {
                    id: difficulty_basic
                    width: parent.parent.width / 3
                    height: parent.parent.frame_margin

                    Text {
                        text: ">"
                        color: "#222222"
                        font.family: font_hemi_head.name
                        font.pixelSize: parent.height * 0.8
                        visible: !select_expert

                        anchors {
                            left: parent.left
                            leftMargin: 50
                            verticalCenter: parent.verticalCenter
                        }
                    }

                    Rectangle {
                        id: basic_token
                        color: "forestgreen"
                        radius: this.height / 2
                        height: parent.height * 0.75
                        width: parent.width
                        anchors {
                            verticalCenter: parent.verticalCenter
                            right: parent.horizontalCenter
                        }

                        Text {
                            text: "BASIC  " + songs_meta[after_sort[select_list.currentIndex][0]][6]
                            font.family: font_hemi_head.name
                            color: "white"
                            font.pixelSize: parent.height * 0.8

                            anchors.centerIn: parent
                        }
                    }

                    Text {
                        id: highscore_basic
                        text: "0000000"
                        color: "#222222"
                        font.family: font_hemi_head.name
                        font.pixelSize: parent.height * 0.8

                        anchors {
                            top: basic_token.bottom
                            left: basic_token.left
                            verticalCenter: parent.verticalCenter
                        }
                    }
                }

                Item {
                    id: difficulty_expert
                    width: parent.parent.width / 3
                    height: parent.parent.frame_margin

                    Text {
                        text: ">"
                        color: "#222222"
                        font.family: font_hemi_head.name
                        font.pixelSize: parent.height / 3
                        visible: select_expert

                        anchors {
                            left: parent.left
                            leftMargin: 50
                            //verticalCenter: parent.verticalCenter
                        }
                    }

                    Rectangle {
                        id: expert_token
                        color: "firebrick"
                        radius: this.height / 2
                        height: parent.height * 0.75
                        width: parent.width
                        anchors {
                            verticalCenter: parent.verticalCenter
                            right: parent.horizontalCenter
                        }

                        Text {
                            text: "EXPERT  " + songs_meta[after_sort[select_list.currentIndex][0]][7]
                            font.family: font_hemi_head.name
                            color: "white"
                            font.pixelSize: parent.height * 0.8

                            anchors.centerIn: parent
                        }
                    }

                    Text {
                        id: highscore_expert
                        text: "0000000"
                        color: "#222222"
                        font.family: font_hemi_head.name
                        font.pixelSize: parent.height * 0.8

                        anchors {
                            top:  expert_token.bottom
                            left: expert_token.left
                            verticalCenter: parent.verticalCenter
                        }
                    }
                }

            }
        }

    }

    Timer {
        id: player_timer
        interval: 1000
        repeat: false
        onTriggered: {
            dir.playPreview("file:///" + songs_meta[song_index][0] + "/audio.wav", songs_meta[song_index][4])
            data_panel.temp = 0
            data_panel.opacity = 1
        }
    }

    FontLoader {
        id: font_Genjyuu_XP_bold
        source: "/font/GenJyuuGothicX-P-Bold.ttf"
    }

    FontLoader {
        id: font_hemi_head
        source: "/font/hemi-head-bd-it.ttf"
    }

    function right_press () {
        if (current_state == false){
            current_state = true
            after_sort = []
            sorting(sort_select_list.currentIndex)
            select_list.model = after_sort
            player_timer.restart();
        }
        else
            select_expert = !select_expert

    }

    function left_press () {
        if(current_state == true){
            current_state =false
            dir.stopPreview()
        }
    }

    function up_press() {
        if(current_state == false)
            sort_select_list.decrementCurrentIndex()
        else{
            select_list.decrementCurrentIndex()
            console.log(select_list.currentItem.y)
        }
    }

    function down_press () {
        data_panel.temp = -parent.width / 2
        data_panel.opacity = 0
        if(current_state == false)
            sort_select_list.incrementCurrentIndex()
        else{
            select_list.incrementCurrentIndex()
            console.log(select_list.currentItem.y)
        }
    }

    function to_main () {
        //pageloader.source = "/ui/option/option_menu.qml"
        Qt.quit()
    }

    function select() {
        game_transition.state = "LOADING"
        disconnect_all();
        var data = songs_meta[select_list.currentIndex]
        data.push(select_expert)
        mainqml.song_data = data;
        destruct.start();
    }

    // 0 = artist , 1 = title , defalt = levels
    function sorting(x){
        switch(x){

            case 0:
                songs_meta.forEach(function(data,index){
                    after_sort.push([index,-1])
                })
                after_sort.sort(function(a,b){
                        if(songs_meta[a[0]][1].toUpperCase() < songs_meta[b[0]][1].toUpperCase() )
                            return -1
                        else
                            return 1
                    });
                break;

            case 1:
                songs_meta.forEach(function(data,index){
                    after_sort.push([index,-1])
                })
                after_sort.sort(function(a,b){
                    if( songs_meta[a[0]][2].toUpperCase() < songs_meta[b[0]][2].toUpperCase() )
                        return -1
                    else
                        return 1
                });
                break;

            default:
                for(var i = 1; i <= 10; i++ ){
                    songs_meta.forEach(function(data,index){
                        if(data[6]==i)
                            after_sort.push([index,6])
                        if(data[7]==i)
                            after_sort.push([index,7])
                    });
                }
                break;
        }
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
        mainqml.rightpress_signal.disconnect(next_song)
        mainqml.leftpress_signal.disconnect(prev_song)
        mainqml.downpress_signal.disconnect(chng_diff)
        mainqml.escpress_signal.disconnect(to_main)
        mainqml.enterpress_signal.disconnect(select)
    }

    Component.onDestruction: {
        disconnect_all();
    }

}
