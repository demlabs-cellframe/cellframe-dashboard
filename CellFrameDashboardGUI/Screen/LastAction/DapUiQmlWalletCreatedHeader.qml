import QtQuick 2.0

DapUiQmlScreenDialogAddWalletHeader {
    title: ""

    mouseArea.onClicked: {
        rightPanel.header.pop(null);
        rightPanel.content.pop(null);
    }
}
