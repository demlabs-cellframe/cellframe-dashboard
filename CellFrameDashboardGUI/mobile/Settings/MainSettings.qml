import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "qrc:/widgets/"
import "../"

Page {
    title: qsTr("Settings")
    background: Rectangle {color: currTheme.backgroundMainScreen }

    ColumnLayout
    {
        anchors.fill: parent
        anchors.topMargin: 10 * pt

        ListView {
            id: controlList
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 20

            clip: true

//            model: tokensModelTest
            model: walletsModel

            ScrollBar.vertical: ScrollBar {
                active: true
            }

            delegate:
                Item{
    //                width: parent.width
                height: 40
    //                anchors.margins: 10
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 15 * pt
                anchors.rightMargin: 15 * pt

    //                anchors.fill: parent
                Rectangle {
                    id: headerRect
                    anchors.fill: parent
                    color: index === currentWallet? currTheme.buttonColorNormalPosition0 : "#32363D"
                    radius: 10
                }
                InnerShadow {
                    id: id1
                    anchors.fill: headerRect
                    radius: 10.0
                    samples: 10
                    cached: true
                    horizontalOffset: 2
                    verticalOffset: 2
                    color: "#505050"
                    source: headerRect
                }
                DropShadow {
                    anchors.fill: headerRect
                    radius: 10.0
                    samples: 10
                    cached: true
                    horizontalOffset: 2
                    verticalOffset: 2
                    color: "#252525"
                    source: id1
                }

                RowLayout
                {
                    anchors.fill: parent
                    anchors.leftMargin: 15 * pt
                    anchors.rightMargin: 15 * pt

                    Label {
                        id: nameWall
                        Layout.fillWidth: true

                        text: name
                        font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium16
                        color: currTheme.textColor
                    }

                    Label {
                        Layout.fillWidth: true
                        Layout.maximumWidth: controlList.width/2.5
                        text: networks.get(currentNetwork).address
                        font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium16
                        color: currTheme.textColor
                        elide: Text.ElideMiddle
                    }

                    MouseArea {
                        id:controlCopy

                        Layout.fillWidth: true
                        Layout.minimumWidth: 20 * pt
                        Layout.maximumWidth: 20 * pt
                        Layout.minimumHeight: 20 * pt
                        Layout.maximumHeight: 20 * pt
                        hoverEnabled: true
//                        onClicked: controlList.copyStringToClipboard(address)

                        DapImageLoader {
                            id: networkAddrCopyButtonImage


                            innerWidth: parent.width
                            innerHeight: parent.height
                            source: parent.containsMouse ? "qrc:/resources/icons/" + pathTheme + "/ic_copy_hover.png" : "qrc:/resources/icons/" + pathTheme + "/ic_copy.png"
                        }
                    }
                }

                MouseArea
                {
                    anchors.fill: parent
                    onClicked:
                    {
                        if(!controlCopy.containsMouse)
                        {
                            if(index !== currentWallet)
                                controlList.setSelected(index)
                        }else
                            controlList.copyStringToClipboard(model.get(index).networks.get(currentNetwork).address)
                    }
                }
            }
            TextEdit {
                id: textEdit
                visible: false
            }

            function setSelected(index)
            {
                currentWallet = index;
                nameWallet.text = walletsModel.get(currentWallet).name
            }

            function copyStringToClipboard(address)
            {
                textEdit.text = address
                textEdit.selectAll()
                textEdit.copy()
            }
        }
        DapButton
        {
            Layout.alignment: Qt.AlignHCenter

            implicitWidth: 200 * pt
            implicitHeight: 36 * pt
            radius: currTheme.radiusButton

            textButton: qsTr("Create new wallet")

            fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium16
            horizontalAligmentText: Text.AlignHCenter
            colorTextButton: "#FFFFFF"
            onClicked:
            {
                mainStackView.push("qrc:/mobile/Wallet/WalletName.qml")
            }

        }

        DapButton
        {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 10 * pt

            implicitWidth: 200 * pt
            implicitHeight: 36 * pt
            radius: currTheme.radiusButton

            textButton: qsTr("Import an existing wallet")

            fontButton: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium16
            horizontalAligmentText: Text.AlignHCenter
            colorTextButton: "#FFFFFF"
            onClicked:
            {
                mainStackView.push("qrc:/mobile/Wallet/WalletName.qml")
            }


        }

        Item
        {
            Layout.fillHeight: true
        }
    }
}
