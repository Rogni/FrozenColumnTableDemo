import QtQuick 2.0

Item {
    id: root
    property color borderColor: "gray"
    property int borderWidth: 2
    Rectangle {
        id: rightRect
        anchors.top: parent.top
        anchors.bottom: bottomRect.top
        anchors.right: parent.right
        width: borderWidth
        color: borderColor
        MouseArea {
            anchors.fill: parent
            drag {
                target: parent
                axis: Drag.XAxis
            }
            onMouseXChanged: {
                if(drag.active) {
                    root.width = root.width + mouseX
                    if(root.width < 10)
                        root.width = 10
                }
            }
            cursorShape: Qt.SizeHorCursor
        }
    }
    Rectangle {
        id: bottomRect
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        height: borderWidth
        color: borderColor
        MouseArea {
            anchors.fill: parent
            drag {
                target: parent
                axis: Drag.YAxis
            }
            onMouseYChanged: {
                if(drag.active) {
                    root.height = root.height + mouseY
                    if(root.height < 10)
                        root.height = 10
                }
            }

            cursorShape: Qt.SizeVerCursor
        }
    }
}
