import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../../controls"

Item
{
    id: mainItem

    property string parameterName: ""
    property alias parameterValue: textInputNameWallet.text

    property bool node: true
    property string networkName: ""
    property string groupName: ""
    property string valueName: ""

    signal confirm()

    Page
    {
        id: page

        x: 0
        y: dapMainWindow.height + height
        width: dapMainWindow.width
        height: 260

        Behavior on y{
            NumberAnimation{
                duration: 200
            }
        }

        onVisibleChanged:
        {
            if (visible)
                y = dapMainWindow.height - height
            else
                y = dapMainWindow.height + height
        }

        background: Rectangle {
            color: currTheme.mainBackground
            radius: 30
            border.width: 1
            border.color: currTheme.border
            Rectangle {
                width: 30
                height: 30
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.leftMargin: 1
                anchors.bottomMargin: 1
                color: currTheme.mainBackground
            }
            Rectangle {
                width: 30
                height: 30
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.rightMargin: 1
                anchors.bottomMargin: 1
                color: currTheme.mainBackground
            }
        }

        Text
        {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 16

            horizontalAlignment: Text.AlignHCenter

            font: mainFont.dapFont.bold14
            color: currTheme.white

            text: parameterName
        }

        Image {
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 16
            z: 1

            source: area.containsMouse? "qrc:/walletSkin/Resources/BlackTheme/icons/new/cross_hover.svg" :
                                        "qrc:/walletSkin/Resources/BlackTheme/icons/new/cross.svg"
            mipmap: true

            MouseArea{
                id: area
                anchors.fill: parent
                hoverEnabled: true
                onClicked:
                {
                    dapBottomPopup.hide()
                }
            }
        }

        ColumnLayout
        {
            anchors.fill: parent
            anchors.topMargin: 35
            anchors.leftMargin: 16
            anchors.rightMargin: 16

            spacing: 10

            Text
            {
                Layout.fillWidth: true
                Layout.topMargin: 20

                text: parameterName + qsTr(" to listen on")
                color: currTheme.gray
                font: mainFont.dapFont.regular12

                verticalAlignment: Text.AlignVCenter
            }

            DapWalletTextField
            {
                id: textInputNameWallet
                Layout.fillWidth: true
                Layout.minimumHeight: 40
                Layout.maximumHeight: 40
//                placeholderText: qsTr("Your wallet name")
                validator: RegExpValidator { regExp: /[0-9\.]+/ }
                font: mainFont.dapFont.regular16
                horizontalAlignment: Text.AlignLeft

//                text: parameterValue

                placeholderColor: currTheme.gray
                backgroundColor: currTheme.secondaryBackground
                selectByMouse: true

                onUpdateFeild:
                {
                    if(textInputNameWallet.activeFocus)
                    {
                        var delta = textInputNameWallet.getDelta()
                        if(delta)
                        {
                            page.y = dapMainWindow.height - (page.height + delta)
                        }
                    }
                    else
                    {
                        page.y = dapMainWindow.height - page.height
                    }
                }
            }

            DapButton
            {
        //        enabled: false
                Layout.alignment: Qt.AlignCenter
                Layout.topMargin: 15
                implicitHeight: 36
                implicitWidth: 132
                textButton: qsTr("Confirm")
                horizontalAligmentText: Text.AlignHCenter
                indentTextRight: 0
                fontButton: mainFont.dapFont.medium14

                onClicked:
                {
                    if (node)
                        configWorker.writeNodeValue(
                            groupName, valueName, textInputNameWallet.text)
                    else
                        configWorker.writeConfigValue(networkName,
                            groupName, valueName, textInputNameWallet.text)

                    dapBottomPopup.hide()

                    mainItem.confirm()
                }
            }

            Item
            {
                Layout.fillHeight: true
            }
        }

    }

}
