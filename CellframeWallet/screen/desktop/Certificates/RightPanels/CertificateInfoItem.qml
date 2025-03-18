import QtQuick 2.9
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.12
import "qrc:/widgets"
import "../parts"
import "../../controls"

DapRectangleLitAndShaded {
    id: root
    property alias closeButton: itemButtonClose
    property alias certificateDataListView: certificateDataListView

    color: currTheme.secondaryBackground
    radius: currTheme.frameRadius
    shadowColor: currTheme.shadowColor
    lightColor: currTheme.reflectionLight

    contentData:
    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        Item
        {
            Layout.fillWidth: true
            height: 42 

            HeaderButtonForRightPanels{
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 16

                id: itemButtonClose
                height: 20 
                width: 20 
                heightImage: 20 
                widthImage: 20 

                normalImage: "qrc:/Resources/"+pathTheme+"/icons/other/cross.svg"
                hoverImage:  "qrc:/Resources/"+pathTheme+"/icons/other/cross_hover.svg"
                onClicked: certificateNavigator.clearRightPanel()
            }

            Text
            {
                id: textHeader
                text: qsTr("Info about certificate")
                verticalAlignment: Qt.AlignLeft
                anchors.left: itemButtonClose.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 10

                font: mainFont.dapFont.bold14
                color: currTheme.white
            }
        }

        ListView {
            id: certificateDataListView
            Layout.topMargin: 8
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.leftMargin: 16
            Layout.rightMargin: 16
            spacing: 16
            clip: true
            model: models.certificateInfo

            delegate: TitleTextView {
                anchors.left: parent.left
                anchors.right: parent.right

                title.text: model.keyView
                content.text:
                {
                    if (model.keyView === qsTr("Expiration date") || model.keyView === qsTr("Date of creation"))
                    {
                        var m_date = Date.fromLocaleDateString(Qt.locale(), model.value, "dd.MM.yyyy")
                        return m_date.toLocaleDateString(Qt.locale("en_En"), "MMMM d, yyyy")
                    }
                    else return model.value
                }
                title.color: currTheme.gray
            }
        }
    }
}   //root



