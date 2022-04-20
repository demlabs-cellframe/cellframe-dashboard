import QtQuick 2.4
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import "qrc:/widgets"

ColumnLayout
{
    id:control
    anchors.fill: parent

    property alias dapWalletsButtons : buttonGroup
    property int dapCurrentWallet: logicMainApp.currentIndex
    property alias dapNetworkComboBox: comboBoxCurrentNetwork

    spacing: 0

    Item
    {
        Layout.fillWidth: true
        height: 38 * pt

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
            id: comboBoxCurrentNetwork
            model: dapNetworkModel

            anchors.centerIn: parent
            anchors.fill: parent
            anchors.margins: 10 * pt
            anchors.leftMargin: 15 * pt

            comboBoxTextRole: ["name"]
            mainLineText: {
                if(dapNetworkModel.count)
                    return dapNetworkModel.get(logicMainApp.currentNetwork).name
                else
                    return "Networks"
            }

            indicatorImageNormal: "qrc:/resources/icons/"+pathTheme+"/icon_arrow_down.png"
            indicatorImageActive: "qrc:/resources/icons/"+pathTheme+"/ic_arrow_up.png"
            sidePaddingNormal: 10 * pt
            sidePaddingActive: 10 * pt

            widthPopupComboBoxNormal: 318 * pt
            widthPopupComboBoxActive: 318 * pt
            heightComboBoxNormal: 24 * pt
            heightComboBoxActive: 42 * pt
            topEffect: false

            normalColor: currTheme.backgroundMainScreen
            normalTopColor: currTheme.backgroundElements
            hilightTopColor: currTheme.backgroundMainScreen

            paddingTopItemDelegate: 8 * pt
            heightListElement: 42 * pt
            indicatorWidth: 24 * pt
            indicatorHeight: indicatorWidth
            roleInterval: 15
            endRowPadding: 37

            fontComboBox: [mainFont.dapFont.regular14]
            colorMainTextComboBox: [[currTheme.textColor, currTheme.textColor], [currTheme.textColor, currTheme.textColor]]
            alignTextComboBox: [Text.AlignLeft, Text.AlignRight]

//            currentIndex: logicMainApp.currentNetwork

            onCurrentIndexChanged:
            {
                dapServiceController.setCurrentNetwork(dapNetworkModel.get(currentIndex).name);
                dapServiceController.setIndexCurrentNetwork(currentIndex);
                logicMainApp.currentNetwork = currentIndex
            }
        }

    }

    Item
    {
        height: 45 * pt
        Layout.fillWidth: true
        DapCheckBox
        {
            id: checkBox
            width: 100 * pt
            height: 45 * pt
            indicatorInnerSize: 45 * pt
            nameTextColor: currTheme.textColor
            nameCheckbox: "Auto online"
            property bool isCheck: false

            Component.onCompleted:
            {
                checkBox.checkState = dapServiceController.getAutoOnlineValue();
                isCheck = true
            }

            onCheckStateChanged: if (isCheck) popup.open()

            Popup
            {
                id: popup
                width: 300 * pt
                height: 200 * pt

                parent: control.parent
                x: (parent.width - width) * 0.5
                y: (parent.height - height) * 0.5

                scale: mainWindow.scale

                modal: true

                closePolicy: Popup.NoAutoClose

                background: Rectangle
                {
                    border.width: 0
                    radius: 16 * pt
                    color: currTheme.backgroundElements
                }

                ColumnLayout
                {
                    anchors.fill: parent
                    anchors.margins: 10 * pt

                    Text {
                        Layout.fillWidth: true
                        Layout.leftMargin: 5
                        Layout.rightMargin: 5
                        Layout.topMargin: 5
                        font: mainFont.dapFont.medium16
                        color: currTheme.textColor
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WordWrap
                        text: "Node will be reboot"
                    }

                    Item
                    {
                        Layout.fillWidth: true
                        height: 40 * pt

                        DapButton
                        {
                            width: parent.width * 0.4
                            height: parent.height
                            textButton: "Ok"
                            fontButton: mainFont.dapFont.regular16
                            horizontalAligmentText: Qt.AlignHCenter


                            onClicked:
                            {
                                var val = (checkBox.checkState === 2)
                                console.log("kkkkkkkkkkkkkkk", val)
                                dapServiceController.requestToService("DapNodeConfigController", "AddNewValue", val);
                                popup.close()
                            }
                        }

                        DapButton
                        {
                            width: parent.width * 0.4
                            x: parent.width - width
                            height: parent.height
                            textButton: "Cansel"
                            fontButton: mainFont.dapFont.regular16
                            horizontalAligmentText: Qt.AlignHCenter

                            onClicked: popup.close()
                        }
                    }
                }
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
//                height: 50 * pt
                Layout.fillWidth: true
                Layout.fillHeight: true

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
                            MouseArea
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
//                MouseArea
//                {
//                    anchors.fill: parent
//                    onClicked: radioBut.clicked();
//                }
            }
        }
    }
}
