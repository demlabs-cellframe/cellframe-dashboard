import QtQuick 2.4
import QtQml 2.12
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
        height: 42

        Text
        {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.verticalCenter: parent.verticalCenter
            font: mainFont.dapFont.bold14
            color: currTheme.textColor
            verticalAlignment: Qt.AlignVCenter
            text: qsTr("General settings")
        }
    }

    Rectangle
    {
        Layout.fillWidth: true
        height: 30
        color: currTheme.backgroundMainScreen

        Text
        {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.verticalCenter: parent.verticalCenter
            font: mainFont.dapFont.medium12
            color: currTheme.textColor
            verticalAlignment: Qt.AlignVCenter
            text: qsTr("Networks")
        }
    }

    Item {
        height: 60
        Layout.fillWidth: true

        DapCustomComboBox
        {
            property bool isInit: false
            id: comboBoxCurrentNetwork
            model: dapNetworkModel

            anchors.centerIn: parent
            anchors.fill: parent
            anchors.margins: 10
            anchors.bottomMargin: 0
            anchors.topMargin: 5
            anchors.leftMargin: 10

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
                    setCurrentIndex(logicMainApp.currentNetwork)
            }
        }
    }

    Item
    {
        height: 50
        Layout.fillWidth: true
        Layout.topMargin: -7
        DapCheckBox
        {
            property bool stopUpdate: false
            id: checkBox
            anchors.fill: parent
            anchors.leftMargin: 10
//            anchors.bottomMargin: 10
            indicatorInnerSize: height
            nameTextColor: currTheme.textColor
            nameCheckbox: "Autoonline"
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
        Layout.topMargin: 8
//        Layout.bottomMargin: 1
        height: 30
        color: currTheme.backgroundMainScreen

        Text
        {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.verticalCenter: parent.verticalCenter
            font: mainFont.dapFont.medium12
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
            height: 50
            onHeightChanged: listWallet.contentHeight = height

            Item {
                id: block
//                height: 50
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
                    anchors.leftMargin: 16
                    anchors.verticalCenter: parent.verticalCenter
                    ColumnLayout
                    {
                        Layout.alignment: Qt.AlignLeft
                        spacing: 2

                        Item{
                            Layout.fillWidth: true
//                            Layout.rightMargin: 110
                            height: 14

                            DapBigText
                            {
                                id: nameText
                                anchors.fill: parent
                                textFont: mainFont.dapFont.regular11
                                fullText: name
                            }
                        }

                        RowLayout
                        {
                            id: rowLay
                            Layout.preferredHeight: 15

                            visible: status === "Active" || status === ""

                            spacing: 0
                            DapText
                            {
                               id: textMetworkAddress
                               Layout.preferredWidth: 69

                               fontDapText: mainFont.dapFont.regular12
                               color: currTheme.textColorGrayTwo
                               fullText: rowLay.visible ? networks.get(dapServiceController.IndexCurrentNetwork).address : ""

                               textElide: Text.ElideMiddle
                               horizontalAlignment: Qt.Alignleft

                               Connections
                               {
                                   target:dapServiceController
                                   onIndexCurrentNetworkChanged:
                                   {
                                       textMetworkAddress.fullText = rowLay.visible ? networks.get(dapServiceController.IndexCurrentNetwork).address : ""
                                       textMetworkAddress.checkTextElide()
//                                       textMetworkAddress.update()
                                       textMetworkAddress.updateText()
//                                       emptyText.copyFullText()
                                   }
                               }
                            }

                            DapCopyButton
                            {
                                id: networkAddressCopyButton
                                popupText: qsTr("Address copied")
                                onCopyClicked:
                                    textMetworkAddress.copyFullText()
                            }
                        }
                    }

                    DapToolTipInfo{
                        id: activeStatus
                        Layout.rightMargin: 3
                        Layout.preferredHeight: 24
                        Layout.preferredWidth: 24
                        visible: model.status !== ""
                        text.wrapMode: Text.NoWrap

                        toolTip.width: text.implicitWidth + 16
                        toolTip.x: -toolTip.width/2 + 8

                        contentText: model.status === "Active" ? "Deactivate wallet" : "Activate wallet"

                        indicatorSrcNormal: model.status === "Active" ? "qrc:/Resources/BlackTheme/icons/other/icon_activate.svg":
                                                                        "qrc:/Resources/BlackTheme/icons/other/icon_deactivate.svg"
                        indicatorSrcHover: model.status === "Active" ? "qrc:/Resources/BlackTheme/icons/other/icon_activateHover.svg":
                                                                       "qrc:/Resources/BlackTheme/icons/other/icon_deactivateHover.svg"

                        onClicked:
                            model.status === "Active" ? walletDeactivatePopup.show(name):
                                                               walletActivatePopup.show(name, false)
                    }




                    DapRadioButton
                    {
                        id: radioBut

//                        signal setWallet(var index)

                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        Layout.preferredHeight: 46
                        Layout.preferredWidth: 46
                        Layout.rightMargin: 11
//                        Layout.topMargin: 2

                        ButtonGroup.group: buttonGroup

                        nameRadioButton: qsTr("")
                        indicatorInnerSize: 46
                        spaceIndicatorText: 3
                        fontRadioButton: mainFont.dapFont.regular16
                        implicitHeight: indicatorInnerSize
                        checked: index === logicMainApp.currentIndex? true:false

                        onClicked:
                        {
                            if(status === "Active" || status === "")
                            {
                                dapCurrentWallet = index
                                logicMainApp.currentIndex = index
                            }
                            else
                                walletActivatePopup.show(name, false)
                        }

                        Connections{
                            target: walletActivatePopup
                            onActivatingSignal:{
                                if(nameWallet === name && statusRequest)
                                {
                                    dapCurrentWallet = index
                                    logicMainApp.currentIndex = index
                                }
                            }
                        }
                    }
                }

                Rectangle
                {
//                    visible: index === listWallet.count - 1? false : true
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: 1
                    color: currTheme.lineSeparatorColor
                }
            }
        }
    }
}
