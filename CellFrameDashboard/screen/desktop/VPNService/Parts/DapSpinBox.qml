import QtQuick 2.7
import QtQuick.Controls 2.2

SpinBox {
    id: control

    padding: 4 
    font:  mainFont.dapFont.medium16
    editable: true
    inputMethodHints: Qt.ImhFormattedNumbersOnly

    validator: IntValidator {
        locale: control.locale.name
        top: control.to
        bottom: control.from
    }

    contentItem: TextInput {
        text: control.textFromValue(control.value, control.locale)

        font: control.font
        color: currTheme.white
        horizontalAlignment: Qt.AlignRight
        verticalAlignment: Qt.AlignVCenter

        readOnly: !control.editable
        validator: control.validator
        inputMethodHints: control.inputMethodHints
        selectByMouse: true
    }

    up.indicator: null
    down.indicator: null

    background: Rectangle {
        implicitWidth: 140 
        color:"transparent"
        border.width: pt
        border.color: "#B4B1BD"
        radius: 4 
    }

}
