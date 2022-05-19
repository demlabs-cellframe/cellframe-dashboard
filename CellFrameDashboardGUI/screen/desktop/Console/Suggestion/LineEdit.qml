import QtQuick 2.0
import QtQuick.Controls 2.5

FocusScope {
    // --- properties
    property color borderColor: "black"
    property color borderColorFocused: "steelblue"
    property int borderWidth: 1
    property bool hasClearButton: true
    property alias textInput: textInputComponent
    property alias text: textInputComponent.text
    signal enterPressed()
    signal sugTextChanged(var text)
    signal upButtonPressed()
    signal downButtonPressed()

    // --- signals
    //signal accepted


    id: focusScope

    TextField {
        id: textInputComponent
        width: parent.width
        height: parent.height
        focus: true
        selectByMouse: true
        color: currTheme.textColor
        font: mainFont.dapFont.regular18
        validator: RegExpValidator { regExp: /[0-9A-Za-z\-\_\:\.\(\)\?\s*]+/ }
        placeholderText: qsTr("Type here...")
        background: Rectangle
        {
            color: currTheme.backgroundElements
        }

        Keys.onUpPressed:
        {
            upButtonPressed()
        }

        Keys.onDownPressed:
        {
            downButtonPressed()
        }

        Keys.onPressed:
        {
            if (event.key == 16777220)
                enterPressed()
        }

        onTextChanged:
        {
            sugTextChanged(text)
        }
    }
}
