import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4

import "../../"

Item {
    anchors.fill: parent

    signal closing()

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
        }

        ColumnLayout
        {
            anchors.fill: parent

            Rectangle
            {
                id: frameInputNameCertificate
                height: 60 
                color: "transparent"
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter

                TextField
                {
                    id: textInputNameCertificate
                    placeholderText: qsTr("Input name of certificate")
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

                textButton: "Create"

                fontButton.family: "Qicksand"
                fontButton.pixelSize: 16
                horizontalAligmentText: Qt.AlignHCenter

                enabled: textInputNameCertificate.length > 0 ? true : false

                onClicked:
                {
                    logicMainApp.requestToService("DapCertificateManagerCommands"
                                                          , 2 //create cert command into service
                                                          , textInputNameCertificate.text, signatureTypeWallet.get(0).sign
                                                          , getDataToJson());
                    close()
                }

                function getDataToJson(){
                    var result = { a0_creation_date: Qt.formatDateTime(new Date(), "dd.MM.yyyy") }


                    return result
                }
            }
        }
    }
}
