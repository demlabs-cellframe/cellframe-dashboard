import QtQuick 2.13
import QtQml 2.12
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.12
import QtQuick.Controls 1.4

DapUiQmlScreen {
    SplitView {
        anchors.fill: parent
        orientation: Qt.Horizontal
        anchors.leftMargin: 30 * pt
        handleDelegate: Item { }


        DapUiQmlWidgetConsoleForm {
            id: dapConsoleForm
            Layout.fillWidth: true
            Layout.topMargin: 30 * pt
            Layout.rightMargin: 30 * pt
        }

//        DapUiQmlWidgetConsoleLastActionsForm {
//            id: lastActionsPanel
//            consoleData: dapConsoleForm.textAreaCmdHistory
////            border.color: "transparent"
//        }
    }


}
