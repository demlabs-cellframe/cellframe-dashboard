import QtQuick 2.9
import QtQuick.Controls 2.12
import VpnOrdersModel 1.0
import QtGraphicalEffects 1.0

import "qrc:/widgets"
Rectangle {
    id: root
    color: "transparent"    

    Rectangle {
        id: listViewBorder
        clip: true
        x: (root.width - width) / 2 * pt
        y: 24 * pt
        height: root.height - y - 24 * pt
        width: 344 * pt
        border.color: "#E2E1E6"
        border.width: 1 * pt
        radius: 10 * pt
        color: "transparent"

        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Item {
                width:  listViewBorder.width
                height: listViewBorder.height
                Rectangle {
                    anchors.centerIn: parent
                    width:  listViewBorder.width
                    height: listViewBorder.height
                    radius: listViewBorder.radius
                }
            }
        }

        Rectangle {
            id: header
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 3

            height: 35 * pt

            Text {
                id: vpnOrdersTitleText
                x: 15 - parent.anchors.margins * pt
                height: parent.height
                verticalAlignment: Text.AlignVCenter
                font: quicksandFonts.bold14
                color: "#3E3853"
                text: qsTr("VPN orders")
            }
            Label {
                id: sortByText
                text: qsTr("Sort by ")
                x: 200
                anchors.verticalCenter: parent.verticalCenter
                font: quicksandFonts.regular14
                color: "#3E3853"
            }
            Rectangle {
                id: sortTypeComboBoxFrame
                anchors.left: sortByText.right
                anchors.verticalCenter: parent.verticalCenter
                width: 80 * pt
                color: "transparent"

                //  It is advisable to use the C ++ model
                ListModel
                {
                    id: sortTypeModel
                    ListElement { name: "region"; /*sortType: VpnOrdersModel.SortByRegion*/}
                    ListElement { name: "token"; /*sortType: VpnOrdersModel.SortByRegion*/}
                }

                DapComboBox
                {
                    id: sortTypeComboBox
                    model: sortTypeModel
                    currentIndex: 0
                    widthPopupComboBoxNormal: 70
                    widthPopupComboBoxActive: 112
                    // Combobox popup element position is depend on height of element
                    // If we use height from maket, popup element will be lower than neccessary
                    heightComboBoxNormal: 18
                    heightComboBoxActive: 37/*94*/

                    comboBoxTextRole: ["name"]
                    indicatorImageNormal: "qrc:/resources/icons/ic_arrow_drop_down_dark_blue.png"

                    sidePaddingNormal: 0 * pt
                    sidePaddingActive: 19 * pt
                    bottomIntervalListElement: 10 * pt
                    paddingTopItemDelegate: 12 * pt
                    heightListElement: 42 * pt

                    indicatorWidth: 20 * pt
                    indicatorHeight: indicatorWidth
                    indicatorLeftInterval: 0 * pt

                    normalColorText: "#3E3853"
                    hilightColorText: "#FFFFFF"
                    normalColorTopText: "#3E3853"
                    hilightColorTopText: "#3E3853"
                    hilightColor: "#D51F5D"
                    normalTopColor: "transparent"
                    normalColor: "#FFFFFF"
                    topEffect: false
                    hilightTopColor: normalColor
                    x: popup.visible ? (parent.width + 10 - widthPopupComboBoxActive): 0

                    colorTopNormalDropShadow: "#00000000"
                    colorDropShadow: "#40ABABAB"
                    fontComboBox: [quicksandFonts.regular14, quicksandFonts.medium14]
                    colorMainTextComboBox: [["#3E3853", "#070023"]]
                    colorTextComboBox: [["#070023", "#FFFFFF"]]
                    onCurrentIndexChanged:
                    {
                        // I would like to register the equalization of the sorting type from the model as with the name of the sorting, but DapComboBox does not have a handler for this case
                        if (currentText == "region")
                        {
                            listView.model.sortType = VpnOrdersModel.SortByRegion
                        }
                        else if (currentText == "token")
                        {
                            listView.model.sortType = VpnOrdersModel.SortByToken
                        }
                    }

                }
            }
        }

        OrdersListView {
            id: listView
            model: VpnOrdersModel
            anchors.top: header.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 2
            Component.onCompleted: sortTypeComboBox.currentIndexChanged()
        }
    }
}
