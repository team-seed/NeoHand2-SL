import QtQuick 2.0

Rectangle{
    id: rect
    color: "transparent"
    height: 40
    width: 300
    radius: 10

    states: [
        State {
            name: "Pressed"
            PropertyChanges {
                target: rect
                color: "red"
            }
        },
        State {
            name: "released"
            PropertyChanges {
                target: rect
                color: "transparent"
            }
        }
    ]
}
