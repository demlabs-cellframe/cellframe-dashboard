import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "qrc:/widgets/"

Page {
    title: qsTr("Successfully!")
    background: Rectangle {color: currTheme.backgroundMainScreen }

    ColumnLayout
    {
        anchors.fill: parent
        anchors.margins: 30
        width: parent.width
        spacing: 30

        Item {
            Layout.fillHeight: true
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium28
            color: currTheme.textColor
            text: qsTr("Wallet created successfully")
            wrapMode: Text.WordWrap
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

            fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium14
            horizontalAligmentText:Qt.AlignCenter
            colorTextButton: "#FFFFFF"
            onClicked:
            {
                mainStackView.clearAll()
            }

        }


        Item {
            Layout.fillHeight: true
        }

    }
}
