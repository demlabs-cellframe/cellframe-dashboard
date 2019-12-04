import QtQuick 2.0

DapUiQmlWalletCreatedForm {
    buttonDone.onClicked: {
        rightPanel.header.pop(null);
        rightPanel.content.pop(null);
    }
}
