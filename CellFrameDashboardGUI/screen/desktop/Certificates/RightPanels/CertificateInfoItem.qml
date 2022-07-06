import QtQuick 2.9
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.12
import "qrc:/widgets"
import "../parts"
import "../../controls"

Page {
    id: root
    property alias closeButton: itemButtonClose
    property alias certificateDataListView: certificateDataListView

    background: Rectangle {
        color: "transparent"
    }

    ColumnLayout
    {
        anchors.fill: parent
        spacing: 15 * pt

        Item
        {
            Layout.fillWidth: true
            height: 38 * pt

            HeaderButtonForRightPanels{
                anchors.left: parent.left
                anchors.right: textHeader.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 10 * pt
                anchors.bottomMargin: 7 * pt
                anchors.leftMargin: 21 * pt
                anchors.rightMargin: 13 * pt

                id: itemButtonClose
                height: 20 * pt
                width: 20 * pt
                heightImage: 20 * pt
                widthImage: 20 * pt

                normalImage: "qrc:/Resources/"+pathTheme+"/icons/other/cross.svg"
                hoverImage:  "qrc:/Resources/"+pathTheme+"/icons/other/cross_hover.svg"
                onClicked: certificateNavigator.clearRightPanel()
            }

            Text
            {
                id: textHeader
                text: qsTr("Info about certificate")
                verticalAlignment: Qt.AlignLeft
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 12 * pt
                anchors.bottomMargin: 8 * pt
                anchors.leftMargin: 52 * pt

                font: mainFont.dapFont.bold14
                color: currTheme.textColor
            }
        }

        ListView {
            id: certificateDataListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 22 * pt
            clip: true
            model: models.certificateInfo

            delegate: TitleTextView {
                x: 18 * pt
                title.text: model.keyView
                content.text:
                {
                    if (model.keyView === "Expiration date" || model.keyView === "Date of creation")
                    {
                        var m_date = Date.fromLocaleDateString(Qt.locale(), model.value, "dd.MM.yyyy")
                        return m_date.toLocaleDateString(Qt.locale("en_En"), "MMMM d, yyyy")
                    }
                    else return model.value
                }
                title.color: currTheme.textColorGray
            }
        }
    }
}   //root



