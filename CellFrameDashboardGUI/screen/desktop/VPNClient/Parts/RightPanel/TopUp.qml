import QtQuick 2.4
import QtQuick.Controls 1.4 as Controls
import QtQuick.Controls.Styles 1.4 as Styles
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "qrc:/widgets"

Item
{
    id: topUpItem

    ListModel {
        id: limitModel
        ListElement {
            value: 123
            token: "KELT"
        }
    }

    readonly property int limitDelegateHeight: 40 * pt

    ColumnLayout
    {
        anchors.fill: parent

        RowLayout
        {
            Layout.fillWidth: true
            Layout.leftMargin: 10 * pt
            Layout.minimumHeight: 30 * pt
//            Layout.rightMargin: 10

            spacing: 10

            DapButton
            {
                Layout.maximumWidth: 20 * pt
                Layout.maximumHeight: 20 * pt
                Layout.topMargin: 10 * pt

                height: 20 * pt
                width: 20 * pt
                heightImageButton: 10 * pt
                widthImageButton: 10 * pt
                activeFrame: false
                normalImageButton: "qrc:/resources/icons/"+pathTheme+"/close_icon.png"
                hoverImageButton:  "qrc:/resources/icons/"+pathTheme+"/close_icon_hover.png"
                onClicked: goToHomePage()
            }

            Text
            {
                Layout.fillWidth: true
                Layout.topMargin: 8
                verticalAlignment: Qt.AlignVCenter
                font: mainFont.dapFont.medium14
//                font.bold: true
                color: currTheme.textColor

                text: qsTr("Top up current usage")
            }
        }

        ScrollView
        {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
//            ScrollBar.vertical: ScrollBar {
//                active: true
//            }
            ScrollBar.horizontal: ScrollBar {
                active: false
                visible: false
            }

            ColumnLayout
            {
                width: topUpItem.width
//                height: topUpItem.height
//                anchors.fill: parent
//                anchors.rightMargin: 25 * pt

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
                        text: qsTr("Ammount")
                    }
                }

                ColumnLayout
                {
                    Layout.fillWidth: true
                    Layout.leftMargin: 10 * pt
                    Layout.rightMargin: 10 * pt
                    Layout.topMargin: 10 * pt
                    Layout.bottomMargin: 10 * pt

                    RowLayout
                    {
                        Layout.fillWidth: true

//                        TextField
//                        {
//                            Layout.fillWidth: true
//                            Layout.maximumHeight: 30 * pt
//                            horizontalAlignment: Qt.AlignRight
//                            font.pointSize: 10
//                            placeholderText: "0"
//                        }

                        Controls.TextField
                        {
                            Layout.fillWidth: true
                            Layout.leftMargin: 15 * pt
                            width: 150 * pt
                            height: 28 * pt
            //                        placeholderText: "0"
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
                        }

                        DapComboBox
                        {
                            Layout.minimumWidth: 100 * pt
                            Layout.maximumHeight: 26 * pt
                            indicatorImageNormal: "qrc:/resources/icons/"+pathTheme+"/icon_arrow_down.png"
                            indicatorImageActive: "qrc:/resources/icons/"+pathTheme+"/ic_arrow_up.png"
                            sidePaddingNormal: 10 * pt
                            sidePaddingActive: 10 * pt
            //                            hilightColor: currTheme.buttonColorNormal

                            widthPopupComboBoxNormal: 100 * pt
                            widthPopupComboBoxActive: 100 * pt
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
                            colorDropShadow: currTheme.shadowColor
                            roleInterval: 15
                            endRowPadding: 37

                            fontComboBox: [mainFont.dapFont.regular14]
                            colorMainTextComboBox: [[currTheme.textColor, currTheme.textColor], [currTheme.textColor, currTheme.textColor]]
            //                            colorTextComboBox: [[currTheme.textColor, currTheme.textColor], [currTheme.buttonColorNormal, currTheme.buttonColorNormal]]
                            alignTextComboBox: [Text.AlignLeft, Text.AlignRight]

                            comboBoxTextRole: ["name"]

                            model: dapTokenModel

                            Component.onCompleted:
                            {
                                if (dapTokenModel.count)
                                    mainLineText = dapTokenModel.get(0).name
                            }
                        }

//                        ComboBox
//                        {
//                            Layout.maximumWidth: 100 * pt
//                            Layout.maximumHeight: 30 * pt
//                            font.pointSize: 10
//                            model: dapTokenModel
//                        }
                    }

                    Text
                    {
                        Layout.fillWidth: true
                        Layout.leftMargin: 15 * pt
                        color: currTheme.textColor
                        font: mainFont.dapFont.medium12
                        text: "5m 12d 13h at the current price"
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
                        text: qsTr("Auto balance replenishment")
                    }
                }

                ColumnLayout
                {
                    Layout.fillWidth: true
                    Layout.leftMargin: 20 * pt
                    Layout.rightMargin: 20 * pt
//                    Layout.topMargin: 10 * pt
                    Layout.bottomMargin: 10 * pt

                    DapCheckBox
                    {
                        id: autoTopUpCheckBox
                        Layout.fillWidth: true
                        Layout.maximumHeight: 30 * pt
                        indicatorInnerSize: height
                        nameTextColor: currTheme.textColor
                        nameCheckbox: qsTr("Auto top up")
                    }

                    ListView
                    {
                        Layout.fillWidth: true
                        Layout.minimumHeight:
                            limitModel.count * limitDelegateHeight
                        clip: true
        //                ScrollBar.vertical: ScrollBar {
        //                    active: true
        //                }

                        enabled: autoTopUpCheckBox.checked

                        model: limitModel

                        delegate:
                            RowLayout
                            {
                                width: parent.width
                                height: limitDelegateHeight

                                Text
                                {
                                    color: currTheme.textColor
                                    font: mainFont.dapFont.medium12
                                    text: "Limit"
                                }

                                Controls.TextField
                                {
                                    Layout.fillWidth: true
                                    Layout.leftMargin: 15 * pt
                                    width: 150 * pt
                                    height: 28 * pt
                    //                        placeholderText: "0"
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
                                }

                                DapComboBox
                                {
                                    Layout.minimumWidth: 100 * pt
                                    Layout.maximumHeight: 26 * pt
                                    indicatorImageNormal: "qrc:/resources/icons/"+pathTheme+"/icon_arrow_down.png"
                                    indicatorImageActive: "qrc:/resources/icons/"+pathTheme+"/ic_arrow_up.png"
                                    sidePaddingNormal: 10 * pt
                                    sidePaddingActive: 10 * pt
                    //                            hilightColor: currTheme.buttonColorNormal

                                    widthPopupComboBoxNormal: 100 * pt
                                    widthPopupComboBoxActive: 100 * pt
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
                                    colorDropShadow: currTheme.shadowColor
                                    roleInterval: 15
                                    endRowPadding: 37

                                    fontComboBox: [mainFont.dapFont.regular14]
                                    colorMainTextComboBox: [[currTheme.textColor, currTheme.textColor], [currTheme.textColor, currTheme.textColor]]
                    //                            colorTextComboBox: [[currTheme.textColor, currTheme.textColor], [currTheme.buttonColorNormal, currTheme.buttonColorNormal]]
                                    alignTextComboBox: [Text.AlignLeft, Text.AlignRight]

                                    comboBoxTextRole: ["name"]

                                    model: dapTokenModel

                                    Component.onCompleted:
                                    {
                                        if (dapTokenModel.count)
                                            mainLineText = dapTokenModel.get(0).name
                                    }
                                }
                            }
                    }


                    DapButton
                    {
                        enabled: autoTopUpCheckBox.checked
                        Layout.fillWidth: true
                        Layout.minimumHeight: 20 * pt
//                        font.pointSize: 10
                        horizontalAligmentText: Text.AlignHCenter
                        fontButton: mainFont.dapFont.regular10
                        textButton: qsTr("Add token for auto top up")
                        onClicked:
                        {
                            limitModel.append({ "value" : 0, "token" : "KELT" })
                        }
                    }
                }

                DapButton
                {
                    enabled: !autoTopUpCheckBox.checked
                    Layout.alignment: Qt.AlignHCenter
                    Layout.minimumWidth: 150 * pt
                    Layout.minimumHeight: 36 * pt
                    horizontalAligmentText: Text.AlignHCenter
                    fontButton: mainFont.dapFont.regular16
                    textButton: qsTr("Top up")
                }

                Item
                {
                    Layout.fillHeight: true
                }
            }
        }


    }
}
