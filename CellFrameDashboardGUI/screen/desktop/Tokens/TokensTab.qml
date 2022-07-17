import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 1.4
import "qrc:/"
import "../../"
import "../controls"
import "RightPanel"
import "logic"

DapPage
{
    readonly property string tokensLastActions: path + "/Tokens/RightPanel/TokensLastActions.qml"
    readonly property string createNewToken: path + "/Tokens/RightPanel/CreateNewToken.qml"
    readonly property string infoAboutToken: path + "/Tokens/RightPanel/InfoAboutToken.qml"
    readonly property string tokenEmission: path + "/Tokens/RightPanel/TokenEmission.qml"

    id: dashboardTab

    LogicTokens{id: logicTokens}

    Component{id: emptyRightPanel; Item{}}

    QtObject {
        id: navigator

        function createToken() {
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

        function clear()
        {
            dapRightPanel.clear()
            dapRightPanelFrame.visible = false
            dapRightPanel.push(emptyRightPanel)
        }
    }

    dapHeader.initialItem: TokensTopPanel
        {
            id: tokensTopPanel
        }

    dapScreen.initialItem:
        TokensScreen
        {
            id: tokensScreen
        }


    dapRightPanelFrame.visible: false
    dapRightPanel.initialItem: emptyRightPanel

//        TokensLastActions
//        {
//            id: lastActions
//        }
}
