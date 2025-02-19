import QtQuick 2.4
import QtQuick.Controls 1.4 as Controls
import QtQuick.Controls.Styles 1.4 as Styles
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "qrc:/widgets"

Item {

    property string headerText

    ListModel
    {
        id: receiptDataModel

        ListElement
        {
            key : qsTr("Service type")
            value : "VPN"
        }

        ListElement
        {
            key : qsTr("Units")
            value : "3600 hours"
        }

        ListElement
        {
            key : qsTr("Value Token")
            value : "25.098 KELT"
        }

        ListElement
        {
            key : qsTr("Service public key hash")
            value : "9687c3900da10c0b97afaa615b523a9e5909349dc730e2323cd6e32529cb95f0"
        }

        ListElement
        {
            key : qsTr("Client public key hash")
            value : "111e354bba8ddd407fe7ba0e708d333147df1c1a774d7d121ddfd2dbf37a3050"
        }

        ListElement
        {
            key : qsTr("Max value")
            value : "-"
        }

        ListElement
        {
            key : qsTr("Region, Country")
            value : "Europe, Ireland"
        }

        ListElement
        {
            key : qsTr("Min speed")
            value : "Ireland"
        }
    }

    ColumnLayout
    {
        anchors.fill: parent
        spacing: 15 * pt

    RowLayout
    {
        id: header

        Layout.maximumHeight: 42 * pt
        Layout.maximumWidth: parent.width
        Layout.leftMargin: 10 * pt

        DapButton
        {
            Layout.maximumWidth: 20 * pt
            Layout.maximumHeight: 20 * pt
            Layout.topMargin: 10 * pt

            height: 20 * pt
            width: 20 * pt
            heightImageButton: 10 * pt
            widthImageButton: 10 * pt
            activeFrame: false
            normalImageButton: "qrc:/resources/icons/BlackTheme/back_icon.png"
            hoverImageButton:  "qrc:/resources/icons/BlackTheme/back_icon_hover.png"
            onClicked: vpnClientNavigator.closeVpnReceiptsDetails()
        }

        Text
        {
            Layout.fillWidth: true
            Layout.topMargin: 8
            verticalAlignment: Qt.AlignVCenter
            font: mainFont.dapFont.medium14
            color: currTheme.textColor

            text: headerText
        }
    }

        ListView {
            id: receiptDataListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 22 * pt
            clip: true
            model: receiptDataModel

            delegate: Item {
                x: 16 * pt
                width: parent.width - x * 2
                height: title.height + 10 * pt + content.height

                Text {
                    id: title
                    font: mainFont.dapFont.regular12
                    color: currTheme.textColor
                    width: parent.width
                    wrapMode: Text.Wrap
                    text: key
                }

                Text {
                    id: content
                    y: title.height + 10 * pt
                    font: mainFont.dapFont.medium14
                    color: currTheme.textColor
                    width: parent.width
                    wrapMode: Text.Wrap
                    text: value
                }


            }
        }
    }








    DapButton
    {
        x: parent.width * 0.5 - width * 0.5
        y: parent.height - height - 16 * pt
        width: 150 * pt
        height: 36 * pt
        horizontalAligmentText: Text.AlignHCenter
        fontButton: mainFont.dapFont.regular16
        textButton: qsTr("Save")
    }



}
