import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "qrc:/widgets/"

Page {
    title: qsTr("Create wallet")
    background: Rectangle {color: currTheme.backgroundMainScreen }

    ColumnLayout
    {
        anchors.fill: parent
        anchors.margins: 30
        width: parent.width
        spacing: 16

        Item {
            Layout.fillHeight: true
        }
        CustomRadioButton {
            Layout.alignment: Qt.AlignHCenter
            width: contentItem.implicitWidth
            checked: true
            contentItem:
            TextField {
//                Layout.alignment: Qt.AlignHCenter

                placeholderText: qsTr("Enter a new wallet name")
                color: "#ffffff"

                background: Rectangle{color:"transparent"}
                onFocusChanged:
                {
                    if(focus)
                        parent.checked = true
                }
            }
        }


        Rectangle
        {
            Layout.fillWidth: true
            height: 1
            color: "#6B6979"
        }

        CustomRadioButton {
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("Use on existing wallet")
        }

        DapButton
        {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 14 * pt

            implicitWidth: 132 * pt
            implicitHeight: 36 * pt
            radius: currTheme.radiusButton

            textButton: qsTr("Next")

            fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium14
            horizontalAligmentText:Qt.AlignCenter
            colorTextButton: "#FFFFFF"
            onClicked:
            {
                mainStackView.push("qrc:/mobile/Wallet/WalletSignature.qml")
            }

        }



//        Button {
//            Layout.alignment: Qt.AlignHCenter
//            Layout.topMargin: 14 * pt

//            text: qsTr("Next")
//            onClicked:
//            {
//                mainStackView.push("qrc:/mobile/Wallet/WalletSignature.qml")
//            }
//        }

        Item {
            Layout.fillHeight: true
        }

    }
}
