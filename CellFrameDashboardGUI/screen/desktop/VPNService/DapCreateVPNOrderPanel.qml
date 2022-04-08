import QtQuick 2.7
import QtQuick.Controls 2.2
import "qrc:/widgets"

Item {
    id: control

    signal orderCreated

    Column {

        DapRightPanelElement {
            width: control.width
            name: qsTr("Name")

            contentItem: TextField {
                id: textName

                implicitWidth: parent.width

                font:  mainFont.dapFont.medium16
                color: "#070023"
                selectByMouse: true
                placeholderText: qsTr("Tittle, only you can see")

                background: Item {
                    Rectangle {
                        y: parent.height - height
                        width: parent.width
                        height: pt
                        color: "#C7C6CE"
                    }
                }
            }
        }

        DapRightPanelElement {
            width: control.width
            name: qsTr("Region")

            contentItem: Item {
                implicitHeight: comboBoxRegion.heightComboBoxNormal
                implicitWidth: parent.width

                DapComboBox {
                    id: comboBoxRegion

                    comboBoxTextRole: ["region"]
                    anchors.centerIn: parent
                    indicatorImageNormal: "qrc:/resources/icons/ic_arrow_drop_down_dark.png"
                    indicatorImageActive: "qrc:/resources/icons/ic_arrow_drop_up.png"
                    sidePaddingNormal: 0 * pt
                    sidePaddingActive: 20 * pt
                    normalColorText: "#070023"
                    hilightColorText: "#FFFFFF"
                    normalColorTopText: "#070023"
                    hilightColorTopText: "#070023"
                    hilightColor: "#330F54"
                    normalTopColor: "transparent"
                    widthPopupComboBoxNormal: 278 * pt
                    widthPopupComboBoxActive: 318 * pt
                    heightComboBoxNormal: 24 * pt
                    heightComboBoxActive: 44 * pt
                    bottomIntervalListElement: 8 * pt
                    topEffect: false
                    normalColor: "#FFFFFF"
                    hilightTopColor: normalColor
                    paddingTopItemDelegate: 8 * pt
                    heightListElement: 32 * pt
                    intervalListElement: 10 * pt
                    indicatorWidth: 20 * pt
                    indicatorHeight: indicatorWidth
                    indicatorLeftInterval: 20 * pt
                    colorTopNormalDropShadow: "#00000000"
                    colorDropShadow: "#40ABABAB"
                    fontComboBox: [ mainFont.dapFont.medium18]
                    colorMainTextComboBox: [["#070023", "#070023"]]
                    colorTextComboBox: [["#070023", "#FFFFFF"]]

                    // TODO откуда брать список регионов
                    model: ListModel {
                        ListElement { region: qsTr("Europe, France") }
                        ListElement { region: qsTr("123123") }
                        ListElement { region: qsTr("123123123") }
                    }
                }
            }
        }

        DapRightPanelElement {
            width: control.width
            name: qsTr("Units")

            contentItem: Item {
                implicitWidth: parent.width
                implicitHeight: Math.max(spinBoxUnit.implicitHeight, comboBoxUnit.heightComboBoxNormal)

                DapSpinBox {
                    id: spinBoxUnit

                    anchors.verticalCenter: parent.verticalCenter
                    height: Math.min(implicitHeight, parent.height)
                    from: 0
                    to: 2147483647
                }

                Item {
                    anchors.right: parent.right
                    width: comboBoxUnit.widthPopupComboBoxNormal
                    height: parent.height

                    DapComboBox {
                        id: comboBoxUnit

                        comboBoxTextRole: ["unit"]
                        anchors.centerIn: parent
                        indicatorImageNormal: "qrc:/resources/icons/ic_arrow_drop_down_dark.png"
                        indicatorImageActive: "qrc:/resources/icons/ic_arrow_drop_up.png"
                        sidePaddingNormal: 0 * pt
                        sidePaddingActive: 20 * pt
                        normalColorText: "#070023"
                        hilightColorText: "#FFFFFF"
                        normalColorTopText: "#070023"
                        hilightColorTopText: "#070023"
                        hilightColor: "#330F54"
                        normalTopColor: "transparent"
                        widthPopupComboBoxNormal: 94 * pt
                        widthPopupComboBoxActive: 134 * pt
                        heightComboBoxNormal: 24 * pt
                        heightComboBoxActive: 44 * pt
                        bottomIntervalListElement: 8 * pt
                        topEffect: false
                        normalColor: "#FFFFFF"
                        hilightTopColor: normalColor
                        paddingTopItemDelegate: 8 * pt
                        heightListElement: 32 * pt
                        intervalListElement: 10 * pt
                        indicatorWidth: 20 * pt
                        indicatorHeight: indicatorWidth
                        indicatorLeftInterval: 20 * pt
                        colorTopNormalDropShadow: "#00000000"
                        colorDropShadow: "#40ABABAB"
                        fontComboBox: [ mainFont.dapFont.medium18]
                        colorMainTextComboBox: [["#070023", "#070023"]]
                        colorTextComboBox: [["#070023", "#FFFFFF"]]

                        // TODO откуда брать список
                        model: ListModel {
                            ListElement { unit: qsTr("hours") }
                            ListElement { unit: qsTr("days") }
                            ListElement { unit: qsTr("seconds") }
                        }
                    }
                }
            }
        }

        DapRightPanelElement {
            width: control.width
            name: qsTr("Price")

            contentItem: Item {
                implicitWidth: parent.width
                implicitHeight: Math.max(spinBoxPrice.implicitHeight, comboBoxPrice.heightComboBoxNormal)

                DapDoubleSpinBox {
                    id: spinBoxPrice

                    anchors.verticalCenter: parent.verticalCenter
                    height: Math.min(implicitHeight, parent.height)
                    from: 0
                    to: 9999999999
                    decimals: unitsModel.get(comboBoxPrice.currentIndex).decimals
                }

                Item {
                    anchors.right: parent.right
                    width: comboBoxPrice.widthPopupComboBoxNormal
                    height: parent.height

                    DapComboBox {
                        id: comboBoxPrice

                        comboBoxTextRole: ["token"]
                        anchors.centerIn: parent
                        indicatorImageNormal: "qrc:/resources/icons/ic_arrow_drop_down_dark.png"
                        indicatorImageActive: "qrc:/resources/icons/ic_arrow_drop_up.png"
                        sidePaddingNormal: 0 * pt
                        sidePaddingActive: 20 * pt
                        normalColorText: "#070023"
                        hilightColorText: "#FFFFFF"
                        normalColorTopText: "#070023"
                        hilightColorTopText: "#070023"
                        hilightColor: "#330F54"
                        normalTopColor: "transparent"
                        widthPopupComboBoxNormal: 94 * pt
                        widthPopupComboBoxActive: 134 * pt
                        heightComboBoxNormal: 24 * pt
                        heightComboBoxActive: 44 * pt
                        bottomIntervalListElement: 8 * pt
                        topEffect: false
                        normalColor: "#FFFFFF"
                        hilightTopColor: normalColor
                        paddingTopItemDelegate: 8 * pt
                        heightListElement: 32 * pt
                        intervalListElement: 10 * pt
                        indicatorWidth: 20 * pt
                        indicatorHeight: indicatorWidth
                        indicatorLeftInterval: 20 * pt
                        colorTopNormalDropShadow: "#00000000"
                        colorDropShadow: "#40ABABAB"
                        fontComboBox: [ mainFont.dapFont.medium18]
                        colorMainTextComboBox: [["#070023", "#070023"]]
                        colorTextComboBox: [["#070023", "#FFFFFF"]]

                        // TODO откуда брать список
                        model: ListModel {
                            id: unitsModel

                            ListElement { token: "KLVN"; decimals: 7 }
                            ListElement { token: "BTC"; decimals: 2 }
                            ListElement { token: "ETH"; decimals: 4 }
                        }
                    }
                }
            }
        }

        Item {
            width: 1
            height: 36 * pt
        }

        DapTextButton {
            anchors.horizontalCenter: parent.horizontalCenter
            width: 132 * pt
            height: 36 * pt
            text: qsTr("Create")

            // TODO
            onClicked: {
                console.log("CRATE ORDER CLICKED. name: " + textName.text + "; region: " + comboBoxRegion.currentText + "; Units: "
                            + comboBoxUnit.currentText + " " + spinBoxUnit.value + "; Price: " + unitsModel.get(comboBoxPrice.currentIndex).token + " " + spinBoxPrice.value);

                vpnTest.ordersModel.append({
                                               name: textName.text,
                                               dateCreated: (new Date()).toLocaleDateString(Qt.locale(), Locale.LongFormat),
                                               units: spinBoxUnit.value,
                                               unitsType: comboBoxUnit.currentText,
                                               value: spinBoxPrice.value,
                                               token: unitsModel.get(comboBoxPrice.currentIndex).token
                                           });

                control.orderCreated();
            }
        }

    }

}
