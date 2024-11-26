import QtQuick 2.7
import QtQuick.Controls 2.2

Control {
    id: control

    property int decimals: 2
    property double from: 0.0
    property double to: 100.0
    property double value: 0.0
    property int inputMethodHints: Qt.ImhFormattedNumbersOnly

    property var validator: DoubleValidator {
        locale: control.locale.name
        bottom: control.from
        top: control.to
        decimals: control.decimals
        notation: DoubleValidator.StandardNotation
    }

    property var textFromValue: function(value, locale) { return Number(value).toLocaleString(locale, 'f', control.decimals) }
    property var valueFromText: function(text, locale) { return Number.fromLocaleString(locale, text) }

    padding: 4 
    font:  mainFont.dapFont.medium16

    contentItem: TextInput {
        text: control.textFromValue(control.value, control.locale)

        font: control.font
        color: currTheme.white
        horizontalAlignment: Qt.AlignRight
        verticalAlignment: Qt.AlignVCenter

        validator: control.validator
        inputMethodHints: control.inputMethodHints
        selectByMouse: true

        onEditingFinished: control.value = control.valueFromText(text, control.locale)
    }

    background: Rectangle {
        implicitWidth: 140 
        color:"transparent"
        border.width: pt
        border.color: "#B4B1BD"
        radius: 4 
    }
}
