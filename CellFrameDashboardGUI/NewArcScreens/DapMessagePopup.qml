import QtQuick 2.4
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3

import "qrc:/widgets"

Popup {
    id: dialog

    width: 300 * pt
    //height: 200 * pt
    height: popupLayout.height + 40 * pt

    parent: Overlay.overlay
    x: (parent.width - width) * 0.5
    y: (parent.height - height) * 0.5

    modal: true

    background: Rectangle
    {
        border.width: 0
        radius: 16 * pt
        color: currTheme.backgroundElements
    }

    ColumnLayout
    {
        id: popupLayout
        //anchors.fill: parent
        //anchors.margins: 10 * pt
        width: parent.width - 20 * pt
        height: childrenRect.height
        anchors.centerIn: parent

        Text {
            id: dapContentTitle
            Layout.fillWidth: true
            Layout.margins: 10 * pt
            font: _dapQuicksandFonts.dapFont.medium16
            color: currTheme.textColor
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
        }

        Text {
            id: dapContentText
            Layout.fillWidth: true
            Layout.margins: 10 * pt
            font: _dapQuicksandFonts.dapFont.medium16
            color: currTheme.textColor
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
        }

        RowLayout
        {
            Layout.margins: 10 * pt
            Layout.bottomMargin: 20 * pt
            spacing: 10 * pt

            DapButton
            {
                Layout.fillWidth: true

                Layout.minimumHeight: 36 * pt
                Layout.maximumHeight: 36 * pt

                textButton: qsTr("Ok")

                implicitHeight: 36 * pt
                fontButton: _dapQuicksandFonts.dapFont.medium14
                horizontalAligmentText: Text.AlignHCenter

                onClicked:
                    dialog.close()
            }
        }
    }

    function smartOpen(title, contentText) {
        dapContentTitle.text = title
        dapContentText.text = contentText
        dialog.open()
    }
}
