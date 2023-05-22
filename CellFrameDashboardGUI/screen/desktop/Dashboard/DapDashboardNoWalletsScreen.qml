import QtQuick.Window 2.2
import QtQml 2.12
import QtGraphicalEffects 1.0
import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "../controls"
import "qrc:/widgets"

Page
{
    id: dapDiagnosticScreen

    background: Rectangle { color: currTheme.mainBackground}

    DapRectangleLitAndShaded
    {
        id: mainFrame
        anchors.fill: parent
        color: currTheme.secondaryBackground
        radius: currTheme.frameRadius
        shadowColor: currTheme.shadowColor
        lightColor: currTheme.reflectionLight

        contentData:
        ColumnLayout
        {
            anchors.fill: parent
            anchors.bottomMargin: 67
            spacing: 0

            Item{Layout.fillHeight: true}

            Image
            {
                Layout.alignment: Qt.AlignHCenter
                source: "qrc:/Resources/" + pathTheme + "/Illustratons/wallet_illustration.png"
                mipmap: true
                fillMode: Image.PreserveAspectFit
            }

            DapButton
            {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 48

                id: addWalletButton

                implicitWidth: 184
                implicitHeight: 36
                textButton: qsTr("Create wallet")
                fontButton: mainFont.dapFont.medium14
                horizontalAligmentText:Qt.AlignCenter
                onClicked: navigator.createWallet()
            }

            RowLayout{
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 24
                spacing: 4

                Text
                {
                    font: mainFont.dapFont.medium14
                    color: currTheme.white
                    text: qsTr("Already have a wallet ?")
                }
                Text
                {
                    font: mainFont.dapFont.medium14
                    color: area.containsMouse ? currTheme.orange
                                              : currTheme.lime
                    text: qsTr("Import")

                    MouseArea{
                        id: area
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: navigator.restoreWalletFunc()
                    }
                }
            }
            Item{Layout.fillHeight: true}
        }
    }
}
