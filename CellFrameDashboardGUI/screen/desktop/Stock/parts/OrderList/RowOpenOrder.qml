import QtQuick 2.4
import QtQuick.Layouts 1.3

RowLayout
{
    property bool isHeader: true
    property bool isHistory: false

    Text
    {
        Layout.preferredWidth: layoutCoeff.get("date")
        color: currTheme.textColor
        font: isHeader? mainFont.dapFont.regular12 : mainFont.dapFont.regular13
        text: isHeader? qsTr("Date") : date
    }

    Text
    {
        Layout.preferredWidth: layoutCoeff.get("pair")
        color: currTheme.textColor
        font: isHeader? mainFont.dapFont.regular12 : mainFont.dapFont.regular13
        text: isHeader? qsTr("Pair") : pair
    }

    Text
    {
        Layout.preferredWidth: layoutCoeff.get("type")
        color: currTheme.textColor
        font: isHeader? mainFont.dapFont.regular12 : mainFont.dapFont.regular13
        text: isHeader? qsTr("Type") : type
    }

    Text
    {
        Layout.preferredWidth: layoutCoeff.get("side")
        color: isHeader? currTheme.textColor : side === "Sell" ? currTheme.textColorRed : currTheme.textColorGreen
        font: isHeader? mainFont.dapFont.regular12 : mainFont.dapFont.regular13
        text: isHeader? qsTr("Side") : side
    }

    Text
    {
        Layout.preferredWidth: layoutCoeff.get("price")
        color: currTheme.textColor
        font: isHeader? mainFont.dapFont.regular12 : mainFont.dapFont.regular13
        text: isHeader? qsTr("Price") : price
    }

    Text
    {
        Layout.preferredWidth: layoutCoeff.get("amount")
        color: currTheme.textColor
        font: isHeader? mainFont.dapFont.regular12 : mainFont.dapFont.regular13
        text: isHeader? qsTr("Amount") : amount
    }

    Text
    {
        Layout.preferredWidth: layoutCoeff.get("filled")
        color: currTheme.textColor
        font: isHeader? mainFont.dapFont.regular12 : mainFont.dapFont.regular13
        text: isHeader? qsTr("Filled") : filled
    }

    Text
    {
        Layout.preferredWidth: layoutCoeff.get("total")
        color: currTheme.textColor
        font: isHeader? mainFont.dapFont.regular12 : mainFont.dapFont.regular13
        text: isHeader? qsTr("Total") : total
    }

    Text
    {
        Layout.preferredWidth: layoutCoeff.get("triggerCondition")
        color: currTheme.textColor
        font: isHeader? mainFont.dapFont.regular12 : mainFont.dapFont.regular13
        text: isHeader? qsTr("Trigger condition") : triggerCondition
    }

    Text
    {
        Layout.preferredWidth: layoutCoeff.get("expiresIn")
        color: currTheme.textColor
        font: isHeader? mainFont.dapFont.regular12 : mainFont.dapFont.regular13
        text: isHeader? qsTr("Expires in") : expiresIn
    }

    Text
    {
        visible: !isHeader
        Layout.preferredWidth: layoutCoeff.get("cancel")
        color: currTheme.hilightColorComboBox
        font: isHeader? mainFont.dapFont.regular12 : mainFont.dapFont.regular13
        text: "Cancel"
    }

    Item
    {
        visible: isHeader
        Layout.preferredWidth: layoutCoeff.get("cancel")
    }

}
