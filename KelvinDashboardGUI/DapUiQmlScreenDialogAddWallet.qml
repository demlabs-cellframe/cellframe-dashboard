import QtQuick 2.9
import QtQuick.Controls 2.4
import KelvinDashboard 1.0

Dialog {
    id: dialogAddWallet
    focus: true
    modal: true
    title: qsTr("Add wallet...")

    width: parent.width/1.5
    height: 150

    x: parent.width / 2 - width / 2
    y: parent.height / 2 - height / 2

    function show() {
            dialogAddWallet.open();
        }
    contentItem:

        Rectangle
        {
            anchors.fill: parent

            TextField
                {
                            background: Rectangle {
                                radius: 2
                                border.color: "gray"
                                border.width: 1
                            }

                    id: textFieldNameWallet
                    selectByMouse: true
                    height: 35
                    anchors.bottom: buttonOk.top
                    anchors.bottomMargin: 20
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    font.pixelSize: 20
                    clip: true


                }

            Button
            {
                id: buttonCancle
                text: "Cancel"
                width: 100
                height: 30
                anchors.right: buttonOk.left
                anchors.rightMargin: 10
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10
                onClicked:
                {
                    textFieldNameWallet.clear()
                    close()
                }
            }

            Button
            {
                id: buttonOk
                text: "OK"
                width: 100
                height: 30
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10
                onClicked:
                {
                    dapServiceController.addWallet(textFieldNameWallet.text)
                    textFieldNameWallet.clear()
                    close()
                }
            }
        }

}
