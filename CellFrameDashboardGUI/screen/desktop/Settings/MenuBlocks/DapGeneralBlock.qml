import QtQuick 2.4
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import "../../controls"
import "qrc:/widgets"

import "qrc:/screen"

ColumnLayout
{
    id:control
    anchors.fill: parent

    property alias dapWalletsButtons : buttonGroup
    property int dapCurrentWallet: logicMainApp.currentIndex
    property alias dapNetworkComboBox: comboBoxCurrentNetwork
    property alias dapAutoOnlineCheckBox: checkBox

    spacing: 0

    Item
    {
        Layout.fillWidth: true
        height: 42 * pt

        Text
        {
            anchors.fill: parent
            anchors.leftMargin: 14 * pt
            anchors.topMargin: 10 * pt
            anchors.bottomMargin: 10 * pt
            font: mainFont.dapFont.bold14
            color: currTheme.textColor
            verticalAlignment: Qt.AlignVCenter
            text: qsTr("General settings")
        }
    }

    Rectangle
    {
        Layout.fillWidth: true
        height: 30 * pt
        color: currTheme.backgroundMainScreen

        Text
        {
            anchors.fill: parent
            anchors.leftMargin: 16 * pt
            anchors.topMargin: 8 * pt
            anchors.bottomMargin: 8 * pt
            font: mainFont.dapFont.medium11
            color: currTheme.textColor
            verticalAlignment: Qt.AlignVCenter
            text: qsTr("Networks")
        }
    }

    Item {
        height: 60 * pt
        Layout.fillWidth: true

        DapComboBox
        {
            property bool isInit: false
            id: comboBoxCurrentNetwork
            model: dapNetworkModel

            anchors.centerIn: parent
            anchors.fill: parent
            anchors.margins: 10 * pt
            anchors.bottomMargin: 0
            anchors.leftMargin: 15 * pt

            font: mainFont.dapFont.regular16

            Component.onCompleted: isInit = true

            defaultText: qsTr("Networks")

//            currentIndex: logicMainApp.currentNetwork

            onCurrentIndexChanged:
            {
                if(isInit || (!isInit && logicMainApp.currentNetwork === -1) )
                {
                    dapServiceController.setCurrentNetwork(dapNetworkModel.get(currentIndex).name);
                    dapServiceController.setIndexCurrentNetwork(currentIndex);
                    logicMainApp.currentNetwork = currentIndex
                }
                else
                    currentIndex = logicMainApp.currentNetwork
            }
        }
    }

    Item
    {
        height: 50 * pt
        Layout.fillWidth: true
        Layout.topMargin: -10
        DapCheckBox
        {
            property bool stopUpdate: false
            id: checkBox
            anchors.fill: parent
            anchors.leftMargin: 10 * pt
//            anchors.bottomMargin: 10 * pt
            indicatorInnerSize: height
            nameTextColor: currTheme.textColor
            nameCheckbox: "Auto online"
            property bool isCheck: false

            Component.onCompleted:
            {
                checkBox.checkState = dapServiceController.getAutoOnlineValue()
                isCheck = true
            }

            onClicked:
            {
                stopUpdate = true
                var s
                if (checkState == 0)
                    s = "disable"
                else s = "enable"
                if (isCheck) popup.smartOpen("Confirm restart node", "To " + s + " auto_online it is necessary to restart the node")
            }

            DapMessagePopup
            {
                id: popup
                dapButtonCancel.visible: true
                dapButtonOk.textButton: "Accept"
                onSignalAccept:
                {
                    if (accept)
                    {
                        var val = (checkBox.checkState === 2)
                        dapServiceController.requestToService("DapNodeConfigController", "AddNewValue", val);
                        popup.close()
                    }
                    else
                    {
                        var val
                        if (checkBox.checkState == 0)
                            val = 2
                        else val = 0
                        checkBox.checkState = val
                        popup.close()
                    }
                }
                onClosed:
                    checkBox.stopUpdate = false
            }
        }
    }


    Rectangle
    {
        Layout.fillWidth: true
//        Layout.topMargin: 1 * pt
//        Layout.bottomMargin: 1 * pt
        height: 30 * pt
        color: currTheme.backgroundMainScreen

        Text
        {
            anchors.fill: parent
            anchors.leftMargin: 16 * pt
            anchors.topMargin: 8 * pt
            anchors.bottomMargin: 8 * pt
            font: mainFont.dapFont.medium11
            color: currTheme.textColor
            verticalAlignment: Qt.AlignVCenter
            text: qsTr("Choose a wallet")
        }
    }

    ButtonGroup
    {
        id: buttonGroup
    }

    ListView
    {
        id:listWallet
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.preferredHeight: contentHeight
        model: dapModelWallets
        clip: true
        delegate: delegateList

    }

    Component{
        id:delegateList

        ColumnLayout
        {
            id:columnWallets
            anchors.left: parent.left
            anchors.right: parent.right
            height: 50 * pt
            onHeightChanged: listWallet.contentHeight = height

            Item {
                id: block
//                height: 50 * pt
                Layout.fillWidth: true
                Layout.fillHeight: true

                MouseArea
                {
                    anchors.fill: parent

                    onClicked: radioBut.clicked();
                }

                RowLayout
                {
                    anchors.fill: parent
                    ColumnLayout
                    {
                        Layout.alignment: Qt.AlignLeft
                        Layout.leftMargin: 15 * pt
//                        Layout.topMargin: 4 * pt
//                        Layout.bottomMargin: 14 * pt
                        spacing: 0

                        Text
                        {

                            height: 26*pt
                            Layout.fillWidth: true

                            font: mainFont.dapFont.regular11
                            color: currTheme.textColor
                            verticalAlignment: Qt.AlignVCenter
                            text: name
                            elide: Text.ElideMiddle
                        }
                        RowLayout
                        {
                            id: rowLay
                            Layout.preferredHeight: 16 * pt

                            spacing: 0 * pt
                            DapText
                            {
                               id: textMetworkAddress
                               Layout.preferredWidth: 101 * pt

                               fontDapText: mainFont.dapFont.regular12
                               color: currTheme.textColorGrayTwo
                               fullText: networks.get(dapServiceController.IndexCurrentNetwork).address

                               textElide: Text.ElideMiddle
                               horizontalAlignment: Qt.Alignleft

                               Connections
                               {
                                   target:dapServiceController
                                   onIndexCurrentNetworkChanged:
                                   {
                                       textMetworkAddress.fullText = networks.get(dapServiceController.IndexCurrentNetwork).address
                                       textMetworkAddress.checkTextElide()
//                                       textMetworkAddress.update()
                                       textMetworkAddress.updateText()
//                                       emptyText.copyFullText()

                                   }
                               }

//                               DapText
//                               {
//                                   id: emptyText
//                                   visible: false
//                                   fullText: " "
//                               }
                            }
                            /*MouseArea
                            {
                                id: networkAddressCopyButton
//                                Layout.leftMargin: 3 * pt
                                Layout.preferredHeight: 18 * pt
                                Layout.preferredWidth: 17 * pt
                                hoverEnabled: true

                                onClicked: textMetworkAddress.copyFullText()

                                Image{
                                    id:networkAddressCopyButtonImage
                                    width: parent.width
                                    height: parent.height
                                    mipmap: true
                                    source: parent.containsMouse ? "qrc:/resources/icons/" + pathTheme + "/ic_copy_hover.png" : "qrc:/resources/icons/" + pathTheme + "/ic_copy.png"
                                }
                            }*/
/*                            CopyButton
                            {
                                id: networkAddressCopyButton
                                onCopyClicked: textMetworkAddress.copyFullText()
                            }*/

                            DapCopyButton
                            {
                                id: networkAddressCopyButton
                                popupText: qsTr("Address copied")
                                onCopyClicked:
                                    textMetworkAddress.copyFullText()
                            }
                        }
                    }


                    DapRadioButton
                    {
                        id: radioBut

//                        signal setWallet(var index)

                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        Layout.preferredHeight: 46 * pt
                        Layout.preferredWidth: 46 * pt
                        Layout.rightMargin: 17 * pt
                        Layout.topMargin: 2 * pt

                        ButtonGroup.group: buttonGroup

                        nameRadioButton: qsTr("")
                        indicatorInnerSize: 46 * pt
                        spaceIndicatorText: 3 * pt
                        fontRadioButton: mainFont.dapFont.regular16
                        implicitHeight: indicatorInnerSize
                        checked: index === logicMainApp.currentIndex? true:false

                        onClicked:
                        {
//                            if(!checked)
//                                checked = true
                            dapCurrentWallet = index
                            logicMainApp.currentIndex = index
                        }
                    }
                }
                Rectangle
                {
//                    visible: index === listWallet.count - 1? false : true
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: 1 * pt
                    color: currTheme.lineSeparatorColor

                }
            }
        }
    }
}
