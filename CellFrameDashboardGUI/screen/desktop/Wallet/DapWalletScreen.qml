import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

DapWalletScreenForm {

    testAddButton.onClicked: {
        someModel.append({
                             name: "New name",
                             number: "New number",
                             network: "New netwrk"
                         })
    }

    Component {
        id: sectionHeading

        RowLayout {
            width: list.width
            height: childrenRect.height
            Rectangle {
                Layout.fillHeight: true
                Layout.fillWidth: true
                color: currTheme.backgroundPanel
            }

            Text {
                Layout.alignment: Qt.AlignLeft
                text: section
                font.bold: true
                font.pixelSize: 20
            }

            Text {
                Layout.alignment: Qt.AlignRight
                text: list.model.address
            }
        }
    }
}
