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

        ListElement {
            name: qsTr("VPN")
            element: "qrc:/screen/VPN/DapUiQmlWidgetSettingsVpn.qml"
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
        section.delegate: DapUiQmlScreenSettingsSection {}
    }
}
