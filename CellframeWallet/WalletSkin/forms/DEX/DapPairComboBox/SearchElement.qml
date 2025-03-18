import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.12
import QtQml 2.12
import "qrc:/widgets"
import "../../controls"


ColumnLayout
{
    signal findHandler(string text)

    id: root
    spacing: 0

    RowLayout {

        spacing: 0
        // Frame icon search
        Image
        {
            Layout.leftMargin: 16
            Layout.topMargin: 8
            id: frameIconSearch
            source: "icons/searchIcon.svg"
            mipmap: true
        }

        DapWalletTextField {
            id: searchBox
            property int spacing: 10

            Layout.leftMargin: 11
            Layout.topMargin: 8

            validator: RegExpValidator { regExp:  /[0-9A-Za-z\-\_\:\.\,\(\)\?\@\\\/\s*]+/ }

            placeholderText: qsTr("Search")
            height: 28
            font: mainFont.dapFont.regular14
            placeholderColor: currTheme.gray
            selectByMouse: true

            Connections{
                target: logic
                onAwaitingFinished: root.findHandler(text)
            }

            onTextChanged: logic.filter(text)

            //for mobile input
            onDisplayTextChanged: logic.filter(text)

            onEditingFinished: {
                logic.clear()
                root.findHandler(text)
            }
        }
    }

    //separator
    Rectangle{
        Layout.fillWidth: true
        Layout.leftMargin: 16
        Layout.rightMargin: 16
        height: 1
        color: "#757184"
    }
}

