import QtQuick 2.4
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../../../"

DapAbstractRightPanel
{
    dapHeaderData:
        Rectangle
        {
            anchors.fill: parent
            color: "transparent"

            Text
            {
                anchors.fill: parent
                anchors.leftMargin: 16 * pt
                text: qsTr("Last actions")
                verticalAlignment: Qt.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                font.family: "Roboto"
                font.styleName: "Normal"
                font.weight: Font.Normal
                font.pixelSize: 12 * pt
                color: "#3E3853"
            }

            Rectangle
            {
                id: borderBottom
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: 1 * pt
                color: "#757184"
            }
        }

    dapContentItemData:
        ListView
        {
            id: lastActionsView
            anchors.fill: parent
            clip: true
            model: modelLastActions
            delegate:
                Rectangle
                {
                    id: dapContentDelegate
                    width: parent.width
                    height: 50 * pt
                    color: "transparent"

                    RowLayout
                    {
                        anchors.fill: parent
                        anchors.rightMargin: 20 * pt
                        anchors.leftMargin: 16 * pt

                        ColumnLayout
                        {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            spacing: 2 * pt

                            Text
                            {
                                Layout.fillWidth: true
                                text: name
                                color: "#3E3853"
                                font.family: "Roboto"
                                font.styleName: "Normal"
                                font.weight: Font.Normal
                                font.pixelSize: 14 * pt
                                elide: Text.ElideRight
                            }

                            Text
                            {
                                Layout.fillWidth: true
                                text: status
                                color: "#757184"
                                font.family: "Roboto"
                                font.styleName: "Normal"
                                font.weight: Font.Normal
                                font.pixelSize: 12 * pt
                            }
                        }

                        Text
                        {
                            property string sign: (status === "Sent") ? "- " : "+ "
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            horizontalAlignment: Qt.AlignRight
                            verticalAlignment: Qt.AlignVCenter
                            color: "#3E3853"
                            text: sign + amount + " " + name
                            font.family: "Roboto"
                            font.styleName: "Normal"
                            font.weight: Font.Normal
                            font.pixelSize: 14 * pt
                        }
                    }

                    Rectangle
                    {
                        width: parent.width
                        height: 1 * pt
                        color: "#E3E2E6"
                        anchors.bottom: parent.bottom
                    }
                }

            section.property: "date"
            section.criteria: ViewSection.FullString
            section.delegate: delegateSection

            DapScrollView
            {
                id: scrollButtons
                viewData: lastActionsView

                scrollDownButtonImageSource: "qrc:/res/icons/ic_scroll-down.png"
                scrollDownButtonHoveredImageSource: "qrc:/res/icons/ic_scroll-down_hover.png"
                scrollUpButtonImageSource: "qrc:/res/icons/ic_scroll-up.png"
                scrollUpButtonHoveredImageSource: "qrc:/res/icons/ic_scroll-up_hover.png"
            }
        }
}


