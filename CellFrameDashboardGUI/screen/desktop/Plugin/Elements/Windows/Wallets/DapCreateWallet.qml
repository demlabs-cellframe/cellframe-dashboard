import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4

import "../../"

Item {
    anchors.fill: parent

    Rectangle
    {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        color: "#2E3138"
        width: 300
        height: 400

        ListModel
        {
            id: signatureTypeWallet
            ListElement
            {
                name: "Dilithium"
                sign: "sig_dil"
            }
            ListElement
            {
                name: "Bliss"
                sign: "sig_bliss"
            }
            ListElement
            {
                name: "Picnic"
                sign: " sig_picnic"
            }
            ListElement
            {
                name: "Tesla"
                sign: " sig_tesla"
            }
        }

        ColumnLayout
        {
            anchors.fill: parent

            Rectangle
            {
                id: frameInputNameWallet
                height: 60 * pt
                color: "transparent"
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                TextField
                {
                    id: textInputNameWallet
                    placeholderText: qsTr("Input name of wallet")
                    font.family: "Qicksand"
                    font.pixelSize: 16
                    horizontalAlignment: Text.AlignLeft
                    anchors.fill: parent
                    anchors.margins: 10 * pt
                    anchors.leftMargin: 25 * pt

                    validator: RegExpValidator { regExp: /[0-9A-Za-z\.\-]+/ }
                    style:
                        TextFieldStyle
                        {
                            textColor: "#ffffff"
                            placeholderTextColor: "#B4B1BD"
                            background:
                                Rectangle
                                {
                                    border.width: 0
                                    color: "#363A42"
                                }
                        }
                }
            }

            DapPluginButton
            {
                id:rightBut

                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignCenter

                Layout.maximumHeight: 100
                Layout.maximumWidth: 200
                radius: 16

                textButton: "Create"

                fontButton.family: "Qicksand"
                fontButton.pixelSize: 20
                horizontalAligmentText: Qt.AlignHCenter

                onClicked:
                {
                    dapServiceController.requestToService("DapAddWalletCommand",
                           textInputNameWallet.text,
                           signatureTypeWallet.get(0).sign)

                    close()
                }
            }
        }
    }
}
