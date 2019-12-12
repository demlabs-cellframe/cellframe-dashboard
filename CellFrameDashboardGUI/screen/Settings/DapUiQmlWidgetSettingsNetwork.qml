import QtQuick 2.0
import QtQuick.Controls 2.0

DapUiQmlWidgetSettingsNetworkForm {
    width: parent.width
    height: childrenRect.height + 40 * pt

    ComboBox {
        width: 150
        height: 50
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 18 * pt
        anchors.topMargin: 13 * pt
        model: dapSettingsNetworkModel
        textRole: "network"
        currentIndex: dapSettingsNetworkModel.getCurrentIndex()

        onCurrentTextChanged: {
            if(dapSettingsNetworkModel.getCurrentIndex() !== currentIndex) {
                dapSettingsNetworkModel.setCurrentNetwork(currentText, currentIndex);
            }
        }
    }
}
