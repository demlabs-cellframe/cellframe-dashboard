import QtQuick 2.0
import QtQuick.Controls 2.5

FocusScope {
    // --- properties
    property color borderColor: "black"
    property color borderColorFocused: "steelblue"
    property int borderWidth: 1
    property bool hasClearButton: true
    property alias textInput: textInputComponent
    signal enterPressed()

    // --- signals
    signal accepted


    id: focusScope

    MouseArea {
        anchors.fill: parent
        onClicked: { focusScope.focus = true; textInput.openSoftwareInputPanel(); }
    }

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

        onEditingFinished:
        {
            enterPressed()
        }
    }


    states: State {
        name: "hasText"; when: textInput.text != ''
        PropertyChanges { target: hintComponent; opacity: 0 }
        PropertyChanges { target: clearButtonComponent; opacity: 1 }
    }

    transitions: [

        Transition {
            from: "hasText"; to: ""
            NumberAnimation { properties: "opacity" }
        }
    ]
}
