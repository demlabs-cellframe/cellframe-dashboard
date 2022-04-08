import QtQuick 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import "qrc:/"
import "../../"
import "../"
import "qrc:/widgets"

DapTab {

    readonly property string dapTestRightPanel : path + "/Test/DapTestRightPanelForm.ui.qml"

    id :testPageTab
    color: currTheme.backgroundMainScreen

    dapTopPanel:
        DapTopPanel
        {   anchors.leftMargin: 4*pt
            radius: currTheme.radiusRectangle
            color: currTheme.backgroundPanel
        }

    dapScreen:
        TestScreen
        {}
    dapRightPanel: StackView
    {
        id: stackViewRightPanel
        initialItem: Qt.resolvedUrl(dapTestRightPanel);
        width: 350 * pt
        anchors.fill: parent
        delegate:
            StackViewDelegate
            {
                pushTransition: StackViewTransition { }
            }
    }
}
