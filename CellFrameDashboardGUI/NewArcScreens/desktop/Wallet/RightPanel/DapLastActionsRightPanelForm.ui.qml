import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import "qrc:/widgets"
import "../../../"

DapRightPanel
{

    dapHeaderData:
        Rectangle
    {
        color: "transparent"
        height: 38 * pt
        width: 348*pt


        Text
        {
            anchors.fill: parent
            anchors.leftMargin: 24 * pt
            text: qsTr("Last actions")
            verticalAlignment: Qt.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            font: _dapQuicksandFonts.dapFont.bold14
            color: currTheme.textColor

        }

        //            Rectangle
        //            {
        //                id: borderBottom
        //                anchors.bottom: parent.bottom
        //                anchors.left: parent.left
        //                anchors.right: parent.right
        //                height: 1 * pt
        //                color: "#757184"
        //            }
    }

    dapContentItemData:
        ScrollView {
        id: lastActionsList
        clip: true
        anchors.fill: parent
        anchors.bottomMargin: 10
        anchors.leftMargin: 5
        anchors.rightMargin: 5
//        ScrollBar.vertical.policy: ScrollBar.AlwaysOn


        Column {
            Repeater {
                model: 5 // Ammount of days in history
                delegate: ListView {
                    id: actionsListView
                    interactive: false
                    width: lastActionsList.width
                    height: ((50 * pt) * modelLastActions.count) + (35 * pt)
                    model: modelLastActions

                    section.property: "date"
                    section.criteria: ViewSection.FullString
                    section.delegate: delegateSection

                    delegate: Rectangle {
                        width: actionsListView.width
                        color: currTheme.backgroundElements
                        height: 50 * pt

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
                                    color: currTheme.textColor
                                    font: dapMainFonts.dapFont.dapFontRobotoRegular14
                                    elide: Text.ElideRight
                                }

                                Text
                                {
                                    Layout.fillWidth: true
                                    text: status
                                    color: currTheme.textColor
                                    font: dapMainFonts.dapFont.dapFontRobotoRegular12
                                }
                            }

                            Text
                            {
                                property string sign: (status === "Sent") ? "- " : "+ "
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                horizontalAlignment: Qt.AlignRight
                                verticalAlignment: Qt.AlignVCenter
                                color: currTheme.textColor
                                text: sign + amount + " " + name
                                font: dapMainFonts.dapFont.dapFontRobotoRegular14
                            }
                        }

                        Rectangle
                        {
                            width: parent.width
                            height: 1 * pt
                            color: currTheme.lineSeparatorColor
                            anchors.bottom: parent.bottom
                        }
                    }
                }
            }
        }
    }

        //        DapScrollView
        //        {
        //            id: scrollButtons
        //            viewData: lastActionsView

        //            scrollDownButtonImageSource: "qrc:/resources/icons/ic_scroll-down.png"
        //            scrollDownButtonHoveredImageSource: "qrc:/resources/icons/ic_scroll-down_hover.png"
        //            scrollUpButtonImageSource: "qrc:/resources/icons/ic_scroll-up.png"
        //            scrollUpButtonHoveredImageSource: "qrc:/resources/icons/ic_scroll-up_hover.png"
        //        }

}


