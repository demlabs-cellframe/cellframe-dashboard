import QtQuick 2.9
import QtQuick.Controls 1.4
import KelvinDashboard 1.0

DapUiQmlWidgetChainNodeLogsForm {
    id: dapQmlWidgetChainNodeLogs

    Component
    {
        id: componentItenDelegate
            Rectangle
            {
                color: listViewLogs.currentIndex === index ? "#48435F" : "#3B3652"
                width: listViewLogs.width
                height: 72
                z: 1
                clip: true

                Row
                {
                    id: rowItem
                    padding: 10
                    spacing: 10
                    clip: true
                    width: parent.width
                    Column
                    {
                        anchors.leftMargin: 10
                        width: 25
                        Text
                        {
                            text: qsTr(type)
                            color: "#CFCBD9"
                            font.weight: Font.Normal
                            font.family: "Roboto"
                            font.pointSize: 10
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                    Column
                    {
                        spacing: 5
                        clip: true
                        width: rowItem.width - 50
                        Text
                        {
                            text: qsTr(message)
                            color: "#CFCBD9"
                            font.weight: Font.Normal
                            font.family: "Roboto"
                            font.pointSize: 10
                            width: parent.width
                            elide: Text.ElideRight
                        }
                        Text
                        {
                            text: qsTr(file)
                            color: "#CFCBD9"
                            font.weight: Font.Light
                            font.family: "Roboto"
                            font.pointSize: 8
                        }
                        Text
                        {
                            text: qsTr(timestamp)
                            color: "#CFCBD9"
                            font.weight: Font.Light
                            font.family: "Roboto"
                            font.pointSize: 8
                        }
                    }
                }

            MouseArea
            {
                id: mouseAreaListViewLogs
                anchors.fill: parent
                onClicked: listViewLogs.currentIndex = index
            }
        }
    }
}
