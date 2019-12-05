import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.0

Rectangle {
    property alias textAreaCmdHistory: txtCommand
    property alias textAreaCmd: consoleCmd

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
                color: consoleCmd.color
                font.family: consoleCmd.font.family
                font.pixelSize: consoleCmd.font.pixelSize
            }

            TextArea {
                id: consoleCmd

                Layout.fillWidth: true
                height: contentChildren.height
                wrapMode: TextArea.Wrap
                placeholderText: qsTr("Type here...")
                selectByMouse: true
                focus: true

                Keys.onUpPressed: {
                    consoleCmd.text = dapConsoleModel.getCommandUp();
                }

                Keys.onDownPressed: {
                    consoleCmd.text = dapConsoleModel.getCommandDown();
                }

                Keys.onEnterPressed: {
                    Keys.onReturnPressed(event);
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

    Component.onCompleted: {
        rightPanel.content.currentItem.consoleData = dapConsoleForm.textAreaCmdHistory;
    }
}

