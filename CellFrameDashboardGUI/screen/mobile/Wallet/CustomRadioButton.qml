import QtQuick 2.12
import QtQuick.Controls 2.12

RadioButton {
    id: control

    indicator: Item {
    }

    contentItem: Text {
        text: control.text
//        opacity: enabled ? 1.0 : 0.3
        color: control.checked ? "#ffffff" : "#ACABB3"
        font: _dapQuicksandFonts.dapFont.medium18
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }
}
