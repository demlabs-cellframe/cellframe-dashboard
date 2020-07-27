import QtQuick 2.9
import QtQuick.Controls 2.12
import "qrc:/widgets"
import QtGraphicalEffects 1.0

ListView
{
    id: root
    delegate: delegateComponent
    headerPositioning: ListView.OverlayHeader
    spacing: 13 * pt
    clip: true

    header: Item {
        width: parent.width
        height: 35 * pt
        z: 10

        Rectangle {
            id: vpnOrdersTitle
            width: parent.width
            height: 35 * pt

            Text {
                id: vpnOrdersTitleText
                x: 15 * pt
                height: parent.height
                verticalAlignment: Text.AlignVCenter
                font: quicksandFonts.bold14
                color: "#3E3853"
                text: qsTr("VPN orders")
            }
            Label {
                id: sortByText
                text: qsTr("Sort by ")
                anchors.left: vpnOrdersTitleText.right
                anchors.leftMargin: 123
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

                ListModel
                {
                    id: sortTypeModel
                    ListElement { name: "region" }
                    ListElement { name: "token" }
                }

                DapComboBox
                {
                    id: sortTypeComboBox
                    model: sortTypeModel
                    comboBoxTextRole: ["name"]
                    currentIndex: 0

                    widthPopupComboBoxNormal: 70
                    widthPopupComboBoxActive: 105 // Заменить
                    heightComboBoxNormal: 18
                    heightComboBoxActive: 47

                    indicatorImageNormal: "qrc:/resources/icons/ic_arrow_drop_down_dark_blue.png"
                    indicatorImageActive: "qrc:/resources/icons/ic_arrow_drop_up_dark_blue.png"
                    sidePaddingNormal: 0 * pt
                    sidePaddingActive: 20 * pt
                    bottomIntervalListElement: 0 * pt
                    paddingTopItemDelegate: 0 * pt
                    heightListElement: 35 * pt
                    indicatorWidth: 20 * pt
                    indicatorHeight: indicatorWidth

                    normalColorText: "#3E3853"
                    hilightColorText: "#FFFFFF"
                    normalColorTopText: "#3E3853"
                    hilightColorTopText: "#3E3853"
                    hilightColor: "#D51F5D"
                    normalTopColor: "transparent"
                    normalColor: "#FFFFFF"
                    hilightTopColor: normalColor
                    x: popup.visible ? sidePaddingActive * (-1) : 0
                    y: popup.visible ? 10 * (-1) : 0

                    colorTopNormalDropShadow: "#00000000"
                    colorDropShadow: "#40ABABAB"
                    fontComboBox: [quicksandFonts.regular14]
                    colorMainTextComboBox: [["#3E3853", "#070023"]]
                    colorTextComboBox: [["#070023", "#FFFFFF"]]

                    onCurrentTextChanged:
                    {
                        if (currentText == "region")
                        {
                            root.model.sortByRegion()
                        }
                        else if (currentText == "token")
                        {
                            root.model.sortByToken()
                        }
                    }

                }
            }
        }
    }

    Rectangle {
        id: scrollBar
        width: 5
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: root.headerItem.height
        anchors.bottom: parent.bottom
        color: "#E2E1E6"
        clip: true
        Rectangle
        {
            id: scrollIndicator
            width: 4
            height: 15
            radius: 2
            color: "#B0AEB9"

            y: (root.contentY + root.headerItem.height) * 0.81

        }
    }

    Component {
        id: delegateComponent
        Item {
            width: root.width - scrollIndicator.width
            height: (componentHeader.height + (headerMessageTitle.visible ? headerMessageTitle.height : 0) + unitsSection.height * 4) * pt

            Rectangle{
                id: componentHeader
                width: parent.width
                height: 30*pt
                color: "#3E3853"

                Text {
                    id: vpnOrdersTitleText
                    x: 15 * pt
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                    font: quicksandFonts.medium12
                    color: "#FFFFFF"
                    text: name
                }

                Rectangle
                {
                    id: headerSwitch

                    property bool status: false

                    width: 43 * pt
                    height: 20 * pt
                    anchors.verticalCenter: parent.verticalCenter
                    x: (parent.width - width - 5) * pt
                    color: "transparent"
                    border.color: headerSwitch.status ? "#FFFFFF" : "#757184"
                    border.width: 1 * pt
                    radius: 10 * pt

                    Rectangle
                    {
                        id: switchHandle
                        width: 14 * pt
                        height: 14 * pt
                        radius: width / 2
                        anchors.verticalCenter: parent.verticalCenter
                        color: headerSwitch.status ? "#FFFFFF" : "#757184"
                        x: 3
                        Behavior on x {NumberAnimation{duration: 150}}
                    }

                    MouseArea
                    {
                        id: headerSwitchArea
                        anchors.fill: parent
                        onClicked:
                        {
                            headerSwitch.status = !headerSwitch.status
                            switchHandle.x = !headerSwitch.status ? 3 : headerSwitch.width - switchHandle.width - 3
                        }
                    }

                }
            }
            Rectangle{
                id: headerMessageTitle
                anchors.top: componentHeader.bottom
                width: parent.width
                height: 20 * pt
                color: "#ECECEC"
                visible: unsafe || speedLimit >= 0
                Text {
                    id: unsafeMessageText
                    visible: unsafe
                    x: 15 * pt
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                    font: quicksandFonts.medium10
                    color: "#FF0000"
                    text: qsTr("Potentially unsafe connection for your personal data")
                }
                Text {
                    id: speedLimitMessageText
                    visible: !unsafe && speedLimit >= 0
                    x: 15 * pt
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                    font: quicksandFonts.medium10
                    color: "#79AD02"
                    text: qsTr("Promo with speed limit " + speedLimit + " Mb")
                }
            }
            Rectangle{
                id: unitsSection
                anchors.top: headerMessageTitle.visible ? headerMessageTitle.bottom : componentHeader.bottom
                width: root.width
                height: 30*pt
                color: "transparent"

                Text {
                    x: 15 * pt
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                    font: quicksandFonts.regular12
                    color: "#757184"
                    text: "Units"
                }

                Text {
                    x: (parent.width - width - 15) * pt
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                    font: quicksandFonts.regular12
                    color: "#211A3A"
                    text: units
                }
            }
            Rectangle{
                id: unitsTypeSection
                anchors.top: unitsSection.bottom
                width: root.width
                height: 30*pt
                color: "transparent"

                Text {
                    x: 15 * pt
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                    font: quicksandFonts.regular12
                    color: "#757184"
                    text: "Units Type"
                }

                Text {
                    x: (parent.width - width - 15) * pt
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                    font: quicksandFonts.regular12
                    color: "#211A3A"
                    text: unitsType
                }
            }
            Rectangle{
                id: valueSection
                anchors.top: unitsTypeSection.bottom
                width: root.width
                height: 30*pt
                color: "transparent"

                Text {
                    x: 15 * pt
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                    font: quicksandFonts.regular12
                    color: "#757184"
                    text: "Value"
                }

                Text {
                    x: (parent.width - width - 15) * pt
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                    font: quicksandFonts.regular12
                    color: "#211A3A"
                    text: value
                }
            }
            Rectangle{
                id: tokenSection
                anchors.top: valueSection.bottom
                width: root.width
                height: 30*pt
                color: "transparent"

                Text {
                    x: 15 * pt
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                    font: quicksandFonts.regular12
                    color: "#757184"
                    text: "Token"
                }

                Text {
                    x: (parent.width - width - 15) * pt
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                    font: quicksandFonts.regular12
                    color: "#211A3A"
                    text: token
                }
            }
        }
    }

}
