import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0

///This file will be moved to libdap and removed from here.
///this comboBox used int top panel exchange and statusBar will be deleted in the future
ComboBox {
    property alias headerTextColor: headerText.color
    property alias widthArrow: arrow.width
    property alias heightArrow: arrow.height
    property string hilightColor: "#332F49";
    property int fontSizeDelegateComboBox: 14*pt//textDelegateComboBox.font.pixelSize
    id: customComboBox
    width: parent.width
    height: parent.height

    delegate:DapUiQmlWidgetStatusBarComboBoxDelegate{delegateContentText: modelData;}

    indicator: Image {
        id: arrow
        source: parent.popup.visible ? "qrc:/Resources/Icons/ic_arrow_drop_up.png" : "qrc:/Resources/Icons/ic_arrow_drop_down.png"
        width: 24 * pt
        height: 24 * pt
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 16 * pt
    }

    background: Rectangle {
        anchors.fill: parent
        color: parent.popup.visible ? "#FFFFFF" : "transparent"
        radius: 2 * pt
        height: parent.height

    }

    contentItem: Text {
        id: headerText
        anchors.fill: parent
        anchors.leftMargin: 12 * pt
        anchors.rightMargin: 48 * pt
        anchors.topMargin: 10 * pt
        text: parent.displayText
        font.family: fontRobotoRegular.name
        font.pixelSize: parent.font.pixelSize
        color: parent.popup.visible ? hilightColor : "#FFFFFF"
        verticalAlignment: Text.AlignTop
        elide: Text.ElideRight
    }

    popup: Popup {
        y: parent.height - 1
        width: parent.width + 1
        padding: 1
        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: customComboBox.popup.visible ? customComboBox.delegateModel : null
            ScrollIndicator.vertical: ScrollIndicator { }
        }

        background: Rectangle {
            width: customComboBox.background.width
            Rectangle {
                id: contentCorner
                anchors.fill: parent
            }

            DropShadow {
                anchors.fill: parent
                source: contentCorner
                verticalOffset: 9 * pt
                samples: 13 * pt
                color: "#40000000"
            }
        }
    }

    DropShadow {
        anchors.fill: parent
        source: background
        verticalOffset: 9 * pt
        samples: 13 * pt
        color: "#40000000"
    }
}
