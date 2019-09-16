import QtQuick 2.0

DapUiQmlWidgetLastActions {
    id: lastActionsPanel
    viewModel: dapConsoleModel
    viewDelegate: DapUiQmlWidgetConsoleLastActionsDelegateForm {
        width: lastActionsPanel.width
        height: 50 * pt
        anchors.left: parent.left
        anchors.leftMargin: 18 * pt
    }
}
