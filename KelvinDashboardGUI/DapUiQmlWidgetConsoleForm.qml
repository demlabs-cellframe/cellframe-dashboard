import QtQuick 2.13
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.13


Rectangle {

    ColumnLayout {
        anchors.fill: parent

        Flickable {
            id: scrollCmdHistory
            contentY: txtCommand.height - height
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            TextArea.flickable:  TextArea {
                id: txtCommand
                text: dapConsoleModel.getCmdHistory();
                selectByMouse: true
                wrapMode: TextArea.WordWrap
                color: "#707070"
                font.family: "Roboto"
                font.pixelSize: 20 * pt

                Keys.onPressed: {
                    switch(event.key)
                    {
                    case Qt.Key_Left: break;
                    case Qt.Key_Right: break;
                    case Qt.Key_Up: break;
                    case Qt.Key_Down: break;
                    default: event.accepted =
                             !(event.modifiers & Qt.ControlModifier) || (event.key === Qt.Key_X); break;
                    }
                }
            }

            ScrollBar.vertical: ScrollBar { }
            ScrollBar.horizontal: ScrollBar { }
        }

        RowLayout {
            spacing: 0

            Text {
                id: promt
                verticalAlignment: Qt.AlignVCenter
                text: ">"
                color: "#707070"
                font.family: "Roboto"
                font.pixelSize: 20 * pt
            }

            TextArea {
                id: consoleCmd

                Layout.fillWidth: true
                height: contentChildren.height
                wrapMode: TextArea.Wrap
                color: "#707070"
                font.family: "Roboto"
                font.pixelSize: 20 * pt
                placeholderText: qsTr("Type here...")
                selectByMouse: true
                focus: true

                Keys.onUpPressed: {
                    consoleCmd.text = dapConsoleModel.getCommandUp();
                }

                Keys.onDownPressed: {
                    consoleCmd.text = dapConsoleModel.getCommandDown();
                }

                Keys.onReturnPressed: {
                    txtCommand.append("> " + consoleCmd.text);
                    if(consoleCmd.text === "") return;
                    dapConsoleModel.receiveRequest(consoleCmd.text);
                    consoleCmd.text = "";
                }
            }
        }

    }

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

