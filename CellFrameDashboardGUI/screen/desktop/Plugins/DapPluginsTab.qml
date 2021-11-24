import QtQuick 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import "qrc:/"
import "../../"
import "../"
import "qrc:/widgets"

DapAbstractTab {

    readonly property string dapPluginsRightPanel : "qrc:/screen/" + device + "/Test/DapTestRightPanelForm.ui.qml"

    id :testPageTab
    color: currTheme.backgroundMainScreen

    dapTopPanel:
        DapPluginsTopPanel
        {
            color: currTheme.backgroundPanel
        }

    dapScreen:
        DapPluginsScreen
        {}
    dapRightPanel: StackView
    {
        id: stackViewRightPanel
        initialItem: Qt.resolvedUrl(dapPluginsRightPanel);
        width: 350 * pt
        anchors.fill: parent
        visible: true
        delegate:
            StackViewDelegate
            {
                pushTransition: StackViewTransition { }
            }
    }
}
