import QtQuick 2.4
import QtQuick.Controls 1.4
import "qrc:/"
import "../../"

DapAbstractTab
{
//    property string consoleRightPanel: "qrc:/screen/" + device + "/Console/DapConsoleRightPanel.qml"

    id: consoleTab

    property alias dapConsoleScreen: consoleScreen
    property alias dapConsoleRigthPanel: consoleRigthPanel
    ///@detalis rAnswer Answer for the sended command
    property string rAnswer
    property var _dapServiceController

    dapTopPanel: DapConsoleTopPanel { }

    dapScreen:
        DapConsoleScreen
        {
            id: consoleScreen
            //Set receivedAnswer of dapScreen to the external variable rAnswer for the displaying it in console
            receivedAnswer: rAnswer
            //Assign historyCommand of dapScreen with dapRightPanel.historyQuery for ability to use right history panel to send command to the console
            historyCommand: consoleRigthPanel.historyQuery
            dapServiceController: _dapServiceController
        }

//    dapRightPanel:
//        DapConsoleRightPanel
//        {
//            id: consoleRigthPanel
//            anchors.fill: parent
//            //Assign commandQuery of dapRightPanel with dapScreen.sendCommand for set it to right history panelfrome console
//            commandQuery: dapScreen.sendCommand
//        }


    dapRightPanel:
        StackView
        {
            id: stackViewRightPanel
            width: 350 * pt
            anchors.fill: parent
            initialItem:
                DapConsoleRightPanel
                {
                    id: consoleRigthPanel
//                    anchors.fill: parent
                    //Assign commandQuery of dapRightPanel with dapScreen.sendCommand for set it to right history panelfrome console
                    commandQuery: dapScreen.sendCommand
                }

            delegate:
                StackViewDelegate
                {
                    pushTransition: StackViewTransition { }
                }
        }





}
