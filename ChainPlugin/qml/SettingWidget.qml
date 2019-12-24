import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3

ApplicationWindow {
    id:settingWindow
    visible: true
    width: 300
    height: 400
    title: qsTr("settings")

            ListModel {
                id:tmp
                ListElement {
                    nameNetwork: "network 2"
                    ip: "123.324.123.21"
                    port:"2341"
                }
                ListElement {
                    nameNetwork: "Chain net 1"
                    ip: "23.254.133.21"
                    port:"21"
                }
                ListElement {
                    nameNetwork: "rostelekom"
                    ip: "123.34.123.212"
                    port:"80"
                }
            }

            Rectangle {
                width: 220; height: 300

                Component {
                    id: contactDelegate
                    Item {
                        width: 220; height: 40
                        Column {
                            Text { text: '<b>Name:</b> ' + nameNetwork}
                            Text { text: '<b>IP:</b> ' + ip + ' <b>PORT:</b>' + port}

                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {list.currentIndex = index    //To select an object (line)
                            list.nameNetwork = nameNetwork
                            }
                        }
                    }
                }

                ListView {
                    id:list
                    boundsBehavior: Flickable.StopAtBounds
                    anchors.fill: parent
                    model: SettingModel
                    delegate: contactDelegate
                    highlight: Rectangle {
                        color: "lightsteelblue";
                        radius: 5
                    }
                    property var nameNetwork: "name0"
                    focus: true
                }
            }

            Button {
                id: button
                x: 13
                y: 330
                width: 76
                height: 53
                text: qsTr("SAVE")
                onClicked: {
                    settingModel.saveNetworkFromQML(list.currentIndex,list.nameNetwork) //Mandatory method for saving
                    close()
                }
            }

}
