import QtQuick 2.0
import QtQuick.Layouts 1.13

DapUiQmlWidgetLastActions {
    id: lastActionsPanel
    viewModel: dapConsoleModel
    viewDelegate: DapUiQmlWidgetConsoleLastActionsDelegateForm {}
}
