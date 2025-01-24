import QtQuick 2.4
import QtQuick.Controls 2.5
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import "qrc:/widgets"

Popup {
    id: dialog

    signal signalAccept(var accept);
    property alias dapButtonOk: buttonOk
    property alias dapButtonCancel: buttonCancel

    property alias fee1Layout: fee1Layout
    property alias fee1Name  : fee1Name
    property alias fee1Value : fee1Value

    property alias fee2Layout: fee2Layout
    property alias fee2Name  : fee2Name
    property alias fee2Value : fee2Value

    property alias fee3Layout: fee3Layout
    property alias fee3Name  : fee3Name
    property alias fee3Value : fee3Value

    property string network: ""

    property bool isLoading: false

    property var feeStruct:
    {
        "error": 1,
        "fee_ticker": "UNKNOWN",
        "network_fee": "0.00",
        "validator_fee": "0.00"
    }

    width: 306
    height: 298

    parent: Overlay.overlay
    x: (parent.width - width) * 0.5
    y: (parent.height - height) * 0.5

    scale: mainWindow.scale

    modal: true

    closePolicy: Popup.NoAutoClose

    background:
    Item
    {
        Rectangle{
            id: backgroundFrame
            anchors.fill: parent
            border.width: 0
            radius: 16
            color: currTheme.secondaryBackground
        }
        InnerShadow {
            anchors.fill: backgroundFrame
            source: backgroundFrame
            color: currTheme.reflection
            horizontalOffset: 1
            verticalOffset: 1
            radius: 0
            samples: 10
            opacity: backgroundFrame.opacity
            fast: true
            cached: true
        }
        DropShadow {
            anchors.fill: backgroundFrame
            source: backgroundFrame
            color: currTheme.shadowMain
            horizontalOffset: 5
            verticalOffset: 5
            radius: 10
            samples: 20
            opacity: backgroundFrame.opacity ? 0.42 : 0
            cached: true
        }
    }
    contentItem:
    ColumnLayout
    {
        anchors.fill: parent
        anchors.margins: 32
        spacing: 0

        Text {
            id: dapContentTitle
            Layout.fillWidth: true
            font: mainFont.dapFont.medium16
            color: currTheme.white
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
        }

        Text {
            id: dapContentText
            Layout.fillWidth: true
            Layout.topMargin: 16
            font: mainFont.dapFont.medium14
            color: currTheme.white
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
        }

        Rectangle{
            Layout.topMargin: 16
            Layout.fillWidth: true
            height: 1
            color: currTheme.rowHover
        }

        DapLoadIndicator {
            Layout.topMargin: 16
            visible: !isLoading
            Layout.alignment: Qt.AlignHCenter

            indicatorSize: 45
            countElements: 8
            elementSize: 7

            running: !isLoading
        }

        ColumnLayout
        {
            visible: isLoading
            Layout.fillWidth: true

            RowLayout{
                id: fee1Layout
                Layout.fillWidth: true
                Layout.topMargin: 16
                spacing: 0

                Text{
                    id:fee1Name
                    Layout.fillWidth: true
                    text: qsTr("Network:")
                    color: currTheme.gray
                    font: mainFont.dapFont.medium14
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                }

                Item{
                    Layout.minimumWidth: 150
                    height: 20

                    DapBigText
                    {
                        id: fee1Value
                        anchors.fill: parent
                        textFont: mainFont.dapFont.medium14
                        textColor: currTheme.white
                        fullText: feeStruct.network_fee + " " + feeStruct.fee_ticker
                        horizontalAlign: Text.AlignRight
                    }
                }
            }

            RowLayout{
                id: fee2Layout
                Layout.fillWidth: true
                Layout.topMargin: 12
                spacing: 0

                Text{
                    id:fee2Name
                    Layout.fillWidth: true
                    text: qsTr("Validator:")
                    color: currTheme.gray
                    font: mainFont.dapFont.medium14
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                }

                Item{
                    Layout.minimumWidth: 150
                    height: 20

                    DapBigText
                    {
                        id: fee2Value
                        anchors.fill: parent
                        textFont: mainFont.dapFont.medium14
                        textColor: currTheme.white
                        fullText: feeStruct.validator_fee + " " + feeStruct.fee_ticker
                        horizontalAlign: Text.AlignRight
                    }
                }
            }

            RowLayout{
                id: fee3Layout
                visible: false
                Layout.fillWidth: true
                Layout.topMargin: 12
                spacing: 0

                Text{
                    id:fee3Name
                    Layout.fillWidth: true
                    text: qsTr("Service:")
                    color: currTheme.gray
                    font: mainFont.dapFont.medium14
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                }

                Item{
                    Layout.minimumWidth: 150
                    height: 20

                    DapBigText
                    {
                        id: fee3Value
                        anchors.fill: parent
                        textFont: mainFont.dapFont.medium14
                        textColor: currTheme.white
                        fullText: "0.0 CELL"
                        horizontalAlign: Text.AlignRight
                    }
                }
            }
        }


        Rectangle{
            Layout.topMargin: 16
            Layout.fillWidth: true
            height: 1
            color: currTheme.rowHover
        }

        RowLayout
        {
            Layout.topMargin: 24
            Layout.bottomMargin: 32
            spacing: 10

            DapButton
            {
                id:buttonOk

                Layout.fillWidth: true

                enabled: isLoading

                Layout.minimumHeight: 36
                Layout.maximumHeight: 36

                textButton: qsTr("Ok")

                implicitHeight: 36
                fontButton: mainFont.dapFont.medium14
                horizontalAligmentText: Text.AlignHCenter

                onClicked:
                {
                    loadIndicator.running = true
                    dapButtonSend.enabled = false
                    dialog.close()
                    signalAccept(true)
                    isLoading = false
                }
            }

            DapButton
            {
                id:buttonCancel

                visible: false
                Layout.fillWidth: true

                Layout.minimumHeight: 36
                Layout.maximumHeight: 36

                textButton: qsTr("Cancel")

                implicitHeight: 36
                fontButton: mainFont.dapFont.medium14
                horizontalAligmentText: Text.AlignHCenter

                onClicked:
                {
                    dialog.close()
                    signalAccept(false)
                    isLoading = false
                }
            }
        }

        Item{Layout.fillHeight: true}
    }

    function smartOpen(title, contentText) {
        feeStruct = walletModule.getFee(network);

        if(feeStruct.error === 0)
        {
            isLoading = true
            dapContentTitle.text = title
            dapContentText.text = contentText
            dialog.open()
        }
        else
        {
            isLoading = false
            dapContentTitle.text = title
            dapContentText.text = qsTr("Error processing network information")
            dialog.open()
        }
    }
}
