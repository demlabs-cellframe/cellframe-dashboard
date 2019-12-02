import QtQuick 2.0
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.13
import "../LastAction"

DapUiQmlWidgetLastActions {
    property TextArea consoleData

    id: lastActionsPanel
    viewModel: dapConsoleModel
    viewDelegate: DapUiQmlWidgetConsoleLastActionsDelegateForm { }
}
