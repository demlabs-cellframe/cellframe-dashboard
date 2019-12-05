import QtQuick 2.6
import QtQuick.Controls 2.1

Dialog {
    id: dialogRemoveWallet
    focus: true
    modal: true
    
    header:
        Rectangle
    {
        height: 30
        color: "#353841"

        Text
        {
            id: textTitle
            leftPadding: 10
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("Remove wallet...")
            font.family: "Roboto"
            font.pixelSize: 16
            color: "white"
        }
        Rectangle
        {
            anchors.bottom: parent.bottom
            height: 2
            width: parent.width
            color: "green"
        }
    }

    width: parent.width/1.5
    height: 150

    x: parent.width / 2 - width / 2
    y: parent.height / 2 - height / 2

    function show() {
        dialogRemoveWallet.open();
    }
    
    
    
    contentItem:

        Rectangle
    {
        anchors.fill: parent

        TextEdit {


            id: textQuery
            wrapMode: TextEdit.Wrap
            text: qsTr("Are you sure you want to delete\n\"" + dapQmlWidgetChainWallet.nameWallet + " \"?")
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter

            height: 55
            anchors.bottom: buttonOk.top
            anchors.bottomMargin: 20
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 10
            font.pixelSize: 20
            clip: true
        }

        Button
        {
            id: buttonCancel
            text: qsTr("Cancel")
            anchors.right: buttonOk.left
            anchors.rightMargin: 10
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10

            contentItem: Text {
                text: buttonCancel.text
                font: buttonCancel.font
                opacity: enabled ? 1.0 : 0.3
                color: buttonCancel.down ? "#353841" : "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            background: Rectangle {
                implicitWidth: 100
                implicitHeight: 30
                opacity: enabled ? 1 : 0.3
                color: buttonCancel.down ? "white" : "#353841"
                radius: 4
            }

            onClicked:
            {
                close()
            }
        }

        Button
        {
            id: buttonOk
            text: "OK"
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            contentItem: Text {
                text: buttonOk.text
                font: buttonOk.font
                opacity: enabled ? 1.0 : 0.3
                color: buttonOk.down ? "#353841" : "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            background: Rectangle {
                implicitWidth: 100
                implicitHeight: 30
                opacity: enabled ? 1 : 0.3
                color: buttonOk.down ? "white" : "#353841"
                radius: 4
            }

            onClicked:
            {
                dapServiceController.removeWallet(dapQmlWidgetChainWallet.indexWallet, dapQmlWidgetChainWallet.nameWallet)
                close()
            }
        }
    }
}
