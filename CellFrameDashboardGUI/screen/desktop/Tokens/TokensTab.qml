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

    ListModel {id: networksModel}
    LogicTokens{id: logicTokens}

    QtObject {
        id: navigator

        function createToken() {
            dapRightPanel.push(createNewToken)
        }

        function tokenInfo()
        {
            dapRightPanel.push(infoAboutToken)
        }

        function emission()
        {
            dapRightPanel.push(tokenEmission)
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

    dapRightPanel.initialItem:
        TokensLastActions
        {
            id: lastActions
        }
}
