import QtQuick 2.13
import QtQml 2.12
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.12

Page {

    Flickable {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: lastActionsPanel.left
        anchors.bottom: parent.bottom

        leftMargin: 30 * pt
        topMargin: 30 * pt
        rightMargin: 30 * pt

        TextArea.flickable: DapUiQmlWidgetConsoleForm {
        }

        ScrollBar.vertical: ScrollBar{}
    }

//    DapUiQmlWidgetConsoleLastActionsForm {

//    }



    Rectangle {
        id: lastActionsPanel
        width: 400 * pt
        border.color: "#B5B5B5"
        border.width: 1 * pt
        color: "#EDEFF2"

        anchors {
            top: parent.top
            right: parent.right
            bottom: parent.bottom
        }

        ListView {
            anchors.fill: parent

            model: dapConsoleModel
            delegate:
                Component {
                Rectangle {
                    width: lastActionsPanel.width
                    height: 60 * pt
                    Text {
                        text: lastCommand
                        color: "#000000"
                        font.pixelSize: 20 * pt
                    }
                }
            }

        }
    }

}
