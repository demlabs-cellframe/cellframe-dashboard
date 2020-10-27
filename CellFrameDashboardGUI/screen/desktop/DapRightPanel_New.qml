import QtQuick 2.4
import QtQuick.Controls 1.4
import "qrc:/widgets"

Rectangle
{
    id: root

    property string caption: "New Wallet"
    property alias stackView: stackView

    anchors.top: parent.top
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    anchors.margins: visible ? 24*pt : 0
    anchors.leftMargin: 0
    width: visible ? 350 * pt : 0;
    border.color: "#E2E1E6"
    border.width: 1 * pt
    radius: 8 * pt

    Item {
        id: title

        width: parent.width
        height: 40 * pt

        DapButton_New
        {
            id: backButton

            height: 20 * pt
            width: height
            x: 16 * pt
            anchors.verticalCenter: parent.verticalCenter

            iconSource:      stackView.depth > 1 ? "qrc:/resources/icons/back_icon.png"       : "qrc:/resources/icons/Certificates/close_icon.svg"
            hoverIconSource: stackView.depth > 1 ? "qrc:/resources/icons/back_icon_hover.png" : "qrc:/resources/icons/Certificates/close_icon_hover.svg"

            iconSubcontroll.sourceSize: Qt.size(20 * pt, 20 * pt)
            onClicked:
            {
                if(stackView.pop() === null)
                    root.visible = false;
            }
        }

        Text {
            id: titleText
            anchors
            {
                left: backButton.right
                leftMargin: 13 * pt
                verticalCenter: parent.verticalCenter
            }
            font: quicksandFonts.bold14
            color: "#3E3853"
            text: qsTr(root.caption)
        }
    }
    StackView
    {
        id: stackView
        anchors
        {
            top:title.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        delegate: StackViewDelegate
        {
            pushTransition: StackViewTransition { }
        }
    }


}
