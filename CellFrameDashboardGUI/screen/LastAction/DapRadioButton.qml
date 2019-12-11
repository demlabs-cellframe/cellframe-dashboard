import QtQuick 2.0
import QtQuick.Controls 2.0

RadioButton {
    property alias textButton: nameButton.text
    property string colorName: nameButton.color

    id: button
    text: qsTr("template")
    contentItem: Text {
        id: nameButton
        anchors.left: parent.left
        anchors.leftMargin: button.indicator.width + button.spacing
        verticalAlignment: Text.AlignVCenter
        anchors.verticalCenter: parent.verticalCenter
        color: "#3E3853"
        font.pointSize: 14 * pt
        font.wordSpacing: 0
        font.family: "Roboto"
        horizontalAlignment: Text.AlignLeft
    }

    spacing: 16
    checked: false
    display: AbstractButton.TextBesideIcon
    autoExclusive: true
}


/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
