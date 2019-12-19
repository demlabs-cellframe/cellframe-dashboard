import QtQuick 2.0

DapUiQmlWidgetLastActions {
    viewModel: dapHistoryModel
    viewDelegate: DapUiQmlWidgetLastActionsDelegateForm {}
    viewSection.property: "date"
    viewSection.criteria: ViewSection.FullString
    viewSection.delegate: DapUiQmlWidgetLastActionsSectionForm {
        width:  parent.width
        height: 30 * pt
    }
}
