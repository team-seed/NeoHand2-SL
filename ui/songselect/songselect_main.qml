import QtQuick 2.12
import QtGraphicalEffects 1.0
import custom.songselect 1.0

Item {
    id: songselect_main_container

    property var songs_meta: dir.content
    property bool is_expert: false

    // 0 = select sorting mode , 1 = select song
    property bool current_state: false
    property bool is_level: false

    property string detail_display_jacket: ""
    property string detail_display_title: ""
    property string detail_display_artist: ""
    property int detail_display_basic_difficulty: 0
    property int detail_display_expert_difficulty: 0


    CustomSongselect { id: dir }

    //round count
    Item {
        z : 100
        width : parent.width * 0.3
        height : parent.height / 8
        anchors{
            top: parent.top
            left: parent.left
        }

        Image {
            id: topbar_frame
            source: "qrc:/ui/songselect/image/top_bar.png"
            fillMode: Image.PreserveAspectCrop
            horizontalAlignment: Image.AlignRight
            anchors.fill: parent
            opacity: .5
        }

        ColorOverlay{
            anchors.fill: topbar_frame
            source: topbar_frame
            color: "red"
            opacity: .5
        }

        Image {
            source: "qrc:/ui/songselect/image/top_bar.png"
            fillMode: Image.PreserveAspectCrop
            horizontalAlignment: Image.AlignRight
            width : parent.width
            height : parent.height
            anchors{
                bottom:  parent.bottom
                right:  parent.right
                bottomMargin: parent.height / 5
                rightMargin: parent.height / 8
            }
        }

    }

    //button hint
    Rectangle{
        width : parent.width / 4
        height : parent.height / 8
        color: "white"
        opacity: 0.7
        z : 100
        anchors{
            bottom: parent.bottom
            left: parent.left
        }
    }

    Sort_list { id: sort_selection_list }

    //temp background
    Rectangle {
        anchors.fill: parent
        color: "#777777"

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
        Image {
            //id: name
            source: "qrc:/ui/songselect/image/first_layer_background.png"
            anchors.fill: parent
        }

        Component {
            id: firstlayer_delegate

            Item {
                width: firstlayer.width
                height: firstlayer.height / 5


                Image {
                    source: "qrc:/ui/songselect/image/" + path
                    anchors.fill: parent
                }

                Image {
                    source: "qrc:/ui/songselect/image/first_layer_delegate.png"
                    anchors.fill: parent
                }

                function sortbythis () {
                    secondlayer_listview.model = song_sorting(sortfunc)
                    is_level = (sortfunc == "Level")
                }
            }   
        }

        //白外框
        Component {
            id: firstlayer_hl

            Rectangle {
                color: "transparent"
                radius: 10
                z:3
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
                property int song_index: secondlayer_listview.model[index][0]
                property int song_difficulty: secondlayer_listview.model[index][1]

                width: secondlayer.width
                height: secondlayer.height / 5

                Rectangle {
                    color: "#222222"
                    opacity: 0.7
                    width: parent.width * 0.7
                    height: parent.height
                    anchors{
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                    }
                    Text {
                        text: songs_meta[song_index][2]
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        anchors.centerIn: parent
                        wrapMode: Text.WordWrap
                        width: parent.width
                        font.family: font_Genjyuu_XP_bold.name
                        font.pixelSize: parent.height / 8
                    }
                }

                Rectangle{
                    color: "white"
                    opacity: 0.7
                    width: parent.width * 0.3
                    height: parent.height
                    anchors{
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                    }
                    Image {
                        id: secondlayer_dif_img
                        source: "qrc:/ui/songselect/image/difficulty_frame_" +  ( (!is_level && is_expert) || (is_level && song_difficulty == 7) ? "expert.png" : "basic.png")
                        fillMode: Image.PreserveAspectFit
                        width: parent.width
                        height: parent.height
                        transform: Rotation{origin.x: secondlayer_dif_img.width / 2 ; axis {x: 0; y: 1; z: 0} angle: 180}
                        anchors {
                            left: parent.left
                            verticalCenter: parent.verticalCenter
                        }
                    }
                    Text {
                        text: is_level ? songs_meta[song_index][song_difficulty] : (is_expert ? songs_meta[song_index][7] : songs_meta[song_index][6])
                        font.family: font_hemi_head.name
                        color: "white"
                        font.pixelSize: parent.height * 0.3
                        anchors.left: secondlayer_dif_img.left
                        leftPadding: secondlayer_dif_img.width / 6
                        topPadding: secondlayer_dif_img.height / 10
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
            y: parent.height * 0.4 - (currentItem !== null ? currentItem.y : 0)

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

                    detail_display_jacket = "file:///" + songs_meta[currentItem.song_index][0] + "/jacket"
                    detail_display_artist = songs_meta[currentItem.song_index][1]
                    detail_display_title = songs_meta[currentItem.song_index][2]
                    detail_display_basic_difficulty = songs_meta[currentItem.song_index][6]
                    detail_display_expert_difficulty = songs_meta[currentItem.song_index][7]
                }
            }

            Component.onCompleted: positionViewAtIndex(0, ListView.Contain)
        }

    }

    //song information
    Item {
        id: detail_panel

        //margin
        property double panel_margin: width / 16

        width: parent.width * 0.5
        height: parent.height

        anchors {
            left : parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }

        //jacket
        Image {
            id: current_jacket

            width: parent.width / 2
            height: width

            anchors {
                margins: detail_panel.panel_margin
                top: parent.top
                left: parent.left
            }

            fillMode: Image.PreserveAspectFit
            source: detail_display_jacket //"file:///" + songs_meta[secondlayer_listview.model[secondlayer_listview.currentIndex][0]][0] + "/jacket.png"
        }

        //bar background
        Rectangle {
            id: bar_bg

            height: current_bar.height + detail_panel.panel_margin

            anchors {
                left: parent.left
                right: parent.right
                verticalCenter: current_bar.verticalCenter
            }

            color: "#DDDDDD"
            opacity: 0.5

        }

        //bar
        Rectangle {
            id: current_bar

            height: current_jacket.height / 4
            width: height / 6

            anchors {
                margins: detail_panel.panel_margin
                top: current_jacket.bottom
                left: parent.left
            }

            color: "#222222"
        }

        // title & artist
        Item {
            anchors {
                top: current_bar.top
                bottom: current_bar.bottom
                right: parent.right
                rightMargin: detail_panel.panel_margin
                left: current_bar.right
                leftMargin: detail_panel.panel_margin / 2
            }

            //title
            Text {
                id: current_title
                height: current_artist.height * 2

                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }

                text: detail_display_title
                color: "white"
                font.family: font_Genjyuu_XP_bold.name
                font.pixelSize: height
                minimumPixelSize: 10

                fontSizeMode: Text.Fit
                verticalAlignment: Text.AlignVCenter
                style: Text.Raised
                styleColor: "black"
            }

            //artist
            Text {
                id: current_artist

                height: parent.height / 3

                anchors {
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                }

                text: detail_display_artist
                color: "white"
                font.family: font_Genjyuu_XP_bold.name
                font.pixelSize: height
                minimumPixelSize: 10

                fontSizeMode: Text.Fit
                verticalAlignment: Text.AlignVCenter
                style: Text.Raised
                styleColor: "black"
            }

        }

        // difficulties
        Item {
            id: box_container

            height: current_bar.height * 2

            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                margins: detail_panel.panel_margin
            }

            //basic
            Item {
                id: box_basic
                height: parent.height
                width: height * 1.5

                anchors {
                    left: parent.left
                    bottom: parent.bottom
                }

                //basic text
                Rectangle {
                    color: "#222222"
                    height: parent.height * 2 / 3
                    width: parent.width
                    anchors.top: parent.top

                    Text {
                        text: "BASIC"
                        font.family: font_hemi_head.name
                        color: "#DDDDDD"
                        font.pixelSize: parent.height * 0.375
                        anchors{
                            bottom: parent.bottom
                            left: parent.left
                            margins: parent.width * 0.03
                        }
                    }
                }

                //score
                Rectangle {
                    color: "#DDDDDD"
                    height: parent.height / 3
                    width: parent.width

                    anchors.bottom:  parent.bottom

                    Text {
                        id: highscore_basic
                        text: "0000000"
                        font.family: font_hemi_head.name
                        color: "#444444"
                        font.pixelSize: parent.height * 0.75
                        anchors.left: parent.left
                        anchors.margins: parent.width * 0.03
                    }
                }
                //difficulty_val
                Image {
                    source: "qrc:/ui/songselect/image/difficulty_frame_basic.png"
                    fillMode: Image.PreserveAspectFit
                    width: parent.width / 2
                    height: parent.height
                    anchors {
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: detail_display_basic_difficulty

                        width: parent.width * 0.7
                        height: width

                        anchors.right: parent.right
                        anchors.top: parent.top

                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        font.family: font_hemi_head.name
                        font.pixelSize: parent.height * 0.3

                    }
                }
            }

            //expert
            Item{
                id: box_expert

                height: parent.height
                width: height * 1.5

                anchors {
                    right: parent.right
                    bottom: parent.bottom
                }

                //expert text
                Rectangle {
                    color: "#222222"
                    height: parent.height * 2/3
                    width: parent.width
                    anchors.top: parent.top

                    Text {
                        text: "EXPERT"
                        font.family: font_hemi_head.name
                        color: "#DDDDDD"
                        font.pixelSize: parent.height * 0.375
                        anchors{
                            bottom: parent.bottom
                            left: parent.left
                            margins: parent.width * 0.03
                        }
                    }
                }

                //score
                Rectangle {
                    color: "#DDDDDD"
                    height: parent.height / 3
                    width: parent.width
                    anchors.bottom:  parent.bottom

                    Text {
                        id: highscore_expert
                        text: "0000000"
                        font.family: font_hemi_head.name
                        color: "#444444"
                        font.pixelSize: parent.height * 0.75
                        anchors.left: parent.left
                        anchors.margins: parent.width * 0.03
                    }
                }

                //difficulty_val
                Image {
                    source: "qrc:/ui/songselect/image/difficulty_frame_expert.png"
                    fillMode: Image.PreserveAspectFit
                    width: parent.width / 2
                    height: parent.height
                    anchors {
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                    }
                    Text {
                        text: detail_display_expert_difficulty

                        width: parent.width * 0.7
                        height: width

                        anchors.right: parent.right
                        anchors.top: parent.top

                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        font.family: font_hemi_head.name
                        font.pixelSize: parent.height * 0.3
                    }
                }
            }
        }
    }

    //preview
    Timer {
        id: player_timer
        interval: 1000
        repeat: false
        onTriggered: {
            //dir.playPreview("file:///" + songs_meta[song_index][0] + "/audio.wav", songs_meta[song_index][4])
        }
    }

    //[[index,dif(-1,6,7)]]
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
                        if(data[6] == i)
                            list.push([index,6])
                        if(data[7] == i)
                            list.push([index,7])
                    });
                }
                break;
        }
        return list
    }

    function right_press () {
        if (current_state) {
            is_expert = !is_expert
        }
        else {
            current_state = true
            firstlayer_listview.currentItem.sortbythis()
        }
    }

    function left_press () {
        if(current_state){
            current_state = false
            dir.stopPreview()

            detail_display_jacket = ""
            detail_display_artist = ""
            detail_display_title = ""
            detail_display_basic_difficulty = 0
            detail_display_expert_difficulty = 0
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
