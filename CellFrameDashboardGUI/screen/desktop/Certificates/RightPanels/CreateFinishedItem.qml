import QtQuick 2.9
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import "qrc:/widgets"
import "../parts"


Page {
    id: root

    property bool accept
    property string titleText
    property string contentText

    background: Rectangle {
        color: "transparent"
    }

    //part animation on created and open
    visible: false
    opacity: visible ? 1.0 : 0.0

    Item
    {
        anchors.centerIn: parent
        width: parent.width * 0.8
        height: childrenRect.height

        Text {
            id: finishedTextTitle
            font: mainFont.dapFont.medium28
            color: currTheme.textColor
            text: titleText
            horizontalAlignment: Text.AlignHCenter
            width: parent.width
            wrapMode: Text.Wrap
        }

        Text {
            y: finishedTextTitle.height + finishedTextTitle.y + 20 * pt
            id: finishedTextContent
            font: mainFont.dapFont.medium20
            color: currTheme.textColor
            text: contentText
            horizontalAlignment: Text.AlignHCenter
            width: parent.width
            wrapMode: Text.Wrap
        }

        DapButton {
            id: doneButton
            textButton: {if (accept) return qsTr("Done")
                else return qsTr("Back")}
            height: 36 * pt
            width: 132 * pt
            x: parent.width * 0.5 - width * 0.5
            y: finishedTextContent.height + finishedTextContent.y + 20 * pt
            fontButton: mainFont.dapFont.regular16
            horizontalAligmentText: Qt.AlignHCenter

            onClicked:
            {
                if (accept)
                    certificateNavigator.clearRightPanel()
                else dapRightPanel.pop()
            }
        }
    }

}   //root
