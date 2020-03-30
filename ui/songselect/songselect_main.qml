import QtQuick 2.12
import QtQuick.Shapes 1.12
import QtGraphicalEffects 1.0
import custom.songselect 1.0

Item {
    id: songselect_main_container

    property var songs_meta: dir.content
    property bool is_expert: false

    // 0 = select sorting mode , 1 = select song
    property bool is_secondlayer: false
    property bool is_level: false

    //in sort by level, difficulty changes should not replay bgm
    property bool bgmplay: true

    property string detail_display_jacket: ""
    property string detail_display_title: ""
    property string detail_display_artist: ""
    property int detail_display_basic_difficulty: 0
    property int detail_display_expert_difficulty: 0

    property double pulse_bpm: 140

    property string effect_color: "white"

    property int track_count: 4
    property int time_remaining: 99

    CustomSongselect { id: dir }

    Shape{

        width:  parent.width / 8
        height: width
        z:999

        antialiasing: true

        anchors{
            top: parent.top
            right: parent.right
        }
        ShapePath{
            strokeWidth: -1
            fillColor: "#222222"
            startX: parent.width
            startY: 0
            PathLine {x:parent.parent.width; y:0; }
            PathLine {x:parent.parent.width; y:parent.width; }
            PathLine {x:parent.parent.width - parent.width; y:0; }
        }

        Text {
            id:count_down
            height: parent.height / 4
            width: height * 1.2
            transformOrigin: Text.Center
            rotation: 45
            anchors {
                top: parent.top
                right: parent.right
                topMargin: parent.height / 8
                rightMargin: parent.width / 6
            }

            text: time_remaining.toString()
            color: "#888888"
            font.family: font_hemi_head.name
            font.pixelSize: parent.height * 0.4

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    //round count
    Item {
        z: 100
        width: parent.width * 0.25
        height: parent.height / 10
        anchors{
            top: parent.top
            topMargin: height / 8
            left: parent.left
        }

        Image {
            id: topbar_frame
            source: "qrc:/ui/songselect/image/top_bar.png"
            fillMode: Image.PreserveAspectCrop
            horizontalAlignment: Image.AlignRight
            anchors.fill: parent
            mipmap: true
            visible: false
        }

        Item {
            id: topbar_img
            anchors.fill: parent

            Image {
                property double mg: parent.height / 10

                source: "qrc:/ui/songselect/image/top_bar.png"
                fillMode: Image.PreserveAspectCrop
                horizontalAlignment: Image.AlignRight
                anchors.fill: parent
                mipmap: true


                anchors {
                    //topMargin: mg
                    //bottomMargin: mg
                    rightMargin: mg * 3
                }
            }

            visible: false
        }

        OpacityMask {
            id: topbar_masked
            anchors.fill: parent
            source: topbar_frame
            maskSource: topbar_img
            invert: true
            visible: false
            opacity: 0.5
        }

        ColorOverlay {
            id: topbar_light
            anchors.fill: parent
            source: topbar_masked
            color: is_secondlayer ? effect_color : "white"

            NumberAnimation on opacity {
                duration: 60000 / pulse_bpm
                loops: Animation.Infinite
                from: 0.9
                to: 0.5
                easing.type: Easing.OutCubic
            }
        }

        ColorOverlay{
            id: topbar_overlay
            anchors.fill: topbar_img
            source: topbar_img
            color: "#222222"
        }

        Item {
            id: topbar_text
            anchors.fill: parent
            Text {
                id: topbar_number
                text: switch (track_count) {
                      case 0: return "Event"
                      case 1: return "1"
                      case 2: return "2"
                      case 3: return "3"
                      case 4: return "EX "
                      }
                anchors.left: parent.left
                anchors.leftMargin: parent.height * 0.35

                color: "white"
                font.family: font_hemi_head.name
                font.pixelSize: parent.height * 0.8
            }

            Text {
                text: switch (track_count) {
                      case 0: return ""
                      case 1: return "st track"
                      case 2: return "nd track"
                      case 3: return "rd track"
                      case 4: return "track"
                      }
                anchors.left: topbar_number.right
                anchors.verticalCenter: topbar_number.verticalCenter

                color: "#DDDDDD"
                font.family: font_hemi_head.name
                font.pixelSize: parent.height * 0.5
            }
        }

        DropShadow {
            anchors.fill: parent
            source: topbar_text
            horizontalOffset: parent.height * 0.04
            verticalOffset: horizontalOffset
            color: "#666666"
        }

    }

    //button hint
    Item {
        id: bottombar
        z : 100
        width : parent.width * 0.32
        height : parent.height / 8
        anchors{
            bottom: parent.bottom
            left: parent.left
        }

        transform: Rotation { origin.y: bottombar.height / 2; axis { x:1; y:0; z:0 } angle: 180 }

        Image {
            id: btmbar_frame
            source: "qrc:/ui/songselect/image/top_bar.png"
            fillMode: Image.PreserveAspectCrop
            horizontalAlignment: Image.AlignRight
            anchors.fill: parent
            visible: false
        }

        Item {
            id: btmbar_img
            anchors.fill: parent

            Image {
                property double mg: parent.height / 10

                source: "qrc:/ui/songselect/image/top_bar.png"
                fillMode: Image.PreserveAspectCrop
                horizontalAlignment: Image.AlignRight
                anchors.fill: parent

                anchors {
                    //topMargin: mg
                    bottomMargin: mg
                    rightMargin: mg * 1.5
                }
            }

            visible: false
        }

        OpacityMask {
            id: btmbar_masked
            anchors.fill: parent
            source: btmbar_frame
            maskSource: btmbar_img
            invert: true
            visible: false
        }

        ColorOverlay {
            id: btmbar_overlay
            anchors.fill: parent
            source: btmbar_masked
            color: is_secondlayer ? effect_color : "white"

            NumberAnimation on opacity {
                duration: 60000 / pulse_bpm
                loops: Animation.Infinite
                from: 0.9
                to: 0.5
                easing.type: Easing.OutCubic
            }
        }

        ColorOverlay{
            anchors.fill: btmbar_img
            source: btmbar_img
            color: "#222222"
        }
    }

    Sort_list { id: sort_selection_list }

    //temp background
    Image {
        id: tmp_bg
        source: "qrc:/ui/songselect/image/neohand2BG.png"
        anchors.fill:parent
    }

    //select song
    Item {
        id: secondlayer

        width: parent.width / 4
        height: parent.height
        opacity: is_secondlayer ? 1 : 0
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
                id: current_song
                property int song_index: secondlayer_listview.model[index][0]
                property int song_difficulty: Math.max(secondlayer_listview.model[index][1], 6)

                width: secondlayer.width
                height: secondlayer.height / 6

                visible: (y < songselect_main_container.height || y > -height)

                transform: Scale {
                    origin.x: current_song.width / 2
                    origin.y: current_song.height / 2
                    xScale: current_song.ListView.isCurrentItem ? 1 : 0.75
                    yScale: current_song.ListView.isCurrentItem ? 1 : 0.75

                    Behavior on xScale {
                        NumberAnimation {
                            duration: 250
                            easing.type: Easing.OutExpo
                        }
                    }

                    Behavior on yScale {
                        NumberAnimation {
                            duration: 250
                            easing.type: Easing.OutExpo
                        }
                    }
                }

                Rectangle {
                    width: parent.width
                    height: parent.height * 0.1
                    anchors.top: parent.top
                    color: "#222222"
                    opacity: 0.5
                }

                Rectangle {
                    id: middle_frame
                    width: parent.width
                    height: parent.height * 0.8
                    anchors.centerIn: parent
                    //color: songs_meta[song_index][5]

                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0; color: "#222222" }
                        GradientStop { position: 0.22; color: songs_meta[song_index][5] }
                    }

                    layer.enabled: true
                    layer.effect: HueSaturation { saturation: -0.1; lightness: -0.1 }
                }

                Rectangle {
                    width: parent.width
                    height: parent.height * 0.8
                    anchors.centerIn: parent
                    opacity: 0.5

                    gradient: Gradient {
                        GradientStop { position: 0.18; color: "transparent" }
                        GradientStop { position: 0.2; color: "#222222" }
                        GradientStop { position: 0.8; color: "#222222" }
                        GradientStop { position: 0.82; color: "transparent" }
                    }

                }

                Item {
                    id: decoration

                    anchors.fill: middle_frame

                    Image {
                        source: "qrc:/ui/songselect/image/second_layer_delegate_decoration.png"

                        height: parent.height
                        fillMode: Image.PreserveAspectFit

                        NumberAnimation on x {
                            running: current_song.ListView.isCurrentItem
                            duration: 3000
                            loops: Animation.Infinite
                            from: -width
                            to: decoration.width
                        }
                    }
                    visible: false
                }

                OpacityMask {
                    anchors.fill: middle_frame
                    source: decoration
                    maskSource: middle_frame
                    opacity: 0.1

                    visible: current_song.ListView.isCurrentItem
                }

                Rectangle {
                    width: parent.width
                    height: parent.height * 0.1
                    anchors.bottom: parent.bottom
                    color: "#222222"
                    opacity: 0.5
                }

                Text {
                    id: delegate_text
                    anchors {
                        right: parent.right
                        rightMargin: parent.height * 0.1
                        left: secondlayer_dif_img.right
                        verticalCenter: parent.verticalCenter
                    }

                    height: parent.height * 0.45

                    text: songs_meta[song_index][2]
                    color: "white"

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    wrapMode: Text.WordWrap
                    font.family: font_Genjyuu_XP_bold.name
                    fontSizeMode: Text.Fit
                    font.pixelSize: height * 0.8

                    style: "Raised"
                    styleColor: "#222222"
                }

                Image {
                    id: secondlayer_dif_img
                    source: "qrc:/ui/songselect/image/difficulty_frame_" +  ( (!is_level && is_expert) || (is_level && song_difficulty == 7) ? "expert.png" : "basic.png")
                    fillMode: Image.PreserveAspectFit
                    width: height * 0.75
                    height: parent.height
                    transform: Rotation{ origin.x: secondlayer_dif_img.width / 2; axis {x: 0; y: 1; z: 0} angle: 180 }
                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                    }
                }

                Text {
                    text: is_level ? songs_meta[song_index][song_difficulty] : (is_expert ? songs_meta[song_index][7] : songs_meta[song_index][6])

                    width: secondlayer_dif_img.width * 0.5
                    height: width * 1.5

                    anchors.left: secondlayer_dif_img.left
                    anchors.top: secondlayer_dif_img.top

                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.family: font_hemi_head.name
                    font.pixelSize: secondlayer_dif_img.height * 0.3

                }

                layer.enabled: !ListView.isCurrentItem
                layer.effect: BrightnessContrast {
                    brightness: -0.4
                    contrast: -0.2
                }
            }
        }

        ListView {
            id: secondlayer_listview

            y: parent.height * 5 / 12 - (currentItem !== null ? currentItem.y : 0)
            height: parent.height / 5 * count
            width: secondlayer.width
            model: []
            delegate: secondlayer_delegate
            orientation: ListView.Vertical
            interactive: false

            Behavior on y {
                NumberAnimation {
                    duration: 250
                    easing.type: Easing.OutExpo
                }
            }

            onCurrentIndexChanged: {
                if (is_secondlayer) {
                    if (bgmplay) {
                        dir.stopPreview();
                        dir.playEffect();
                        player_timer.restart();
                    }
                    bgmplay = true

                    detail_display_jacket = "file:///" + songs_meta[currentItem.song_index][0] + "/jacket"
                    detail_display_artist = songs_meta[currentItem.song_index][1]
                    detail_display_title = songs_meta[currentItem.song_index][2]
                    detail_display_basic_difficulty = songs_meta[currentItem.song_index][6]
                    detail_display_expert_difficulty = songs_meta[currentItem.song_index][7]

                    effect_color = songs_meta[currentItem.song_index][5]

                    if (is_level) {
                        is_expert = (currentItem.song_difficulty == 7)
                        firstlayer_listview.level_change(songs_meta[currentItem.song_index][currentItem.song_difficulty])
                    }

                    change_anim.restart()
                }


            }

            function level_dif_change(){
                for(var i = 0; i <count ;i++){
                    if( i != currentIndex && model[i][0] == model[currentIndex][0] ){
                        bgmplay = false
                        currentIndex = i
                        firstlayer_listview.level_change(songs_meta[currentItem.song_index][currentItem.song_difficulty])
                        break;
                    }
                }
            }
        }

        //arrows
        Item {
            id: secondlayer_arrows
            anchors.fill: parent
            property double offset: 0

            Image {
                id: secondlayer_uparrow

                source: "qrc:/ui/songselect/image/select_arrow_new.png"
                fillMode: Image.PreserveAspectFit
                height: parent.width / 10
                width: height
                anchors.centerIn: parent
                anchors.verticalCenterOffset: - parent.height / 8 - parent.offset

                transformOrigin: Item.Center
                rotation: -90
            }

            Image {
                id: secondlayer_downarrow

                source: "qrc:/ui/songselect/image/select_arrow_new.png"
                fillMode: Image.PreserveAspectFit
                height: parent.width / 10
                width: height
                anchors.centerIn: parent
                anchors.verticalCenterOffset: parent.height / 8 + parent.offset

                transformOrigin: Item.Center
                rotation: 90
            }

            SequentialAnimation on offset {
                loops: Animation.Infinite
                NumberAnimation {
                    duration: 500
                    from: -to;
                    to: secondlayer_uparrow.width / 4
                    easing.type: Easing.InCirc
                }
                NumberAnimation {
                    duration: 500
                    from: secondlayer_uparrow.width / 4; to: -from
                    easing.type: Easing.OutCirc
                }
            }
        }

        Glow {
            source: secondlayer_arrows
            anchors.fill: source
            color: "#222222"
        }
    }

    //select sort
    Item {
        id: firstlayer

        width: parent.width / 4
        height: parent.height

        anchors {
            right: parent.horizontalCenter
            rightMargin: is_secondlayer ? width : 0
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
                visible: (y < songselect_main_container.height || y > -height)

                Item {
                    id: firstlayer_container
                    anchors.fill: parent
                    Image {
                        source: "qrc:/ui/songselect/image/" + path
                        anchors.fill: parent
                    }

                    Image {
                            source: "qrc:/ui/songselect/image/first_layer_delegate.png"
                            anchors.fill: parent
                        }
                }

                BrightnessContrast {
                    source: firstlayer_container
                    anchors.fill: source
                    z: 4
                    brightness: -0.4
                    contrast: -0.6
                    opacity: (is_secondlayer && !parent.ListView.isCurrentItem) ? 1 : 0
                    Behavior on opacity {
                        NumberAnimation{
                            duration: 250
                            easing.type: Easing.OutExpo
                        }
                    }
                }

                function sortbythis () {
                    //secondlayer_listview.currentIndex = -1
                    is_level = (sortfunc == "Level")
                    secondlayer_listview.model = song_sorting(sortfunc)
                    if (is_level) {
                        secondlayer_listview.model.every( (element,index) => {
                                                             if(songs_meta[element[0]][element[1]] >= lv){
                                                                 secondlayer_listview.currentIndex = index
                                                                 return false
                                                             }
                                                             return true
                                                         })
                    }

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

            Behavior on y {
                NumberAnimation {
                    duration: 250
                    easing.type: Easing.OutExpo
                }
            }

            function level_change(current_level){
                currentIndex = model.get_level_index(current_level)
            }

        }

    }

    //song information(detail_panel)
    Item {
        anchors.fill: parent

        layer.enabled: true
        layer.effect: OpacityMask{
            maskSource: mask_rec
        }

        Item {
            id: detail_panel
            //margin
            property double panel_margin: width / 16

            width: parent.width * 0.5
            height: parent.height

            anchors {
                right : parent.right
                rightMargin: is_secondlayer ? 0 : width
                verticalCenter: parent.verticalCenter
            }

            opacity: is_secondlayer ? 1 : 0

            Behavior on anchors.rightMargin {
                NumberAnimation{
                    duration: 250
                    easing.type: Easing.OutExpo
                }
            }

            Behavior on opacity {
                NumberAnimation{
                    duration: 250
                    easing.type: Easing.OutExpo
                }
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
                source: detail_display_jacket
            }

            DropShadow {
                anchors.fill: current_jacket
                source: current_jacket
                horizontalOffset: current_jacket.width * 0.02
                verticalOffset: horizontalOffset
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

                gradient: Gradient {
                    orientation: Gradient.Horizontal

                    GradientStop { position: 0.02; color: "transparent" }
                    GradientStop { position: 0.04; color: "#222222" }
                }
                opacity: 0.5
            }

            LinearGradient{
                anchors.fill: bar_bg

                NumberAnimation on opacity {
                    duration: 60000 / pulse_bpm
                    loops: Animation.Infinite
                    //easing.type: Easing.InExpo
                    from: 0.8
                    to: 0.5
                }

                gradient: Gradient{
                    orientation: Gradient.Horizontal
                    GradientStop{ position: 1; color: effect_color }
                    GradientStop{ position: 0.5; color: "transparent" }
                }
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

            //title & artist
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
                    width: parent.width

                    anchors {
                        top: parent.top
                        left: parent.left
                        //right: parent.right
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
                    width: parent.width

                    anchors {
                        bottom: parent.bottom
                        left: parent.left
                        //right: parent.right
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
                    z: is_expert ? 4 : 5

                    anchors {
                        left: parent.left
                        leftMargin: is_expert ? box_container.width - box_basic.width : 0
                        bottom: parent.bottom
                    }

                    Behavior on anchors.leftMargin {
                        NumberAnimation {
                            duration: 250
                            easing.type: Easing.OutExpo
                        }
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
                    z: is_expert ? 5 : 4

                    anchors {
                        right: parent.right
                        rightMargin: is_expert ? box_container.width - box_expert.width : 0
                        bottom: parent.bottom
                    }

                    Behavior on anchors.rightMargin {
                        NumberAnimation {
                            duration: 250
                            easing.type: Easing.OutExpo
                        }
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

                BrightnessContrast {
                    id: box_effect
                    anchors.fill: source
                    source: is_expert ? box_basic : box_expert
                    z: 4
                    brightness: -0.65
                    contrast: -0.65
                }

                //arrow
                Image {
                    id: box_arrow

                    source: "qrc:/ui/songselect/image/select_arrow_new.png"
                    fillMode: Image.PreserveAspectFit
                    height: parent.height / 5
                    width: height
                    anchors.centerIn: parent

                    SequentialAnimation on anchors.horizontalCenterOffset {
                        loops: Animation.Infinite
                        NumberAnimation {
                            duration: 500
                            from: -to;
                            to: box_arrow.width / 4
                            easing.type: Easing.InCirc
                        }
                        NumberAnimation {
                            duration: 500
                            from: box_arrow.width / 4; to: -from
                            easing.type: Easing.OutCirc
                        }
                    }
                }

                Glow {
                    anchors.fill: box_arrow
                    source: box_arrow
                    color: "#222222"
                }
            }

            DropShadow {
                anchors.fill: box_container
                source: box_container
                horizontalOffset: box_container.width * 0.01
                verticalOffset: horizontalOffset
            }

            ParallelAnimation {
                id: change_anim

                NumberAnimation {
                    target: current_jacket
                    property: "anchors.leftMargin"
                    duration: 250
                    easing.type: Easing.OutExpo
                    from: 0; to: detail_panel.panel_margin
                }

                NumberAnimation {
                    targets: [current_title, current_artist]
                    property: "anchors.leftMargin"
                    duration: 250
                    easing.type: Easing.OutExpo
                    from: -detail_panel.panel_margin; to: 0
                }

                NumberAnimation {
                    targets: [current_title, current_artist, current_jacket]
                    property: "opacity"
                    duration: 250
                    easing.type: Easing.OutExpo
                    from: 0; to: 1
                }
            }

        }
    }

    //detail_panel mask
    Item {
        id: mask_rec
        anchors.fill: parent
        visible: false
        Rectangle{
            height: parent.height
            width: parent.width / 2
            anchors.right: parent.right
        }
    }

    //preview
    Timer {
        id: player_timer
        interval: 1000
        repeat: false
        onTriggered: {
            dir.playPreview("file:///" + songs_meta[secondlayer_listview.model[secondlayer_listview.currentIndex][0]][0] + "/audio.wav", songs_meta[secondlayer_listview.model[secondlayer_listview.currentIndex][0]][4])
        }
    }

    //count down


    Timer{
        id: count_down_timer
        interval: 1000
        repeat: true
        onTriggered: if(time_remaining > 0) time_remaining --
        Component.onCompleted: count_down_timer.start()
    }

    onIs_secondlayerChanged: {
        if(is_secondlayer)
            player_timer.restart();
        else{
            dir.stopPreview();
            player_timer.stop()
        }
    }

    //[[index,dif(-1,6,7)]]
    function song_sorting (method) {
        var list = [];

        if (method === "Level") {
            songs_meta.forEach((data, index) => {
                                   list_insert_normal(index, "Basic")
                                   list_insert_normal(index, "Expert")
                               })
        }
        else
            songs_meta.forEach((data, index) => { list_insert_normal(index, method) })

        return list

        function get_meta_value (index, type) {
            switch (type) {
            case "Artist": case 1: return [songs_meta[index][1].toUpperCase(), 1]
            case "Title": case 2: return [songs_meta[index][2].toUpperCase(), 2]
            case "Basic": case 6: return [songs_meta[index][6], 6]
            case "Expert": case 7: return [songs_meta[index][7], 7]
            }
        }

        function list_insert_normal (index, type) {
            var str, dif
            [str, dif] = get_meta_value(index, type)
            var contain = false

            for (var i = 0; i < list.length; i++) {
                if (str < get_meta_value(list[i][0], list[i][1])[0]) {
                    list.splice(i, 0, [index, dif])
                    contain = true
                    break
                }
            }

            if (!contain) { list.push([index, dif]) }
        }
    }

    function right_press () {
        if (is_secondlayer) {
            if (is_level)
                secondlayer_listview.level_dif_change()
            else
                is_expert = !is_expert
        }
        else {
            is_secondlayer = true
            firstlayer_listview.currentItem.sortbythis()
        }
    }

    function left_press () {
        if(is_secondlayer){
            is_secondlayer = false
            dir.stopPreview()
        }
    }

    function up_press() {
        (is_secondlayer ? secondlayer_listview : firstlayer_listview).decrementCurrentIndex()
    }

    function down_press () {
        (is_secondlayer ? secondlayer_listview : firstlayer_listview).incrementCurrentIndex()
    }

    function to_main () {
        //pageloader.source = "/ui/option/option_menu.qml"
        Qt.quit()
    }

    function select() {
        if(!is_secondlayer) {
            is_secondlayer = true
            firstlayer_listview.currentItem.sortbythis()
        }
        //disconnect_all();
        //destruct.start();
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
