import QtQuick 2.9
import QtQuick.Controls 2.2

///this file used in DapUiQmlWidgetModel.cpp
Page {
    id: dapUiQmlWidgetChainExchanges
    
    title: qsTr("Exchanges")
    
    Text {
        id: name
        anchors.centerIn: parent
        text: qsTr("Exchanges")
    }
}
