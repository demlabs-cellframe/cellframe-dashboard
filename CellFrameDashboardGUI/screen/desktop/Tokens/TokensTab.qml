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

    id: dashboardTab

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

        function clear()
        {
            dapRightPanel.clear()
            dapRightPanel.push(tokensLastActions)
        }
    }

    dapHeader.initialItem: DapSearchTopPanel{
        DapButton
            {
                id: newTokenButton
                textButton: "New Token"
                anchors.right: parent.right
                anchors.rightMargin: 24 * pt
                anchors.top: parent.top
                anchors.topMargin: 14 * pt
                anchors.verticalCenter: parent.verticalCenter
                implicitHeight: 38 * pt
                implicitWidth: 163 * pt
                fontButton: mainFont.dapFont.medium14
                horizontalAligmentText: Text.AlignHCenter

                onClicked: navigator.createToken()
            }

//        onFindHandler: logicTokens.searchElement(text)
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
