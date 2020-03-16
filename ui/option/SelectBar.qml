import QtQuick 2.0

Text {
    //height: parent.height/7

    FontLoader { id: font_Genjyuu_XP_bold; source: "qrc:/font/GenJyuuGothicX-P-Bold.ttf" }
    font.family: font_Genjyuu_XP_bold.name
    font.pixelSize: parent.height / 20
    verticalAlignment: Text.AlignVCenter
    //horizontalAlignment: Text.AlignHCenter
}
