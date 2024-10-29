import QtQuick 2.0

Item {
    property alias dynamicText: dynamicText_
    property alias staticText: staticText_
    signal textChangedSign()

    Text {
        id: staticText_
        anchors.verticalCenter: parent.verticalCenter
        font: mainFont.dapFont.medium12
        color: currTheme.white
    }
    Text {
        id:dynamicText_
        anchors.left: staticText_.right
        anchors.verticalCenter: parent.verticalCenter
        font: mainFont.dapFont.regular12
        color: currTheme.white
        onTextChanged: textChangedSign()
    }
}
