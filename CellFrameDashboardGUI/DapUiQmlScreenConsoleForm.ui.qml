import QtQuick 2.13
import QtQml 2.12
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.12

Page {

    DapUiQmlWidgetConsoleForm {
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: lastActionsPanel.left

        anchors.topMargin: 30 * pt
        anchors.leftMargin: 30 * pt
        anchors.rightMargin: 30 * pt
    }

    DapUiQmlWidgetConsoleLastActionsForm {
        id: lastActionsPanel
    }
}
