import QtQuick 2.4
import QtQuick.Controls 1.4
import "qrc:/"
import "../"
import "../RightPanel"



Item
{
    id: tab
    Column
    {
        anchors.fill: parent

        DapWalletTopPanel
        {
            id: topPanel
        }

        Item {
            height: parent.height - topPanel.height
            width: parent.width

            DapTokensListView
            {
                anchors.margins: 24*pt
                anchors.right: rightPanel.left
            }
            DapRightPanel_New
            {
                id: rightPanel
                initialPage: firstPageComponent
            }
            Component
            {
                id: firstPageComponent

                DapRightPanelPage {
                    id: firstPage

                    caption: qsTr("First page");

                    Rectangle {
                        anchors.fill: parent
                        color: "red"
                        opacity: 0.1
                    }

                    Column {
                        id: column1

                        Rectangle {
                            width: firstPage.width
                            height: pt * 100
                            color: "#ff0000"
                        }

                        Button {
                            text: "Next panel"
                            onClicked: firstPage.pushPageRequest(secondPageComponent)
                        }
                    }
                }
            }
            Component {
                id: secondPageComponent

                DapRightPanelPage {
                    id: secondPage

                    // Нужно установить implicitHeight для работы скролла. Не очень красиво получилось.
                    implicitHeight: column2.height

                    caption: qsTr("Second page");

                    headerComponent: DapRightPanelComboBoxHeader {
                        caption: secondPage.caption

                        comboBox.comboBoxTextRole: ["text"]
                        comboBox.model: ListModel {
                            ListElement { text: "asd" }
                            ListElement { text: "asd1" }
                            ListElement { text: "asd2" }
                        }

                        Rectangle {
                            color: "green"
                            opacity: 0.1
                            anchors.fill: parent
                        }
                    }

                    Column {
                        id: column2

                        Repeater {
                            model: 40

                            Text {
                                id: text

                                text: qsTr("Second page")
                                font.pixelSize: pt * 25
                            }
                        }
                    }
                }
            }
        }
    }
}
