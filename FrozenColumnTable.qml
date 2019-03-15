import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQml.Models 2.11

Item {
    id: element
    clip: true

    property Component columnHeader: Item {}
    property Component rowHeader: Item {}
    property Component cell: Item {}

    property int rowsCount: 0
    property int columnsCount: 0

    property alias columnHeaderHeight: luRectangle.height
    property alias rowHeaderWidth: luRectangle.width

    QtObject {
        id: __private
        property var columnWidths: ({})
        property var rowHeights: ({})

        function changeWidth(index, width) {
            columnWidths[index] = width
            widthChanged(index, width)
        }
        function changeHeight(index, height) {
            rowHeights[index] = height
            heightChanged(index, height)
        }

        signal widthChanged(int columnIndex, real newWidth)
        signal heightChanged(int rowIndex, real newHeight)
    }


    ResizableItem {
        id: luRectangle
        width: 20
        height: 20
        anchors.top: parent.top
        anchors.left: parent.left
    }

    Flickable {
        id: columnsFlickable
        clip: true
        anchors.left: luRectangle.right
        anchors.top: parent.top
        height: luRectangle.height
        anchors.right: verticalRightScrollBar.left
        contentWidth: contentRow.width
        ScrollBar.horizontal: horizontalBottomScrollBar
        boundsMovement:   Flickable.StopAtBounds
        Row {
            id: contentRow
            height: parent.height
            Repeater {
                height: parent.height
                ResizableItem {

                    height: parent.height
                    onHeightChanged: luRectangle.height = height
                    property int __index: index
                    Loader {
                        id: columnHeaderLoader
                        property int index: parent.__index
                        sourceComponent: columnHeader
                        height: parent.height
                        onLoaded: parent.width = width + parent.borderWidth
                    }
                    onWidthChanged: {
                        columnHeaderLoader.width = width
                        __private.changeWidth(index, width)
                    }
                }
                model: columnsCount
            }
        }
    }

    Flickable {
        id: rowsFlickable
        width: luRectangle.width
        clip: true
        anchors.left: parent.left
        anchors.top: luRectangle.bottom
        anchors.bottom: horizontalBottomScrollBar.top
        ScrollBar.vertical: verticalRightScrollBar
        contentHeight: contentColumn.height
        boundsMovement:   Flickable.StopAtBounds
        Column {
            id: contentColumn
            width: parent.width
            Repeater {
                anchors.left: parent.left
                ResizableItem {
                    id: rowHeaderItem
                    width: parent.width
                    property int __index: index
                    Loader {
                        id: rowHeaderLoader
                        property int index: rowHeaderItem.__index
                        sourceComponent: rowHeader
                        width: parent.width
                        //onLoaded: parent.width = width + parent.borderWidth
                    }
                    height: rowHeaderLoader.height
                    onWidthChanged: {
                        luRectangle.width = width
                        rowHeaderLoader.width = width
                    }

                    onHeightChanged: {
                        rowHeaderLoader.height = height
                        __private.changeHeight(index, height)
                    }

                }
                model: rowsCount
            }
        }
    }


    Flickable {
        clip: true
        //interactive: false
        anchors.bottom: horizontalBottomScrollBar.top
        anchors.right: verticalRightScrollBar.left
        anchors.left: luRectangle.right
        anchors.top: luRectangle.bottom
        ScrollBar.horizontal: horizontalBottomScrollBar
        ScrollBar.vertical: verticalRightScrollBar
        contentHeight: gridContent.height
        contentWidth: gridContent.width
        boundsMovement:   Flickable.StopAtBounds
        Grid {
            id: gridContent
            columns: columnsCount
            Repeater {
                model: columnsCount * rowsCount
                Item {
                    id: cellContent

                    Loader {
                        id: cellLoader
                        property int column: index % columnsCount
                        property int row: index / columnsCount
                        sourceComponent: cell
                        width: parent.width
                        height: parent.height
                    }

                    width: __private.columnWidths[cellLoader.column] || 0
                    height: __private.rowHeights[cellLoader.row] || 0
                    Connections {
                        target: __private
                        onWidthChanged: {
                            if (columnIndex==cellLoader.column) {
                                cellContent.width = newWidth
                            }
                        }
                        onHeightChanged: {
                            if (rowIndex==cellLoader.row) {
                                cellContent.height = newHeight
                            }
                        }
                    }
                }
            }
        }
    }

    ScrollBar {
        id: verticalRightScrollBar
        orientation: Qt.Vertical
        anchors.bottom: drRectangle.top
        anchors.top: parent.top
        anchors.right: parent.right
        size: columnsFlickable.contentWidth
    }
    ScrollBar {
        id: horizontalBottomScrollBar
        anchors.right: drRectangle.left
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        size: rowsFlickable.contentHeight
    }

    Rectangle {
        id: drRectangle
        width: verticalRightScrollBar.width
        height: horizontalBottomScrollBar.height
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        color: "lightgray"
    }

}
