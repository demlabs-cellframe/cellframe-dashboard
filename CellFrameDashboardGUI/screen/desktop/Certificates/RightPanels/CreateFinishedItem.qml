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

    ColumnLayout
    {
        anchors.centerIn: parent
        width: parent.width * 0.8
        height: childrenRect.height
        spacing: 20 * pt

        Text {
            id: finishedTextTitle
            font: mainFont.dapFont.medium28
            color: currTheme.textColor
            text: titleText
            horizontalAlignment: Text.AlignHCenter
            Layout.preferredWidth: parent.width
            wrapMode: Text.Wrap
        }

        Text {
            id: finishedTextContent
            font: mainFont.dapFont.medium20
            color: currTheme.textColor
            text: contentText
            horizontalAlignment: Text.AlignHCenter
            Layout.preferredWidth: parent.width
            wrapMode: Text.Wrap
        }

        DapButton {
            id: doneButton
            textButton: {if (accept) return qsTr("Done")
                else return qsTr("Back")}
            Layout.preferredWidth: 132 * pt
            Layout.preferredHeight: 36 * pt
            fontButton: mainFont.dapFont.regular16
            horizontalAligmentText: Qt.AlignHCenter
            Layout.alignment: Qt.AlignCenter

            onClicked:
            {
                if (accept)
                    certificateNavigator.clearRightPanel()
                else dapRightPanel.pop()
            }
        }
    }

}   //root
