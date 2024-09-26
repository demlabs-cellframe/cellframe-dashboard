import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3

ColumnLayout {

    property alias value: value.text
    property alias name: name.text

    Layout.preferredHeight: 81
    Layout.preferredWidth: 151

    spacing: 6

    Text{
        Layout.topMargin: 16
        Layout.alignment: Qt.AlignHCenter
        id: value
        color: currTheme.white;
        font: mainFont.dapFont.medium20
        horizontalAlignment: Text.AlignHCenter
    }

    Text{
        Layout.bottomMargin: 17
        Layout.alignment: Qt.AlignHCenter
        id: name
        color: currTheme.gray
        font: mainFont.dapFont.regular14
        horizontalAlignment: Text.AlignHCenter
    }
}
