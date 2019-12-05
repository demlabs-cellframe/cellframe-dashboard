import QtQuick 2.0
import QtQuick.Controls 2.0
import "../LastAction"

DapUiQmlWidgetLastActions {
    property TextArea consoleData

    id: lastActionsPanel
    viewModel: dapConsoleModel
    viewDelegate: DapUiQmlWidgetConsoleLastActionsDelegateForm { }
}
