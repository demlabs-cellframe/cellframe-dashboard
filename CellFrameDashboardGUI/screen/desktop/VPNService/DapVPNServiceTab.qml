import QtQuick 2.7
import QtQuick.Controls 2.2
import ".."

Item {
    id: tab

    // TODO только для теста
    Item {
        id: vpnTest

        property alias ordersModel: ordersModel

        Component.onCompleted: {
            for (var i = 0; i < 10; ++ i) {
                ordersModel.append({
                                       name: "order " + i,
                                       dateCreated: "April 22, 2020",
                                       units: 3600,
                                       unitsType: "seconds",
                                       value: 0.1,
                                       token: "KELT"
                                   });
            }
        }

        ListModel {
            id: ordersModel

            onCountChanged: console.log("VPN TEST ORDERS COUNT CHANGED: " + count);

            /*ListElement {
                name: ""
                dateCreated: "April 22, 2020"
                units: 3600
                unitsType: "seconds"
                value: 0.1
                token: "KELT"
            }*/
        }
    }

    // TODO как узнать?
    property bool ordersExists: vpnTest.ordersModel.count > 0

    function newVPNOrder()
    {
        rightPanel.caption = qsTr("Create VPN order");
        rightPanel.stackView.clear();
        rightPanel.stackView.push(createVPNOrderPanel);
        rightPanel.visible = true;
    }

    state: {
        if (ordersExists) {
            return "showOrders";
        } else if (rightPanel.visible) {
            return "creatingFirstOrder";
        } else {
            return "noOrders";
        }
    }

    Column {
        anchors.fill: parent

        DapVPNServiceTopPanel {
            id: topPanel

            onNewVPNOrder: tab.newVPNOrder()
        }

        Item {
            height: parent.height - topPanel.height
            width: parent.width

            // for DapVPNOrdersGridView
            clip: true

            Item {
                id: mainPanel

                property int margin: 24 * pt
                property int halfMargin: margin * 0.5

                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: rightPanel.left
                anchors.bottom: parent.bottom

                DapNoOrdersPanel {
                    id: createYourFirstVPNOrderPanel

                    anchors.fill: parent
                    anchors.margins: mainPanel.margin
                    visible: false

                    onNewVPNOrder: tab.newVPNOrder()
                }

                Text {
                    id: textCreatingVPNOrder

                    anchors.centerIn: parent
                    font: quicksandFonts.medium26
                    elide: Text.ElideRight
                    color: "#070023"
                    text: qsTr("Creating VPN order in process…")
                    visible: false
                }

                Item {
                    id: vpnOrders

                    anchors.fill: parent
                    anchors.margins: mainPanel.halfMargin
                    visible: false

                    Text {
                        id: textMyVPNOrders
                        x: mainPanel.halfMargin
                        y: mainPanel.halfMargin
                        font: quicksandFonts.bold14
                        color: "#3E3853"
                        text: qsTr("My VPN orders")
                    }

                    DapVPNOrdersGridView {
                        id: vpnOrdersView

                        anchors { left: parent.left; top: textMyVPNOrders.bottom; right: parent.right; bottom: parent.bottom }
                        delegateMargin: mainPanel.halfMargin
                    }
                }
            }

            DapRightPanel_New {
                id: rightPanel
                visible: false
            }
        }
    }

    Component {
        id: createVPNOrderPanel

        DapCreateVPNOrderPanel {
            onOrderCreated: {
                rightPanel.stackView.clear();
                rightPanel.visible = false;
            }
        }
    }

    states: [
        State {
            name: "noOrders"
            PropertyChanges {
                target: createYourFirstVPNOrderPanel
                visible: true
            }
            PropertyChanges {
                target: topPanel
                btnNewVPNOrderVisible: false
            }
        },
        State {
            name: "creatingFirstOrder"
            PropertyChanges {
                target: textCreatingVPNOrder
                visible: true
            }
        },
        State {
            name: "showOrders"
            PropertyChanges {
                target: vpnOrders
                visible: true
            }
        }
    ]
}
