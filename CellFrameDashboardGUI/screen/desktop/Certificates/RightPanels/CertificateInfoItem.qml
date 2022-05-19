import QtQuick 2.9
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.12
import "qrc:/widgets"
import "../parts"

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
            DapButton
            {
                anchors.left: parent.left
                anchors.right: textHeader.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 10 * pt
                anchors.bottomMargin: 7 * pt
                anchors.leftMargin: 24 * pt
                anchors.rightMargin: 13 * pt

                id: itemButtonClose
                height: 20 * pt
                width: 20 * pt
                heightImageButton: 10 * pt
                widthImageButton: 10 * pt
                activeFrame: false
                normalImageButton: "qrc:/resources/icons/"+pathTheme+"/close_icon.png"
                hoverImageButton:  "qrc:/resources/icons/"+pathTheme+"/close_icon_hover.png"
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



