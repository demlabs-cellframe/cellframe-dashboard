import QtQuick 2.0
import QtQuick.Controls 1.4
import "qrc:/"
import "../../"

DapAbstractTab {

    id:vpnCLientTab
    color: currTheme.backgroundMainScreen

    property alias dapVpnClientRightPanel: stackViewRightPanel

    dapTopPanel:
        DapVpnClientTopPanel
        {

        }

    dapScreen:
        DapVpnClientScreen
        {

        }

    dapRightPanel:
        StackView
        {
            id: stackViewRightPanel
//            initialItem: Qt.resolvedUrl(lastActionsWallet);
            width: 350
            anchors.fill: parent
            delegate:
                StackViewDelegate
                {
                    pushTransition: StackViewTransition { }
                }
        }
}
