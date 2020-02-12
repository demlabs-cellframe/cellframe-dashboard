import QtQuick 2.4
import QtQuick.Controls 1.4
import "qrc:/"
import "../../"

DapAbstractTab
{
    id: dashboardTab

    property alias dapDashboardRightPanel: stackViewRightPanel
    property alias dapDashboardTopPanel: dashboardTopPanel
    property alias dapDashboardScreen: dashboardScreen

    dapTopPanel: 
        DapDashboardTopPanel 
        { 
            id: dashboardTopPanel
        }

    dapScreen:
        DapDashboardScreen
        {
            id: dashboardScreen
        }

    dapRightPanel:
            StackView
            {
                id: stackViewRightPanel
                anchors.fill: parent
                width: 400
                delegate:
                    StackViewDelegate
                    {
                        pushTransition: StackViewTransition { }
                    }
            }

    state: "WALLETDEFAULT"
    states:
    [
        State
        {
            name: "WALLETDEFAULT"
            PropertyChanges
            {
                target: dashboardScreen.dapWalletCreateFrame;
                visible: true
            }
            PropertyChanges
            {
                target: dashboardScreen.dapTitleBlock;
                visible: false
            }
            PropertyChanges
            {
                target: dashboardScreen.dapListViewWallet;
                visible: false
            }
            PropertyChanges
            {
                target: dapRightPanel;
                visible: false
            }
        },
        State
        {
            name: "WALLETSHOW"
            PropertyChanges
            {
                target: dashboardScreen.dapWalletCreateFrame;
                visible: false
            }
            PropertyChanges
            {
                target: dashboardScreen.dapTitleBlock;
                visible: true
            }
            PropertyChanges
            {
                target: dashboardScreen.dapListViewWallet;
                visible: true
            }
            PropertyChanges
            {
                target: dapRightPanel;
                visible: true
            }
        },
        State
        {
            name: "WALLETCREATE"
            PropertyChanges
            {
                target: dashboardScreen.dapWalletCreateFrame;
                visible: true
            }
            PropertyChanges
            {
                target: dashboardScreen.dapTitleBlock;
                visible: false
            }
            PropertyChanges
            {
                target: dashboardScreen.dapListViewWallet;
                visible: false
            }
            PropertyChanges
            {
                target: dapRightPanel;
                visible: true
            }
        }
    ]
}
