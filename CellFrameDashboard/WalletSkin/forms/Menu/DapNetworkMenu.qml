import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "qrc:/resources/QML"
import "qrc:/widgets"
import "../../../screen/desktop/Networks/logic/" as DashboardLogic

Drawer {
    id: drawer
    edge: Qt.RightEdge
    dragMargin: 0

    Overlay.modal: Rectangle {
                      color: "#A017171A"
                  }

    DashboardLogic.LogicNetworks{
        id: logicNet
    }

//    ListModel{id: networkBuffer}

    background: Rectangle {
        color: currTheme.secondaryBackground
        radius: 16
        Rectangle {
            width: 16
            height: 16
            anchors.top: parent.top
            anchors.right: parent.right
            color: currTheme.secondaryBackground
        }
        Rectangle {
            width: 16
            height: 16
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            color: currTheme.secondaryBackground
        }
        Rectangle {
            width: 16
            height: 16
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            color: currTheme.secondaryBackground
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 50

            RowLayout
            {
                anchors.fill: parent
                anchors.rightMargin: 16
                Item {
                    Layout.fillWidth: true
                }

                Text {
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
                    Layout.rightMargin: 108
                    text: qsTr("Networks")
                    color: currTheme.white
                    font: mainFont.dapFont.medium18
                }
                DapImageRender {
                    source: "qrc:/walletSkin/Resources/BlackTheme/icons/new/icon_networkHover.svg"
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked:
                    drawer.close()
            }
        }

        Rectangle {
            implicitHeight: 1
            Layout.fillWidth: true
            color: currTheme.grayDark
        }

        ListView {
            id: mainButtonsList
            Layout.fillHeight: true
            Layout.fillWidth: true
            clip: true
            spacing: 20
            //model: networkListModel
            model: networksModel
            delegate: DapNetworkDelegate{}
        }
    }
    Component.onCompleted:  {
        console.log("KTT", "onCompleted networksModel", networksModel.count)
        console.log("Network menu complate")
        dapServiceController.requestToService("DapGetListNetworksCommand")
     }

    Connections
    {
        target: dapServiceController
        function onSignalNetState(netState)
        {
            console.log("KTT", "onSignalNetState onSignalNetState BEGIN")
            logicNet.notifyModelUpdate(netState)
            console.log("KTT", "onSignalNetState onSignalNetState END")
        }

        function onNetworkStatesListReceived(networksStateList)
        {

            console.log("KTT", "onNetworkStatesListReceived networksStateList BEGIN")
            var jsonDocument = JSON.parse(networksStateList)
            console.log("KTT", "onNetworkStatesListReceived jsonDocument:", JSON.stringify(jsonDocument))

            if(!jsonDocument)
            {
                networksModel.clear()
                return
            }
            logicNet.modelUpdate(jsonDocument.result)
            logicNet.updateContentInAllOpenedPopups(networksModel)
            console.log("KTT", "onNetworkStatesListReceived END")
        }
    }
}
