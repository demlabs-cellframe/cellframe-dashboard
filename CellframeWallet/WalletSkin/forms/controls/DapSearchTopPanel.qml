import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import "qrc:/widgets"
//import "parts"



DapTopPanel {
    id: root
    property bool isVisibleSearch: true

    signal findHandler(string text)

    Item{
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: 36
        anchors.topMargin: 15
        anchors.bottomMargin: 15

        width: 224

//        color: "transparent"
//        border.color: "green"
//        border.width: 1

        RowLayout{
            id: rowLay
            anchors.fill: parent
            spacing: 10
            height: 24

            // Frame icon search
            DapImageRender
            {
                visible: isVisibleSearch
                id: frameIconSearch

                height: 20
                width: 20
        //        fillMode: Image.PreserveAspectFit
                verticalAlignment: Image.AlignVCenter
                horizontalAlignment: Image.AlignHCenter

                source: "qrc:/walletSkin/Resources/"+ pathTheme +"/icons/other/search.svg"
            }

            SearchInputBox {
                visible: isVisibleSearch
                id: searchBox

                bottomLineVisible: false
                validator: RegExpValidator { regExp:  /[0-9A-Za-z\-\_\:\.\,\(\)\?\@\s*]+/ }

                placeholderText: qsTr("Search")
                height: 30

                placeholderColor: "#757184"
                font: mainFont.dapFont.regular16

                onEditingFinished: {
                    filtering.clear()
                    root.findHandler(text)
                }

                filtering.waitInputInterval: 100
                filtering.minimumSymbol: 0
                filtering.onAwaitingFinished: {
                    root.findHandler(text)
                }
            }

            Item{Layout.fillWidth: true}
        }


        Rectangle {
            visible: isVisibleSearch
            height: 1
            anchors.top: rowLay.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: 2
            color: "#393B41" //currTheme.borderColor
        }
    }




//    //right Rectangle
//    Rectangle {
//        visible: isVisibleSearch
////        color: parent.color
//        height: parent.height
//        width: parent.radius
//        x: parent.width - width
//    }


}  //root

