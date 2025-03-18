import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 1.4
import "qrc:/"
import "../../"
import "../controls"
import "qrc:/widgets"
import "Logic"

DapPage {

    readonly property string createNewOrder:  path + "/Orders/RightPanel/DapOrderCreate.qml"
    readonly property string orderCreateDone: path + "/Orders/RightPanel/DapOrderCreateDone.qml"
    readonly property string infoAboutOrder:  path + "/Orders/RightPanel/DapOrderInfo.qml"


    ListModel{id: detailsModel}
    ListModel{id: certificatesModel}
    LogicOrders{id: logicOrders}
    Component{id: emptyRightPanel; Item{}}

    QtObject {
        id: navigator

        function createOrder() {
            dashboardScreen.ordersView.currentIndex = -1
            dapRightPanelFrame.visible = true
            dapRightPanel.pop()
            dapRightPanel.push(createNewOrder)
        }

        function orderInfo()
        {
            dapRightPanelFrame.visible = true
            dapRightPanel.pop()
            dapRightPanel.push(infoAboutOrder)
        }

        function done()
        {
            dapRightPanel.push(orderCreateDone)
        }

        function clear()
        {
            dapRightPanel.clear()
            dapRightPanelFrame.visible = false
            dapRightPanel.push(emptyRightPanel)
            dashboardScreen.ordersView.currentIndex = -1
        }
    }

    dapHeader.initialItem: DapSearchTopPanel{
        DapButton
            {
                id: newTokenButton
                textButton: qsTr("New Order")
                anchors.right: parent.right
                anchors.rightMargin: 24
                anchors.verticalCenter: parent.verticalCenter
                implicitHeight: 36
                implicitWidth: 164
                fontButton: mainFont.dapFont.medium14
                horizontalAligmentText: Text.AlignHCenter

                onClicked: navigator.createOrder()
            }
        isVisibleSearch: false
    }

    dapScreen.initialItem:
        DapOrdersScreen
        {
            id: dashboardScreen
        }

    dapRightPanelFrame.visible: false
    dapRightPanel.initialItem: emptyRightPanel

    Component.onCompleted:
    {
        certificatesModule.requestCommand({"certCommandNumber": DapCertificateCommands.GetSertificateList})
        logicMainApp.requestToService("DapGetListTokensCommand","")
        ordersModule.statusProcessing = true
    }

    Component.onDestruction:
    {
        ordersModule.statusProcessing = false
    }

    Connections{
        target: dapServiceController
        function onCertificateManagerOperationResult(rcvData){
            var jsonDocument = JSON.parse(rcvData)
            var result = jsonDocument.result
            var certList = result.data

            for (var i = 0; i < certList.length; ++i) {
                if(certList[i].accessKeyType === 1)
                {
                    certList[i].selected = false
                    certificatesModel.append(certList[i])
                }
            }
        }
    }
}
