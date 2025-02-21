import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 1.4
import "qrc:/"
import "../../"
import "../controls"
import "qrc:/widgets"
import "RightPanel"
import "logic"

DapPage
{
    readonly property string tokensLastActions: path + "/Tokens/RightPanel/TokensLastActions.qml"
    readonly property string createNewToken: path + "/Tokens/RightPanel/CreateNewToken.qml"
    readonly property string infoAboutToken: path + "/Tokens/RightPanel/InfoAboutToken.qml"
    readonly property string tokenEmission: path + "/Tokens/RightPanel/TokenEmission.qml"
    readonly property string tokenDone: path + "/Tokens/RightPanel/TokenOperationsDone.qml"

    id: dashboardTab

    LogicTokens{id: logicTokens}
    ListModel{id: detailsModel}
    ListModel{id: certificatesModel}
//    ListModel{id: tokensModel}
//    ListModel{id: temporaryModel}

    Component{id: emptyRightPanel; Item{}}

    QtObject {
        id: navigator

        function createToken() {
            logicTokens.unselectToken()
            dapRightPanelFrame.visible = true
            dapRightPanel.pop()
            dapRightPanel.push(createNewToken)
        }

        function tokenInfo()
        {
            dapRightPanelFrame.visible = true
            dapRightPanel.pop()
            dapRightPanel.push(infoAboutToken)
        }

        function emission()
        {
            dapRightPanelFrame.visible = true
            dapRightPanel.push(tokenEmission)
        }

        function done()
        {
            dapRightPanel.push(tokenDone)
        }

        function clear()
        {
            dapRightPanel.clear()
            dapRightPanelFrame.visible = false
            dapRightPanel.push(emptyRightPanel)
        }
    }

    dapHeader.initialItem: DapSearchTopPanel{
//        DapButton
//            {
//                id: newTokenButton
//                textButton: qsTr("New Token")
//                anchors.right: parent.right
//                anchors.rightMargin: 24
//                anchors.verticalCenter: parent.verticalCenter
//                implicitHeight: 36
//                implicitWidth: 164
//                fontButton: mainFont.dapFont.medium14
//                horizontalAligmentText: Text.AlignHCenter

//                onClicked: navigator.createToken()

//                DapCustomToolTip{
//                    contentText: qsTr("New Token")
//                }
//            }
        isVisibleSearch: false

//        onFindHandler: logicTokens.filterResults(text)
    }

    dapScreen.initialItem:
        TokensScreen
        {
            id: tokensScreen
        }


    dapRightPanelFrame.visible: false
    dapRightPanel.initialItem: emptyRightPanel

    Timer {
        id: updateTokensTimer
        interval: logicMainApp.autoUpdateInterval; running: false; repeat: true
        onTriggered:
        {
            console.log("TOKENS TIMER TICK")
            logicMainApp.requestToService("DapGetListTokensCommand", "update")
        }
    }
    Component.onCompleted:
    {
        certificatesModule.requestCommand({"certCommandNumber": DapCertificateCommands.GetSertificateList})
        logicMainApp.requestToService("DapGetListTokensCommand","")
        if (!updateTokensTimer.running)
            updateTokensTimer.start()
    }

    Component.onDestruction:
    {
        updateTokensTimer.stop()
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

//    Connections{
//        target: dapMainWindow

//        onModelTokensUpdated:{
//            logicTokens.modelUpdate()
//        }
//    }

}
