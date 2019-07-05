import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
//import QtQuick.Controls 2.5
import KelvinDashboard 1.0

Dialog {
    id: dialogSendToken
    focus: true
    modal: true
    title: qsTr("Send token...")

    width: parent.width/1.5
    height: 280

    x: parent.width / 2 - width / 2
    y: parent.height / 2 - height / 2

    function show() {
        dialogSendToken.open();
    }

    contentItem:

        Rectangle
    {
        anchors.fill: parent

        //            TextField
        //                {
        //                            background: Rectangle {
        //                                radius: 2
        //                                border.color: "gray"
        //                                border.width: 1
        //                            }

        //                    id: textFieldNameWallet
        //                    selectByMouse: true
        //                    height: 35
        //                    anchors.bottom: buttonOk.top
        //                    anchors.bottomMargin: 20
        //                    anchors.right: parent.right
        //                    anchors.rightMargin: 10
        //                    anchors.left: parent.left
        //                    anchors.leftMargin: 10
        //                    font.pixelSize: 20
        //                    clip: true


        //                }

        ComboBox {
            id: comboBoxToken
            anchors { bottom: comboBoxAddressWallet.top; bottomMargin: 20; right: parent.right; rightMargin: 10;
                left: parent.left; leftMargin: 10 }
            model: listViewTokens.model
            delegate: ItemDelegate {
                width: comboBoxToken.width
                contentItem: Text {
                    text: modelData
                    font: comboBoxToken.font
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                }
                highlighted: comboBoxToken.highlightedIndex !== index
            }
        }

        ComboBox {
            id: comboBoxAddressWallet
            anchors.bottom: textFieldAmount.top
            anchors.bottomMargin: 20
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 10
            editable: true
            textRole: "text"
            onAccepted: {
                if (find(currentText) === -1) {
                    model.append({text: editText})
                    //                        currentIndex = find(editText)
                    //                        fnameField.insert(currentIndex)

                }
            }
        }

        TextField {
            property real realValue: parseFloat(textFieldAmount.text.replace(',', '.')) * 1e12;

            id: textFieldAmount
            anchors.bottom: buttonOk.top
            anchors.bottomMargin: 20
            anchors.right: parent.right
            anchors.rightMargin: 10
            placeholderText: "Amount (Ex. 2,9103)"
            validator: DoubleValidator{}
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
                var wallet = listViewWallet.model.get(listViewWallet.currentIndex).name;
                var token = comboBoxToken.currentText;
                var amount = textFieldAmount.realValue.toString();
                var receiver = comboBoxAddressWallet.editText;

                if (wallet && token && amount && receiver) {
                    console.log("Send " + token + "(" + amount + ") to address " + receiver + " from wallet " + wallet );
                    dapServiceController.sendToken(wallet, receiver, token, amount);
                    dapChainWalletsModel.clear();
                    dapServiceController.getWallets();
                } else {
                    console.log("There's error!");
                    console.log(amount);
                }

                close()
            }
        }
    }

}
