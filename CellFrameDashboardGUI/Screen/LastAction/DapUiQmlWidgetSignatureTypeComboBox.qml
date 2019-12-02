import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import "../"

DapUiQmlWidgetStatusBarComboBox {

    model: ListModel {
        id: signatureType
        ListElement {
            signatureName: "Dilithium"
        }
        ListElement {
            signatureName: "Bliss"
        }
        ListElement {
            signatureName: "Picnic"
        }
        ListElement {
            signatureName: "Tesla"
        }
    }

    headerTextColor: "#070023"
    widthArrow: 20 * pt
    heightArrow: 20 * pt

    font {
        pointSize: 16
        family: "Roboto"
        styleName: "Normal"
        weight: Font.Normal
    }

    currentIndex: 0
    displayText: currentText

    delegate: ItemDelegate {
        width: parent.width
        contentItem: DapUiQmlWidgetStatusBarContentItem {
             text: signatureName
             color: hovered ? "#FFFFFF" : "#070023"
        }

        background: Rectangle {
            height: 32 * pt
            color: hovered ? "#330F54" : "#FFFFFF"
        }

        highlighted: parent.highlightedIndex === index
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
