import QtQuick 2.7
import QtQuick.Controls 2.2
import ".."

Item {
    id: tab

    Item {
        id: test


    }

    // TODO как узнать?
    property bool ordersExists: false

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

            Item {
                id: mainPanel

                anchors.margins: 24 * pt
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: rightPanel.left
                anchors.bottom: parent.bottom

                DapNoOrdersPanel {
                    id: createYourFirstVPNOrderPanel

                    anchors.fill: parent
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
        }
    ]
}
