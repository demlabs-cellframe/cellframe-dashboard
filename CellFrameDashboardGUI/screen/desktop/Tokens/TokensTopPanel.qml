import QtQuick 2.4
import QtQuick.Controls 2.0
import Demlabs 1.0
import "../../"
import "../controls" as Controls
import "qrc:/widgets" as Widgets


Controls.DapTopPanel
{
    //property alias dapNewPayment: newTokenButton

    Image
    {
        id: frameIconSearch
        anchors.left: parent.left
        anchors.leftMargin: 38 * pt
        y: 21 * pt
        height: 19 * pt
        width: 19 * pt
        fillMode: Image.PreserveAspectFit
        verticalAlignment: Image.AlignVCenter
        horizontalAlignment: Image.AlignHCenter

        source: "qrc:/resources/icons/ic_search.png"
    }

    Controls.SearchInputBox {
        id: searchBox
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: frameIconSearch.right
        anchors.leftMargin: 7 * pt

        bottomLineVisible: false
        validator: RegExpValidator { regExp:  /[0-9A-Za-z\-\_\:\.\,\(\)\?\@\s*]+/ }

        placeholderText: qsTr("Search")
        height: 28 * pt
        font: mainFont.dapFont.regular14
    }

    Rectangle {
        width: searchBox.width
        height: 1 * pt
        anchors.top: searchBox.bottom
        anchors.topMargin: 3 * pt
        anchors.left: frameIconSearch.left
        color: "#393B41"
    }

    Widgets.DapButton
    {
        id: newTokenButton
        textButton: "New Token"
        anchors.right: parent.right
        anchors.rightMargin: 24 * pt
        anchors.top: parent.top
        anchors.topMargin: 14 * pt
        anchors.verticalCenter: parent.verticalCenter
        implicitHeight: 38 * pt
        implicitWidth: 163 * pt
        fontButton: mainFont.dapFont.medium14
        horizontalAligmentText: Text.AlignHCenter
    }
}
