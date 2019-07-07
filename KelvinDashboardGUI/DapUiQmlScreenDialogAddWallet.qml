import QtQuick 2.9
import QtQuick.Controls 2.2
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
                id: buttonCancel
                text: qsTr("Cancel")
                anchors.right: buttonOk.left
                anchors.rightMargin: 10
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10

                contentItem: Text {
                        text: buttonCancel.text
                        font: buttonCancel.font
                        opacity: enabled ? 1.0 : 0.3
                        color: buttonCancel.down ? "#353841" : "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }

                    background: Rectangle {
                        implicitWidth: 100
                        implicitHeight: 30
                        opacity: enabled ? 1 : 0.3
                        color: buttonCancel.down ? "white" : "#353841"
                        radius: 4
                    }

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
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10
                contentItem: Text {
                        text: buttonOk.text
                        font: buttonOk.font
                        opacity: enabled ? 1.0 : 0.3
                        color: buttonOk.down ? "#353841" : "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }

                    background: Rectangle {
                        implicitWidth: 100
                        implicitHeight: 30
                        opacity: enabled ? 1 : 0.3
                        color: buttonOk.down ? "white" : "#353841"
                        radius: 4
                    }

                onClicked:
                {
                    dapServiceController.addWallet(textFieldNameWallet.text)
                    textFieldNameWallet.clear()
                    close()
                }
            }
        }

}
