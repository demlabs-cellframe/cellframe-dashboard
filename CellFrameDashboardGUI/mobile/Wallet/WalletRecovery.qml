import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "qrc:/widgets/"

Page {
    title: qsTr("Recovery method")
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

        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter

            CustomRadioButton {
                Layout.alignment: Qt.AlignHCenter
                checked: true
                text: qsTr("24 words")
            }

            Rectangle
            {
                Layout.fillWidth: true
                height: 1
                color: "#6B6979"
            }

            CustomRadioButton {
                Layout.alignment: Qt.AlignHCenter
                text: qsTr("Export to file")
            }

            Rectangle
            {
                Layout.fillWidth: true
                height: 1
                color: "#6B6979"
            }

            CustomRadioButton {
                Layout.alignment: Qt.AlignHCenter
                text: qsTr("Nothing")
            }
        }

        Item {
            Layout.fillHeight: true
        }

        RowLayout
        {
            Layout.fillWidth: true
            spacing: 17 * pt

            DapButton
            {
                Layout.fillWidth: true

                implicitWidth: 132 * pt
                implicitHeight: 36 * pt
                radius: currTheme.radiusButton

                textButton: qsTr("Back")

                fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium14
                horizontalAligmentText: Text.AlignHCenter
                onClicked:
                {
                    mainStackView.pop()
                }

            }

            DapButton
            {
                Layout.fillWidth: true

                implicitWidth: 132 * pt
                implicitHeight: 36 * pt
                radius: currTheme.radiusButton

                textButton: qsTr("Next")

                fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium14
                horizontalAligmentText: Text.AlignHCenter
                onClicked:
                {
                    mainStackView.push("qrc:/mobile/Wallet/Wallet24Words.qml")
                }

            }
        }

        Item {
            Layout.fillHeight: true
        }

    }
}