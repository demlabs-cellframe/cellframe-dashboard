import QtQuick 2.4
import QtQuick.Controls 2.12

DapUiQmlScreenSettingsForm {
    anchors.fill: parent

    ListModel {
        id: dapListModelSettings
        ListElement {
            name: qsTr("Network")
            element: "DapUiQmlWidgetSettingsNetwork.qml"
        }
    }

    ListView {
        id: dapListViewSettings
        anchors.fill: parent
        model: dapListModelSettings
        delegate: Component {

            Item {
                width: parent.width
                height: loaderSettings.height

                Loader {
                    id: loaderSettings
                    source: element
                }
            }
        }

        section.property: "name"
        section.criteria: ViewSection.FullString
        section.delegate: Component {

            Rectangle {
                width: parent.width
                height: 30 * pt
                color: "#DFE1E6"

                Text {
                    anchors.fill: parent
                    anchors.leftMargin: 18 * pt
                    verticalAlignment: Qt.AlignVCenter
                    text: section
                    font.family: "Roboto"
                    font.pixelSize: 12 * pt
                    color: "#5F5F63"
                }
            }

        }
    }
}
