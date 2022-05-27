import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "qrc:/widgets"
import "../logic"

/************************************************************************************************
                                DapUiQmlWidgetChainExchanges
-------------------------------------------------------------------------------------------------
                                        OrderPanel
************************************************************************************************/

///Order panel
Item
{
    property string titleOrder: ""
    property string imagePath: ""
    property string currencyName: ""
    property string tokenName: ""
    property string balance: ""

    property int fromStringReadOnly: btnMarket.checked ? 0 : 1

    width: 260 * pt
//    height: childrenRect.height

    ColumnLayout
    {
        anchors.fill: parent
//        anchors.top: parent.top
//        anchors.topMargin: 16 * pt
        spacing: 0 * pt

        ///The header of the panel
        Item
        {
            Layout.fillWidth: true
            height: childrenRect.height

            //Title line
            RowLayout
            {
                spacing: 8 * pt
                Item
                {
                    width: 20 * pt
                    height: 20 * pt

                    //Title order image
                    Image
                    {
                        source: imagePath
                        anchors.fill: parent
                    }
                }
                //Title order text
                Text
                {
                    color: currTheme.textColor
                    font:  mainFont.dapFont.regular16
                    text: titleOrder
                }
            }
        }

        Item
        {
            Layout.fillWidth: true
            Layout.maximumHeight: 10 * pt
        }

        //Balance in the order panel
        Text
        {
            Layout.fillWidth: true
            Layout.maximumHeight: 20 * pt
            text: qsTr("Balance: ") + balance + " " + currencyName
            color: currTheme.textColor
            font:  mainFont.dapFont.regular12
        }

        Item
        {
            Layout.fillWidth: true
            Layout.maximumHeight: 20 * pt
        }

        Item
        {
            Layout.fillWidth: true
            Layout.fillHeight: true
//            width: childrenRect.width
//            height: childrenRect.height

            //List of order lines
            ListModel
            {
                id: modelInputFrame
                ListElement{titleToken:"Ammount";token:""}
                ListElement{titleToken:"Price";token:"10 800.47"}
                ListElement{titleToken:"Total";token:"0"}
            }

            ///Input fields via repeater
            ColumnLayout
            {
                anchors.fill: parent
                spacing: 16 * pt
                Item
                {
                    Layout.fillWidth: true
                    id: frameButton
//                            width: childrenRect.width
                    height: childrenRect.height

                    //Frame Buttons-checkers(Market/Limit)
                    RowLayout
                    {
                        spacing: 16 * pt

                        DapButton
                        {
                            id: btnMarket
//                                    anchors.left: parent.left
                            Layout.fillWidth: true
                            textButton: "Market"
                            implicitWidth: 58 * pt
                            implicitHeight: 24 * pt
                            checkable: true
                            checked: true
                            colorBackgroundNormal: checked ? "#F8F7FA" : "#FFFFFF"
                            colorBackgroundHover: checked ? "#F8F7FA" : "#FFFFFF"
                            horizontalAligmentText:Qt.AlignHCenter
                            borderColorButton: checked ? "#070023" : "#908D9D"
                            borderWidthButton: 1 * pt
                            fontButton: mainFont.dapFont.regular11
                            colorTextButton: checked ? "#070023" : "#908D9D"

                            onClicked:
                            {
                                btnMarket.checked = true;
                                btnLimit.checked = false;
                            }

                        }

                        DapButton
                        {
                            id: btnLimit
//                                    anchors.right: parent.right
                            Layout.fillWidth: true
                            textButton: "Limit"
                            implicitWidth: 50 * pt
                            implicitHeight: 24 * pt
                            checked: false
                            checkable: true
                            colorBackgroundNormal: checked ? "#F8F7FA" : "#FFFFFF"
                            colorBackgroundHover: checked ? "#F8F7FA" : "#FFFFFF"
                            horizontalAligmentText:Qt.AlignHCenter
                            borderColorButton: checked ? "#070023" : "#908D9D"
                            borderWidthButton: 1 * pt
                            fontButton: mainFont.dapFont.regular11
                            colorTextButton: checked ? "#070023" : "#908D9D"

                            onClicked:
                            {
                                btnMarket.checked = false;
                                btnLimit.checked = true;
                            }
                        }
                    }
                }

                ListView
                {
                    Layout.fillWidth: true
//                    Layout.fillHeight: true
                    Layout.minimumHeight: 100
                    clip: true

                    model: modelInputFrame

                    delegate:
                        RowLayout
                        {
                            width: parent.width
                            height: 25

                            spacing: 0
                            Item
                            {
//                                height: childrenRect.height
                                height: 20
                                width: 118 * pt

                                //String name. Text from model
                                Text
                                {
                                    text: titleToken
                                    color: currTheme.textColor
                                    font:  mainFont.dapFont.regular12
                                }
                            }

                            //String field
                            Rectangle
                            {
                                width: 130 * pt
                                height: 22 * pt
                                radius: 6
                                border.width: 1 * pt
                                border.color:
                                {
                                    if(!currencyTextInput.readOnly)
                                        return "#908D9D"
                                    else
                                        return "#C7C6CE"
                                }
                                color: currTheme.backgroundMainScreen

                                //Input field
                                TextInput
                                {
                                    id: currencyTextInput
                                    anchors.left: parent.left
                                    anchors.top: parent.top
                                    anchors.bottom: parent.bottom
                                    anchors.right: textCurrency.left
                                    anchors.leftMargin: 6 * pt
                                    anchors.rightMargin: 6 * pt
                                    color: readOnly ? "#ACAAB5" : "#59556C"
                                    font:  mainFont.dapFont.regular12
                                    verticalAlignment: Qt.AlignVCenter
                                    validator: RegExpValidator{ regExp: /\d+/ }
                                    clip: true
                                    readOnly:index > fromStringReadOnly ? true : false
                                    text: token//readOnly ? "0" : ""

                                }

                                //Mark to input field
                                Text
                                {
                                    id: textCurrency
                                    anchors.right: parent.right
                                    anchors.top: parent.top
                                    anchors.bottom: parent.bottom
                                    anchors.rightMargin: 6 * pt
                                    verticalAlignment: Text.AlignVCenter
                                    horizontalAlignment: Text.AlignRight
                                    color: currTheme.textColor
                                    font:  mainFont.dapFont.regular12
                                    text: index === 0 ? currencyName : tokenName
                                }
                            }
                        }

                }

                //Order Fields
/*                Repeater
                {
                    model: modelInputFrame
                    RowLayout
                    {
                        spacing: 0
                        Item
                        {
                            height: childrenRect.height
                            width: 118 * pt

                            //String name. Text from model
                            Text
                            {
                                text: titleToken
                                color: currTheme.textColor
                                font:  mainFont.dapFont.regular12
                            }
                        }

                        //String field
                        Rectangle
                        {
                            width: 130 * pt
                            height: 22 * pt
                            radius: 6
                            border.width: 1 * pt
                            border.color:
                            {
                                if(!currencyTextInput.readOnly)
                                    return "#908D9D"
                                else
                                    return "#C7C6CE"
                            }
                            color: currTheme.backgroundMainScreen

                            //Input field
                            TextInput
                            {
                                id: currencyTextInput
                                anchors.left: parent.left
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                anchors.right: textCurrency.left
                                anchors.leftMargin: 6 * pt
                                anchors.rightMargin: 6 * pt
                                color: readOnly ? "#ACAAB5" : "#59556C"
                                font:  mainFont.dapFont.regular12
                                verticalAlignment: Qt.AlignVCenter
                                validator: RegExpValidator{ regExp: /\d+/ }
                                clip: true
                                readOnly:index > fromStringReadOnly ? true : false
                                text: token//readOnly ? "0" : ""

                            }

                            //Mark to input field
                            Text
                            {
                                id: textCurrency
                                anchors.right: parent.right
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                anchors.rightMargin: 6 * pt
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignRight
                                color: currTheme.textColor
                                font:  mainFont.dapFont.regular12
                                text: index === 0 ? currencyName : tokenName
                            }
                        }
                    }
                }
*/
                //Order Approval Button (Shell/Buy)
                DapButton
                {
//                            anchors.right: parent.right
//                            anchors.topMargin: 12 * pt
                    textButton: titleOrder
                    implicitWidth: 130 * pt
                    implicitHeight: 30 * pt
                    colorBackgroundNormal: "#3E3853"
                    colorBackgroundHover: "#3E3853"
                    horizontalAligmentText:Qt.AlignHCenter
                    borderColorButton: "#000000"
                    borderWidthButton: 0
                    fontButton.family:  mainFont.dapFont.regular12
                    fontButton.pixelSize: 13 * pt
                    colorTextButton: "#FFFFFF"

                    onClicked:
                    {
                        frameButton.visible = false;
                        modelInputFrame.append({"titleToken":"Fee (0.2%)","token":"10 800.47"});
                        modelInputFrame.append({"titleToken":"Total+Fee","token":"10 800.47"});
                    }
                }
            }
        }
    }
}

