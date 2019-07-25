import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2
import NodeNetworkExplorer 1.0

Page {
    Flickable {
        id: dapExplorer
        anchors.fill: parent
        contentWidth: dapGraphWidget.width * dapGraphWidget.scale
        contentHeight: dapGraphWidget.height * dapGraphWidget.scale
        contentY: dapGraphWidget.height / 2 - height / 2
        contentX: dapGraphWidget.width / 2 - width / 2

        DapUiQmlWidgetNodeNetwork {
            id: dapGraphWidget
            scale: 0.6
            data: dapNodeNetworkModel.data
            transformOrigin: Item.TopLeft
        }
    }
}
