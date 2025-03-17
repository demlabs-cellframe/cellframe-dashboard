import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2
import "qrc:/widgets"

Item {
    property alias label: label
    Layout.fillHeight: true
    Layout.fillWidth: true

    DapBigText
    {
        id: label
        anchors.fill: parent
        textColor: currTheme.white
        textElement.elide: Text.ElideCenter
        textFont: mainFont.dapFont.regular13
        fullText: price
    }
}
