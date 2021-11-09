import QtQuick 2.4

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

        Rectangle {
            width: list.width
            height: childrenRect.height
            color: "lightsteelblue"

            Text {
                text: section
                font.bold: true
                font.pixelSize: 20
            }
        }
    }
}
