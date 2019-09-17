import QtQuick 2.13
import QtQuick.Controls 2.5

Rectangle {
    Text {
        id: promt
        anchors.left: parent.left
        anchors.top: consoleCmd.top
        anchors.bottom: parent.bottom
        verticalAlignment: Qt.AlignVCenter
        text: ">"
        color: "#707070"
        font.family: "Roboto"
        font.pixelSize: 20 * pt
    }

    TextArea {
        id: consoleCmd
        anchors.left: promt.right
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        height: contentChildren.height
        wrapMode: TextArea.Wrap
        color: "#707070"
        font.family: "Roboto"
        font.pixelSize: 20 * pt
        focus: true

        Keys.onUpPressed: {
            consoleCmd.text = dapConsoleModel.getCommandUp();
        }

        Keys.onDownPressed: {
            consoleCmd.text = dapConsoleModel.getCommandDown();
        }

        Keys.onReturnPressed: {
            dapConsoleModel.receiveRequest(consoleCmd.text);
            txtCommand.append("> " + consoleCmd.text);
            consoleCmd.text = "";
        }
    }

    ScrollView {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.bottom: consoleCmd.top

        /*TextArea.flickable: */TextArea {
            id: txtCommand
            text: dapConsoleModel.getCmdHistory();
            wrapMode: TextArea.Wrap
            color: "#707070"
            font.family: "Roboto"
            font.pixelSize: 20 * pt
            focus: false

//            Keys.onPressed: {
//                switch(event.key)
//                {
//                case Qt.Key_Left: break;
//                case Qt.Key_Right: break;
//                case Qt.Key_Shift: break;
//                case Qt.Key_Control: break;
//                case Qt.Key_Up: break;
//                case Qt.Key_Down: break;
//                default: event.accepted = true; break;
//                }
//            }

        }

//        ScrollBar.vertical: ScrollBar{}

        Connections {
            target: dapConsoleModel
            onSendResponse: {
                txtCommand.append(response);
            }

            onCmdHistoryChanged: {
                txtCommand.append(history);
            }
        }
    }
}

