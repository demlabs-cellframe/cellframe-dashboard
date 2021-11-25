import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1

Dialog {

    id: dialog
    property alias source:loader.source

    width: 650
    height: 600
    contentItem: Loader{
        id: loader
        anchors.fill: parent
    }
}

