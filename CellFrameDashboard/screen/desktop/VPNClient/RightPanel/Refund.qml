import QtQuick 2.4
import QtQuick.Controls 1.4 as Controls
import QtQuick.Controls.Styles 1.4 as Styles
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "qrc:/widgets" as Widgests
import "../../controls"

Item
{
    ListModel {
        id: refundModel
        ListElement {
            check: false
            value: 123
            balance: 1234.45
            token: "KELT"
        }
        ListElement {
            check: false
            value: 123.45
            balance: 12.3
            token: "DAPS"
        }
        ListElement {
            check: false
            value: 123
            balance: 24.636
            token: "USDT"
        }
    }

    readonly property int refundDelegateHeight: 140

    signal checkBoxSwitched()

    ColumnLayout
    {
        anchors.fill: parent

        RowLayout
        {
            Layout.fillWidth: true
            Layout.leftMargin: 10
            Layout.minimumHeight: 30

            spacing: 10

            HeaderButtonForRightPanels
            {
                Layout.maximumWidth: 20 * pt
                Layout.maximumHeight: 20 * pt
                Layout.topMargin: 10 * pt
                Layout.bottomMargin: 2 * pt

                height: 20 * pt
                width: 20 * pt
                heightImage: 20 * pt
                widthImage: 20 * pt

                normalImage: "qrc:/Resources/"+pathTheme+"/icons/other/cross.svg"
                hoverImage:  "qrc:/Resources/"+pathTheme+"/icons/other/cross_hover.svg"
                onClicked: vpnClientNavigator.openVpnOrders()
            }

            Text
            {
                Layout.fillWidth: true
                Layout.topMargin: 8
                verticalAlignment: Qt.AlignVCenter
                font: mainFont.dapFont.medium14
//                font.bold: true
                color: currTheme.textColor

                text: qsTr("Refund")
            }
        }

        Rectangle
        {
            Layout.fillWidth: true
            Layout.minimumHeight: 30 * pt
            color: currTheme.backgroundMainScreen

            Text
            {
                anchors.fill: parent
                anchors.leftMargin: 10 * pt
                color: currTheme.textColor
                font: mainFont.dapFont.medium12
                verticalAlignment: Qt.AlignVCenter
                text: qsTr("Choose token and input value")
            }
        }

        ListView
        {
            Layout.fillWidth: true
            Layout.minimumHeight:
                refundModel.count * refundDelegateHeight
            Layout.leftMargin: 10
            Layout.rightMargin: 10
            Layout.topMargin: 10
            Layout.bottomMargin: 10
            clip: true
//                ScrollBar.vertical: ScrollBar {
//                    active: true
//                }

            model: refundModel

            delegate:
                RowLayout
                {
                    width: parent.width
                    height: refundDelegateHeight
                    spacing: 10 * pt

                    Widgests.DapRadioButton
                    {
                        id: refundCheckBox
                        Layout.fillWidth: true
                        Layout.minimumHeight: 40 * pt
                        Layout.minimumWidth: 40 * pt
                        Layout.bottomMargin: 85 * pt
                        indicatorInnerSize: 40 * pt
                        nameTextColor: currTheme.textColor
                        textFont: mainFont.dapFont.regular16
                        textName: token
                        checked: false
                        onToggled:
                        {
                            check = checked
                            checkBoxSwitched()
                        }
                    }

                    ColumnLayout
                    {
                        enabled: refundCheckBox.checked
                        Layout.fillWidth: true
                        //Layout.minimumHeight: refundDelegateHeight
                        spacing: 20 * pt

                        Controls.TextField
                        {
                            id: refundField
                            Layout.minimumWidth: 223 * pt
                            Layout.minimumHeight: 40 * pt
                            Layout.alignment: Qt.AlignRight
                            placeholderText: "0.0"
                            validator: RegExpValidator { regExp: /[0-9]*\.?[0-9]{0,18}/ }
                            font: mainFont.dapFont.regular16
                            horizontalAlignment: Text.AlignRight

                            style:
                                Styles.TextFieldStyle
                                {
                                    textColor: currTheme.textColor
                                    placeholderTextColor: currTheme.textColor
                                    background:
                                        Rectangle
                                        {
                                            border.width: 1
                                            radius: 4 * pt
                                            border.color: currTheme.borderColor
                                            color: currTheme.backgroundElements
                                        }
                                }

                            onTextChanged: value = Number(text)
                        }

                        RowLayout
                        {
                            id: refundRowLayout
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignRight
                            spacing: 5

                            Widgests.DapButton
                            {
                                id: persentButton25
                                Layout.minimumWidth: 52
                                Layout.minimumHeight: 25 * pt
                                horizontalAligmentText: Text.AlignHCenter
                                fontButton: mainFont.dapFont.regular14
                                textButton: qsTr("25%")
                                onClicked:
                                {
                                    refundField.text = balance*0.25
                                    //persentButton75.selected = false
                                    //persentButton100.selected = false
                                    //persentButton50.selected = false
                                    //persentButton25.selected = true
                                }
                            }

                            Widgests.DapButton
                            {
                                id: persentButton50
                                Layout.minimumWidth: 52
                                Layout.minimumHeight: 25 * pt
                                horizontalAligmentText: Text.AlignHCenter
                                fontButton: mainFont.dapFont.regular14
                                textButton: qsTr("50%")
                                onClicked:
                                {
                                    refundField.text = balance*0.5
                                   // persentButton75.highlighted = false
                                   // persentButton100.highlighted = false
                                   // persentButton50.highlighted = true
                                  //  persentButton25.highlighted = false
                                }
                            }

                            Widgests.DapButton
                            {
                                id: persentButton75
                                Layout.minimumWidth: 52
                                Layout.minimumHeight: 25 * pt
                                horizontalAligmentText: Text.AlignHCenter
                                fontButton: mainFont.dapFont.regular14
                                textButton: qsTr("75%")
                                onClicked:
                                {
                                    refundField.text = balance*0.75
                                   // persentButton75.highlighted = true
                                   // persentButton100.highlighted = false
                                   // persentButton50.highlighted = false
                                   // persentButton25.highlighted = false
                                }
                            }

                            Widgests.DapButton
                            {
                                id: persentButton100
                                Layout.minimumWidth: 52
                                Layout.minimumHeight: 25 * pt
                                horizontalAligmentText: Text.AlignHCenter
                                fontButton: mainFont.dapFont.regular14
                                textButton: qsTr("100%")
                                onClicked:
                                {
                                    refundField.text = balance
                                   // persentButton75.hovered = false
                                  //  persentButton100.hovered = true
                                  //  persentButton50.hovered = false
                                   // persentButton25.hovered = false
                                }
                            }
                        }

                        Text
                        {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignTop
                            horizontalAlignment: Qt.AlignRight
                            color: currTheme.textColorGray
                            font: mainFont.dapFont.medium12
                            text: qsTr("Available ") + balance + " " + token
                        }
                    }
                }
        }

        Item
        {
            Layout.fillHeight: true
        }
    }


    Widgests.DapButton
    {
        id: refundButton
        x: parent.width * 0.5 - width * 0.5
        y: parent.height - height - 40 * pt
        width: 150 * pt
        height: 36 * pt
        horizontalAligmentText: Text.AlignHCenter
        fontButton: mainFont.dapFont.regular16
        textButton: qsTr("Refund")
    }

    onCheckBoxSwitched:
    {
        print("onCheckBoxSwitched")
        var test = false
        for (var i = 0; i < refundModel.count; ++i)
        {
            if (refundModel.get(i).check)
            {
                test = true
                break
            }
        }
        print("test", test)
        refundButton.enabled = test
    }
}
