import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "qrc:/widgets/"

Page {
    title: qsTr("TX Explorer")
    background: Rectangle {color: currTheme.backgroundMainScreen }

    ListView {
        id: historyView
        anchors.fill: parent
        anchors.topMargin: 10 * pt
        spacing: 5 * pt

        clip: true

        model: mainHistoryModel

        section.property: "date"
        section.criteria: ViewSection.FullString
        section.delegate: delegateSection

        ScrollBar.vertical: ScrollBar {
            active: true
        }

        delegate:
        Item {
            id: delegateItem
            width: historyView.width - 30 * pt
            height: 50 * pt
            anchors.margins: 0
            x: 15 * pt

            ColumnLayout {
                anchors.fill: parent
                anchors.leftMargin: 10 * pt
                anchors.rightMargin: 10 * pt

                RowLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Text {
                            Layout.fillHeight: true

                            verticalAlignment: Qt.AlignVCenter

                            text: network
                            font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium12
                            color: currTheme.textColor
                        }

                        Text {
                            Layout.fillHeight: true

                            verticalAlignment: Qt.AlignVCenter

                            text: status
                            font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium12
                            color: currTheme.textColorGray
                        }

                    }

                    Text {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        horizontalAlignment: Qt.AlignRight
                        verticalAlignment: Qt.AlignVCenter

                        text: amount + " " + token_name
                        font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium16
                        color: currTheme.textColor
                    }

                }


                Rectangle
                {
                    Layout.fillWidth: true
                    Layout.topMargin: 5 * pt
                    Layout.bottomMargin: 5 * pt
                    height: 1
                    color: "#6B6979"
                }
            }


        }
    }

    Component
    {
        id: delegateSection

        Item {
            id: header

            width: parent.width - 30 * pt
            height: 60 * pt
            x: 15 * pt

            Rectangle {
                id: itemRect

                anchors.fill: parent
                anchors.topMargin: 15 * pt
                anchors.bottomMargin: 15 * pt

                color: "#2D3037"
                radius: 10

                Text {
                    anchors.fill: parent
                    anchors.leftMargin: 10 * pt

                    horizontalAlignment: Qt.AlignLeft
                    verticalAlignment: Qt.AlignVCenter

                    text: section
                    font: dapQuicksandFonts.dapMainFontTheme.dapFontQuicksandMedium14
                    color: currTheme.textColor
                }
            }
            InnerShadow {
                id: light
                anchors.fill: itemRect
                radius: 1.0
                samples: 5
                cached: true
                horizontalOffset: -1
                verticalOffset: -1
                color: "#505050"
                source: itemRect
            }
            InnerShadow {
                anchors.fill: itemRect
                radius: 2.0
                samples: 5
                cached: true
                horizontalOffset: 2
                verticalOffset: 2
                color: "#202020"
                source: light
            }
        }
    }
}
