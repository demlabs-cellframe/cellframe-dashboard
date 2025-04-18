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

        ColumnLayout
        {
            anchors.fill: parent

            Rectangle
            {
                id: frameInputNameWallet
                height: 60 
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
                    anchors.margins: 10 
                    anchors.leftMargin: 25 

                    validator: RegExpValidator { regExp: /[0-9A-Za-z\.\-]+/ }
                    style:
                        TextFieldStyle
                        {
                            textColor: "#ffffff"
                            placeholderTextColor: "#B4B1BD"
                            selectionColor: "#AABCDE"
                            selectedTextColor: "#2E3138"
                            background:
                                Rectangle
                                {
                                    border.width: 0
                                    color: "#363A42"
                                }
                        }
                }
            }

            DapAppButton
            {
                id:rightBut

                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignCenter

                Layout.maximumHeight: 50
                Layout.maximumWidth: 120
                radius: 16

                textButton: qsTr("Create")

                fontButton.family: "Qicksand"
                fontButton.pixelSize: 20
                horizontalAligmentText: Qt.AlignHCenter

                enabled: textInputNameWallet.length > 0 ? true : false

                onClicked:
                {
                    logicMainApp.requestToService("DapAddWalletCommand",
                           textInputNameWallet.text,
                           certListModel.get(0).sign)

                    close()
                }
            }
        }
    }
}
