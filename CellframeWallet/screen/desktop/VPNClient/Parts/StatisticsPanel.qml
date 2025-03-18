import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import "qrc:/widgets"

Item
{
    height: 238 * pt

    ListModel {
        id: statisticsModel
        ListElement {
            name: qsTr("Download speed")
            value: "10205 Mbps"
        }
        ListElement {
            name: qsTr("Upload speed")
            value: "10205 Mbps"
        }
        ListElement {
            name: qsTr("Download")
            value: "20 896 Mb"
        }
        ListElement {
            name: qsTr("Upload")
            value: "8 896 Mb"
        }
        ListElement {
            name: qsTr("Packets received")
            value: "4 086"
        }
        ListElement {
            name: qsTr("Packets sent")
            value: "1 086"
        }
    }

    DapRectangleLitAndShaded
    {
        anchors.fill: parent
        color: currTheme.backgroundElements
        radius: currTheme.frameRadius
        shadowColor: currTheme.shadowColor
        lightColor: currTheme.reflectionLight

        contentData:
            ListView
            {
                anchors.fill: parent
                anchors.leftMargin: 20 * pt
                anchors.rightMargin: 20 * pt
                anchors.topMargin: 5 * pt
                anchors.bottomMargin: 10 * pt

                model: statisticsModel
                delegate:
                    RowLayout
                    {
                        width: parent.width
                        height: 38 * pt

                        Text
                        {
                            Layout.fillWidth: true
                            color: currTheme.textColor
                            font: mainFont.dapFont.regular12
                            text: name
                        }
                        Text
                        {
                            Layout.fillWidth: true
                            horizontalAlignment: Qt.AlignRight
                            color: currTheme.textColor
                            font: mainFont.dapFont.regular13
                            text: value
                        }
                    }

            }
    }

}
