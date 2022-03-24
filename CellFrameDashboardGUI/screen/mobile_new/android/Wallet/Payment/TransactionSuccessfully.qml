import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "qrc:/widgets/"

Page {
    title: qsTr("Send " + walletModel.get(currentWallet).networks.get(currentNetwork).tokens.get(currentToken).name)
    background: Rectangle {color: currTheme.backgroundMainScreen }


    ColumnLayout
    {
        anchors.fill: parent
        anchors.margins: 30
        width: parent.width


        Item {
            Layout.fillHeight: true
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium28
            color: currTheme.textColor
            text: qsTr("Placed to mempool")
        }

        Text
        {
            Layout.topMargin: 36 * pt
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter

            text: qsTr("Status")
            color: "#A4A3C0"
            font: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular28
        }

        Text
        {
            Layout.fillWidth: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter

            text: qsTr("Pending")
            color: currTheme.textColor
            font: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandRegular28
        }
        Item {
            Layout.fillHeight: true
        }

        DapButton
        {
            Layout.alignment: Qt.AlignHCenter

            implicitWidth: 132 * pt
            implicitHeight: 36 * pt
            radius: currTheme.radiusButton

            textButton: qsTr("Done")

            fontButton: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium14
            horizontalAligmentText: Text.AlignHCenter
            colorTextButton: "#FFFFFF"
            onClicked:
            {
                window.updateBalance()
                mainStackView.clearAll()

            }

        }


        Item {
            Layout.fillHeight: true
        }

    }


}
