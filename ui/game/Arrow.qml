import QtQuick 2.0

Image {
    id: arrow_img
    anchors.verticalCenter: parent.verticalCenter
    height: parent.height
    fillMode: Image.PreserveAspectFit
    source: "./arrow.png"
    opacity: 0.5

    transitions: Transition {
        NumberAnimation {
            property: "x"
            duration: 1000
            //alwaysRunToEnd: true
            onStopped: {
                console.log("destroyed")
                arrow_img.destroy()
            }
        }
    }

    states: [
        State {
            name: "MOVEL"
            PropertyChanges {
                target: arrow_img
                x:-parent.width
            }
        },
        State {
            name: "MOVER"
            PropertyChanges {
                target: arrow_img
                x:parent.width
            }
        }
    ]
}
