import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "qrc:/widgets"

DapTextField {
    property bool isInputText: true
    signal edited()

    id: textValue

    onTextChanged:
    {
        if (enabled)
        {
            if(isInputText)
                edited()

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
