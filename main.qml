import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.4

Window {
    visible: true
    width: 200
    height: 100
    title: qsTr("Hello World")

    Component.onCompleted: {
        var rows = []
        var columns = []
        var cells = []
        var rowsCount = 20
        var columnsCount = 10
        for (var column = 0; column < columnsCount; ++column) {
            columns.push("Column %1".arg(column))
        }
        for (var row = 0; row < rowsCount; ++row) {
            rows.push("Row %1".arg(row))
            var cellsRow = []
            for (var column = 0; column < columnsCount; ++column) {
                cellsRow.push("Cell %1 %2".arg(row).arg(column))
            }
            cells.push(cellsRow)
        }
        columnsModel = columns
        rowsModel = rows
        cellsModel = cells
    }

    property var columnsModel: []

    property var rowsModel: []

    property var cellsModel: []


    FrozenColumnTable {
        anchors.fill: parent

        columnHeader: Label {
            text: columnsModel[index]
            clip: true
        }

        rowHeader: Label {
            text: rowsModel[index]
            clip: true
        }

        cell: Label {
            text: cellsModel[row][column]
            clip: true
        }

        rowHeaderWidth: 46

        rowsCount: rowsModel.length
        columnsCount: columnsModel.length

    }
}
