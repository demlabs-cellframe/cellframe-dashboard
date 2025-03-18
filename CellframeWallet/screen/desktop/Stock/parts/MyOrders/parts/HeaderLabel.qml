import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2

Item {
    property alias label: label
    Layout.fillHeight: true
    Layout.fillWidth: true
    Text
    {
        id: label
        anchors.fill: parent
        verticalAlignment: Qt.AlignVCenter
        font:  mainFont.dapFont.medium12
        color: currTheme.white
    }
}
