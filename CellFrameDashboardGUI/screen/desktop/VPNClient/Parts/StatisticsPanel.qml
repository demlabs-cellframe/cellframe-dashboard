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
            name: "Download speed"
            value: "10205 Mbps"
        }
        ListElement {
            name: "Upload speed"
            value: "10205 Mbps"
        }
        ListElement {
            name: "Download"
            value: "20 896 Mb"
        }
        ListElement {
            name: "Upload"
            value: "8 896 Mb"
        }
        ListElement {
            name: "Packets received"
            value: "4 086"
        }
        ListElement {
            name: "Packets sent"
            value: "1 086"
        }
    }

    DapRectangleLitAndShaded
    {
        anchors.fill: parent
        color: currTheme.backgroundElements
        radius: currTheme.radiusRectangle
        shadowColor: currTheme.shadowColor
        lightColor: currTheme.reflectionLight

        contentData:
            ListView
            {
                anchors.fill: parent
                anchors.margins: 20 * pt

                model: statisticsModel
                delegate:
                    RowLayout
                    {
                        width: parent.width
                        height: 34 * pt

                        Text
                        {
                            Layout.fillWidth: true
                            color: currTheme.textColor
                            font: mainFont.dapFont.medium12
                            text: name
                        }
                        Text
                        {
                            Layout.fillWidth: true
                            horizontalAlignment: Qt.AlignRight
                            color: currTheme.textColor
                            font: mainFont.dapFont.medium12
                            text: value
                        }
                    }

            }
    }

}
