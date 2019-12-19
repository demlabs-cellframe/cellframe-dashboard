import QtQuick 2.4

DapUiQmlScreenVpnForm {
    imageServer.source: modelTest.get(modelTest.index(comboboxServer.currentIndex, 0)).icon
}
