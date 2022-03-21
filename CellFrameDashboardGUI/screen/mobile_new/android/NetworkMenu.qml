import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "qrc:/resources/QML"
import "qrc:/widgets"

Drawer {
    id: drawer
    edge: Qt.RightEdge

    background: Rectangle {
        color: currTheme.backgroundElements
        radius: 30
        Rectangle {
            width: 30
            height: 30
            anchors.top: parent.top
            anchors.right: parent.right
            color: currTheme.backgroundElements
        }
        Rectangle {
            width: 30
            height: 30
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            color: currTheme.backgroundElements
        }
        Rectangle {
            width: 30
            height: 30
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            color: currTheme.backgroundElements
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 47 * pt

            RowLayout
            {
                anchors.fill: parent
                anchors.rightMargin: 10 * pt
                Item {
                    Layout.fillWidth: true
                }


                Text {
                    Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
                    Layout.rightMargin: 100 * pt
                    text: qsTr("Networks")
                    color: currTheme.textColor
                    font: _dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium18
                }
                Image {
                    smooth: true
                    Layout.maximumWidth: 30 * pt
                    Layout.maximumHeight: 30 * pt
                    fillMode: Image.PreserveAspectFit
                    source: "Icons/NetIconLightGreen.png"
                }

/*                DapImageLoader {
                    Layout.alignment: Qt.AlignVCenter
                    innerWidth: 30 * pt
                    innerHeight: 30 * pt
//                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/mobile/Icons/NetIconLightGreen.png"
                }*/

            }

            MouseArea {
                anchors.fill: parent
                onClicked:
                    drawer.close()
            }

        }

        Rectangle {
            implicitHeight: 1
            Layout.fillWidth: true
            Layout.leftMargin: 36
            color: "#4f4f4f"
        }

        ListView {
            id: mainButtonsList
            Layout.fillHeight: true
            Layout.fillWidth: true
            clip: true
            spacing: 20 * pt
            model: mainNetworkModel
            delegate:NetworkDelegate{}
        }
    }

/*    property var mainNetworksModel: [
        {
            "icon": "qrc:/mobile/Icons/indicator_online.png",
            "nameNet": qsTr("CELLNET"),
            "stateNet": "ONLINE",
            "targetState" : "ONLINE",
            "activeLinks" : "2 from 3",
            "addressNet" : "N2CA::00FQ::KJB4::875G"

        },
        {
            "icon": "qrc:/mobile/Icons/indicator_online.png",
            "nameNet": qsTr("MAINNET"),
            "stateNet": "ONLINE",
            "targetState" : "ONLINE",
            "activeLinks" : "1 from 2",
            "addressNet" : "875G::N2CA::KJB4::875G"
        },
        {
            "icon": "qrc:/resources/icons/" + pathTheme + "/indicator_offline.png",
            "nameNet": qsTr("KELTEST"),
            "stateNet": "DISCONNECTING",
            "targetState" : "OFFLINE",
            "activeLinks" : "0 from 3",
            "addressNet" : "KJB4::875G::N2CA::00FQ"
        },
        {
            "icon": "qrc:/resources/icons/" + pathTheme + "/indicator_error.png",
            "nameNet": qsTr("KELMAINNET"),
            "stateNet": "OFFLINE",
            "targetState" : "OFFLINE",
            "activeLinks" : "1 from 3",
            "addressNet" : "1128::00FQ::N2CA::N2CA"
        }
    ]*/

//    ScrollView {
//        anchors.fill: parent

//        Column {
//            id: column
//            anchors.fill: parent

//            ItemDelegate {
//                id: headerDelegate
//                text: qsTr("Networks")
//                icon.source: "qrc:/mobile/Icons/NetIconLight.png"
//                width: column.width

//                contentItem:
//                    RowLayout {
//                        anchors.fill: parent
//                        anchors.leftMargin: 15
//                        anchors.rightMargin: 10

//                        Text {
//                            Layout.fillWidth: true
//                            text: headerDelegate.text
//                            font: headerDelegate.font
//                        }
//                        Image {
//                            source: headerDelegate.icon.source
//                            Layout.preferredWidth: 25
//                            Layout.preferredHeight: 25
//                        }
//                    }
//            }

//            NetworkDelegate
//            {
//                width: column.width
//            }

//            NetworkDelegate
//            {
//                width: column.width
//            }

//            NetworkDelegate
//            {
//                width: column.width
//            }

//            NetworkDelegate
//            {
//                width: column.width
//            }

//            NetworkDelegate
//            {
//                width: column.width
//            }

//            NetworkDelegate
//            {
//                width: column.width
//            }
//        }
//    }

}
