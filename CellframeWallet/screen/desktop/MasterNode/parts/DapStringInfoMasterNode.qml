import QtQuick 2.4

Item {
    property alias key: keyText.text
    property alias value: valueText.text
    height: Math.max(keyText.contentHeight, keyText.contentHeight)

    Text
    {
        id: keyText
        width: 140
        anchors.left: parent.left
        anchors.top: parent.top
        font: mainFont.dapFont.regular14
        color: currTheme.gray
        text: displayKey
        wrapMode: Text.WordWrap
    }

    Text
    {
        id: valueText
        anchors.left: keyText.right
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: textMargins
        font: mainFont.dapFont.regular14
        color: currTheme.white
        text: nodeMasterModule.validatorData[key]
        wrapMode: Text.Wrap
    }
}
