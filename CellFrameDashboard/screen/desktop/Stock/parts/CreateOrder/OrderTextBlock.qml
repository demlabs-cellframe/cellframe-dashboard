import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "qrc:/widgets"

Rectangle
{
    property alias textValue: textValue.text
    property alias textToken: textToken.text
    property alias textElement: textValue
//    property real realValue: 0.0
    property string placeholderText: textValue.placeholderText

    border.color: currTheme.input
    color: "transparent"
    radius: 4

    signal edited()

//    onRealValueChanged:
//    {
//        if (!enabled)
//        {
//            textValue.text = realValue.toFixed(roundPower)
//            if (textValue.text === (0.0).toFixed(roundPower))
//                textValue.text = "0.0"

//            print("onRealValueChanged",
//                  "textValue.text", textValue.text,
//                  "realValue", realValue)
//        }
//    }

    RowLayout
    {
        anchors.fill: parent
        spacing: 0

        DapTextField {
            property bool isInputText: true
            id: textValue
            Layout.fillWidth: true
            Layout.fillHeight: true
            horizontalAlignment: Text.AlignLeft
            selectByMouse: true
            validator: RegExpValidator { regExp: /[0-9]*\.?[0-9]{0,18}/}

            placeholderText: "0.0"
            textColor: parent.enabled? currTheme.white: currTheme.gray
            font: mainFont.dapFont.regular16
            text: ""

            backgroundColor: "transparent"

            onTextChanged:
            {
                if (enabled)
                {
//                    realValue = parseFloat(text)
//                    print("onTextChanged",
//                          "textValue.text", textValue.text,
//                          "realValue", realValue)

                    if(isInputText)
                        edited()
                    else
                        isInputText = true
                }
            }

            onFocusChanged:
            {
                textValue.cursorPosition = 0
            }

            function setText(text)
            {
                isInputText = false
                textValue.text = text
            }
        }

        Text
        {
            id: textToken
            Layout.fillHeight: true
            Layout.rightMargin: 10
            verticalAlignment: Qt.AlignVCenter
            color: parent.enabled? currTheme.white: currTheme.gray
            font: mainFont.dapFont.regular16
        }
    }
}
