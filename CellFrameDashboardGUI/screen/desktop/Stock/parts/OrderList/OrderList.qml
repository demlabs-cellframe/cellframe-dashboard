import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "qrc:/widgets"

Item
{
//    color: "#404040"

    Component.onCompleted:
    {
        showPage("OpenOrders.qml")
    }

    DapRectangleLitAndShaded
    {
        anchors.fill: parent

        color: currTheme.backgroundElements
        radius: currTheme.radiusRectangle
        shadowColor: currTheme.shadowColor
        lightColor: currTheme.reflectionLight

        contentData:
            ColumnLayout
            {
                anchors.fill: parent
                spacing: 0

                RowLayout
                {
                    Layout.fillWidth: true
                    Layout.leftMargin: 0

                    spacing: 0

                    DapRadioButton
                    {
                        Layout.minimumWidth: 120

                        indicatorInnerSize: 40
                        spaceIndicatorText: -5
        //                fontRadioButton: mainFont.dapFont.regular16
                        implicitHeight: 40
                        fontRadioButton: mainFont.dapFont.medium14

                        nameRadioButton: qsTr("Open orders")
                        checked: true

                        onClicked: {
                            showPage("OpenOrders.qml")
                        }
                    }

                    DapRadioButton
                    {
                        Layout.minimumWidth: 120

                        indicatorInnerSize: 40
                        spaceIndicatorText: -5
        //                fontRadioButton: mainFont.dapFont.regular16
                        implicitHeight: 40
                        fontRadioButton: mainFont.dapFont.medium14

                        nameRadioButton: qsTr("Order history")
                        checked: false

                        onClicked: {
                            showPage("OrderHistory.qml")
                        }
                    }

                }

                StackView {
                    id: stackView
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    clip: true
                }

            }
    }

    function showPage(page)
    {
        stackView.clear()
        stackView.push(page)
    }
}

