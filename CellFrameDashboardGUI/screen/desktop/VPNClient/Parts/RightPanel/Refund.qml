import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Rectangle
{
    ListModel {
        id: refundModel
        ListElement {
            check: false
            value: 123
            balance: 1234.45
            token: "KELT"
        }
        ListElement {
            check: false
            value: 123.45
            balance: 12.3
            token: "DAPS"
        }
        ListElement {
            check: false
            value: 123
            balance: 24.636
            token: "USDT"
        }
    }

    readonly property int refundDelegateHeight: 80

    signal checkBoxSwitched()

    ColumnLayout
    {
        anchors.fill: parent

        RowLayout
        {
            Layout.fillWidth: true
            Layout.leftMargin: 10
            Layout.minimumHeight: 30
//            Layout.rightMargin: 10

            spacing: 10

            Button
            {
                id: closeButton
                Layout.maximumWidth: 20
                Layout.maximumHeight: 20
                Layout.topMargin: 10
//                Layout.alignment: Qt.AlignBottom
                font.pointSize: 12
                text: qsTr("X")
                onClicked: goToHomePage()
            }

            Text
            {
                Layout.fillWidth: true
                Layout.topMargin: 8
                verticalAlignment: Qt.AlignVCenter
                font.pointSize: 12
                font.bold: true
                color: "white"

                text: qsTr("Refund")
            }
        }

        Rectangle
        {
            Layout.fillWidth: true
            Layout.minimumHeight: 30

            Text
            {
                anchors.fill: parent
                anchors.leftMargin: 10
                color: "white"
                font.pointSize: 10
                verticalAlignment: Qt.AlignVCenter
                text: qsTr("Choose token and input value")
            }

            color: "dark blue"
        }

        ListView
        {
            Layout.fillWidth: true
            Layout.minimumHeight:
                refundModel.count * refundDelegateHeight
            Layout.leftMargin: 10
            Layout.rightMargin: 10
            Layout.topMargin: 10
            Layout.bottomMargin: 10
            clip: true
//                ScrollBar.vertical: ScrollBar {
//                    active: true
//                }

            model: refundModel

            delegate:
                RowLayout
                {
                    width: parent.width
                    height: refundDelegateHeight

                    CheckBox {
                        id: refundCheckBox
                        Layout.alignment: Qt.AlignTop
                        checked: false
                        onToggled:
                        {
                            check = checked
                            checkBoxSwitched()
                        }
                    }

                    ColumnLayout
                    {
                        enabled: refundCheckBox.checked
                        Layout.fillWidth: true
                        Layout.minimumHeight: refundDelegateHeight
                        spacing: 2

                        TextField
                        {
                            id: refundField
                            Layout.fillWidth: true
                            Layout.maximumHeight: 30
                            horizontalAlignment: Qt.AlignRight
                            font.pointSize: 10
                            placeholderText: "0"
    //                            text: value
                            onTextChanged: value = Number(text)
                        }

                        RowLayout
                        {
                            Layout.fillWidth: true
                            spacing: 5

                            Button
                            {
                                Layout.fillWidth: true
                                Layout.maximumHeight: 20
                                font.pointSize: 8
                                padding: 0
                                text: qsTr("25%")
                                onClicked:
                                    refundField.text = balance*0.25
                            }

                            Button
                            {
                                Layout.fillWidth: true
                                Layout.maximumHeight: 20
                                font.pointSize: 8
                                padding: 0
                                text: qsTr("50%")
                                onClicked:
                                    refundField.text = balance*0.5
                            }

                            Button
                            {
                                Layout.fillWidth: true
                                Layout.maximumHeight: 20
                                font.pointSize: 8
                                padding: 0
                                text: qsTr("75%")
                                onClicked:
                                    refundField.text = balance*0.75
                            }

                            Button
                            {
                                Layout.fillWidth: true
                                Layout.maximumHeight: 20
                                font.pointSize: 8
                                text: qsTr("100%")
                                onClicked:
                                    refundField.text = balance
                            }
                        }

                        Text
                        {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignTop
                            horizontalAlignment: Qt.AlignRight
                            color: "white"
                            font.pointSize: 8
                            text: "Avlb " + balance + " " + token
                        }
                    }

                    Text
                    {
                        enabled: refundCheckBox.checked
                        Layout.minimumHeight: 30
                        Layout.alignment: Qt.AlignTop
                        verticalAlignment: Qt.AlignBottom
                        color: "white"
                        font.pointSize: 10
                        text: token
                    }
                }
        }

        Button
        {
            id: refundButton
            Layout.alignment: Qt.AlignHCenter
            Layout.maximumHeight: 30
            font.pointSize: 10
            enabled: false
            text: qsTr("Refund")
        }

        Item
        {
            Layout.fillHeight: true
        }
    }

    onCheckBoxSwitched:
    {
        print("onCheckBoxSwitched")
        var test = false
        for (var i = 0; i < refundModel.count; ++i)
        {
            if (refundModel.get(i).check)
            {
                test = true
                break
            }
        }
        print("test", test)
        refundButton.enabled = test
    }

    color: "blue"
}
