import QtQuick 2.4
import QtQuick.Controls 2.13

Rectangle {
    property alias header  : stackViewHeader
    property alias content : stackViewContent
    property int headerHeight: 36 * pt

    width: visible ? 400 * pt : 0
    color: "#E3E2E6"

    Rectangle {
        anchors.fill: parent
        anchors.leftMargin: 1
        color: "#F8F7FA"

        Column {
            anchors.fill: parent

            Item {
                id: headerItem
                width: parent.width
                height: headerHeight;

                StackView {
                    id: stackViewHeader
                    anchors.fill: parent
                }

//                Loader {
//                    anchors.fill: parent
//                    sourceComponent: header
//                }
            }


            Item {
                width: parent.width
                height: parent.height - headerHeight

                StackView {
                    id: stackViewContent
                    anchors.fill: parent
                }

//                Loader {
//                    anchors.fill: parent
//                    sourceComponent: content
//                }
            }
        }
    }
}
