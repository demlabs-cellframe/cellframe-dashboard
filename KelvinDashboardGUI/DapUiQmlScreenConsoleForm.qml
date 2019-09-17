import QtQuick 2.13
import QtQml 2.12
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.12

Page {

    DapUiQmlWidgetConsoleForm {
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: lastActionsPanel.right

        anchors.topMargin: 30 * pt
        anchors.leftMargin: 30 * pt
        anchors.rightMargin: 30 * pt
    }

//    Text {
//        id: promt
//        anchors.left: parent.left
//        anchors.top: consoleCmd.top
//        anchors.bottom: parent.bottom
//        verticalAlignment: Qt.AlignVCenter
//        text: ">"
//        color: "#707070"
//        font.family: "Roboto"
//        font.pixelSize: 20 * pt
//        anchors.leftMargin: 30 * pt
//    }

//    TextArea {
//        id: consoleCmd
//        anchors.left: promt.right
//        anchors.bottom: parent.bottom
//        anchors.right: lastActionsPanel.left
//        height: contentChildren.height
//        wrapMode: TextArea.Wrap
//        color: "#707070"
//        font.family: "Roboto"
//        font.pixelSize: 20 * pt
//        anchors.rightMargin: 30 * pt
//        focus: true

//        Keys.onUpPressed: {
//            consoleCmd.text = dapConsoleModel.getCommandUp();
//        }

//        Keys.onDownPressed: {
//            consoleCmd.text = dapConsoleModel.getCommandDown();
//        }

//        Keys.onReturnPressed: {
//            dapConsoleModel.receiveRequest(consoleCmd.text);
//            txtCommand.append("> " + consoleCmd.text);
//        }
//    }

//    Flickable {
//        anchors.left: parent.left
//        anchors.top: parent.top
//        anchors.right: lastActionsPanel.left
//        anchors.bottom: consoleCmd.top

//        leftMargin: 30 * pt
//        topMargin: 30 * pt
//        rightMargin: 30 * pt

//        TextArea.flickable: DapUiQmlWidgetConsoleForm
//        {
//            id: txtCommand
//        }

//        ScrollBar.vertical: ScrollBar{}
//    }

    DapUiQmlWidgetConsoleLastActionsForm {
        id: lastActionsPanel
    }
}
