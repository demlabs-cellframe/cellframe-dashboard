import QtQuick 2.4

DapDashboardTopPanelForm {
    testButton.onClicked: dapServiceController.requestToService("ADD", 5)
}
