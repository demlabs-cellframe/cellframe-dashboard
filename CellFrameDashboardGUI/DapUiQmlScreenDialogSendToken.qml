import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.3
import QtQuick.Controls.Private 1.0
import CellFrameDashboard 1.0

Dialog {
    id: dialogSendToken
    focus: true
    modal: true

    header:
        Rectangle
        {
            height: 30
            color: "#353841"

            Text
            {
                id: textTitle
                leftPadding: 10
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("Send token...")
                font.family: "Roboto"
                font.pixelSize: 16
                color: "white"
            }
            Rectangle
            {
                anchors.bottom: parent.bottom
                height: 2
                width: parent.width
                color: "green"
            }
        }

    width: parent.width/1.5
    height: 280

    x: parent.width / 2 - width / 2
    y: parent.height / 2 - height / 2

    function show() {
        textFieldAmount.clear()
        comboBoxToken.currentIndex = -1
        comboBoxAddressWallet.editText = ""
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

        Row
        {
            anchors { bottom: rowAddress.top; bottomMargin: 20; right: parent.right; rightMargin: 10;
                left: parent.left; leftMargin: 10 }
            Rectangle
            {
                id: rectangleToken
                color: "green"
                width: 100
                height: comboBoxToken.height
                Text
                {
                    font.family: "Roboto"
                    font.weight: Font.Thin
                    anchors.centerIn: parent
                    text: qsTr("Token")
                    color: "white"
                }
            }

            ComboBox {
                id: comboBoxToken
                width: parent.width - rectangleToken.width
                model: listViewTokens.model
                displayText: currentIndex === -1 ? "Please choose..." : currentText
                textRole: "token"
                delegate: ItemDelegate {
                    width: comboBoxToken.width
                    contentItem: Text {
                        text: token
                        font: comboBoxToken.font
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                    }
                    highlighted: comboBoxToken.highlightedIndex !== index
                }
                onAccepted: {
                       currentText = listViewTokens.model.get(currentIndex).token
                    }
            }
        }

        Row
        {
            id: rowAddress
            anchors { bottom: rowAmount.top; bottomMargin: 20; right: parent.right; rightMargin: 10;
                left: parent.left; leftMargin: 10 }
            Rectangle
            {
                id: rectangleAddress
                color: "green"
                width: 100
                height: comboBoxAddressWallet.height
                Text
                {
                    font.family: "Roboto"
                    font.weight: Font.Thin
                    anchors.centerIn: parent
                    text: qsTr("Receiver")
                    color: "white"
                }
            }

            ComboBox {
                id: comboBoxAddressWallet
                width: parent.width - rectangleAddress.width
                editable: true
                textRole: "text"
                editText: currentIndex === -1 ? "Please enter..." : currentText
                onAccepted: {
                    if (find(currentText) === -1) {
                        model.append({text: editText})
                        //                        currentIndex = find(editText)
                        //                        fnameField.insert(currentIndex)

                    }
                }
            }
        }

        Row
        {
            id: rowAmount
            anchors { bottom: buttonCancel.top; bottomMargin: 20; right: parent.right; rightMargin: 10;
                left: parent.left; leftMargin: 10 }
            Rectangle
            {
                id: rectangleAmount
                color: "green"
                width: 100
                height: comboBoxToken.height
                Text
                {
                    font.family: "Roboto"
                    font.weight: Font.Thin
                    anchors.centerIn: parent
                    text: qsTr("Amount")
                    color: "white"
                }
            }

            TextField {
                property real realValue: parseFloat(textFieldAmount.text.replace(',', '.')) * 1e12;
                height: rectangleAmount.height
                width: parent.width - rectangleAmount.width
                id: textFieldAmount
                placeholderText: "Amount (Ex. 2,9103)"
                validator: DoubleValidator{}
                background: Rectangle {
                    radius: 1
                    border.color: "green"
                    border.width: 1
                }
            }
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
