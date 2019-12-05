import QtQuick 2.9
import QtQuick.Layouts 1.0
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
    }
}
