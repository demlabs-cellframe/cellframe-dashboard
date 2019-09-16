import QtQuick 2.13
import QtQml 2.12
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.12

Page {
    Flickable {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: lastActionsPanel.left
        anchors.bottom: parent.bottom

        leftMargin: 30 * pt
        topMargin: 30 * pt
        rightMargin: 30 * pt

        TextArea.flickable: DapUiQmlWidgetConsoleForm {}

        ScrollBar.vertical: ScrollBar{}
    }

    DapUiQmlWidgetConsoleLastActionsForm {
        id: lastActionsPanel
    }
}
