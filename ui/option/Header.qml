import QtQuick 2.0

Text{
    FontLoader { id: font_Genjyuu_XP_bold; source: "qrc:/font/GenJyuuGothicX-P-Bold.ttf" }

    font.pixelSize: parent.height / 15
    font.family: font_Genjyuu_XP_bold.name
    color: "white"
    verticalAlignment: Text.AlignVCenter
}
