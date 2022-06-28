import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "qrc:/widgets"

Rectangle
{
    property alias textValue: textValue.text
    property alias textToken: textToken.text
    property string placeholderText: textValue.placeholderText

    border.color: currTheme.borderColor
    color: "transparent"
    radius: 4

    RowLayout
    {
        anchors.fill: parent
        spacing: 0

        TextField {
            id: textValue
            Layout.fillWidth: true
            Layout.fillHeight: true
            horizontalAlignment: Text.AlignLeft
            selectByMouse: true
            validator: RegExpValidator { regExp: /[0-9]*\.?[0-9]{0,18}/ }

            placeholderText: qsTr("0.0")
            color: parent.enabled? currTheme.textColor: currTheme.textColorGray
            font: mainFont.dapFont.regular16

            background: Rectangle{color:"transparent"}
        }

        Text
        {
            id: textToken
            Layout.fillHeight: true
            Layout.rightMargin: 10
            verticalAlignment: Qt.AlignVCenter
            color: parent.enabled? currTheme.textColor: currTheme.textColorGray
            font: mainFont.dapFont.regular16
        }
    }
}
