import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Page {
    background: Rectangle {
        color: currTheme.backgroundElements
        radius: 16 * pt
    }

    ColumnLayout {
        anchors.fill: parent

        Text {
            id: pageTitle
            Layout.alignment: Qt.AlignLeft
            Layout.leftMargin: 20
            color: currTheme.textColor
            font.bold: true
            text: qsTr("Tokens")
        }


    }
}
