import QtQuick 2.9
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.12
import "qrc:/widgets"
import "../parts"

Page {
    id: root
    property alias closeButton: closeButton
    property alias certificateDataListView: certificateDataListView

    background: Rectangle {
        color: "transparent"
    }

    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0

        Item
        {
            Layout.fillHeight: true
            Layout.fillWidth: true

            Item {
                id: titleRectangle
                width: parent.width
                height: 40 * pt

                CloseButton {
                    id: closeButton
                    x: 16 * pt

                    onClicked: certificateNavigator.clearRightPanel()
                }  //

                Text {
                    id: certificatesTitleText
                    anchors{
                        left: closeButton.right
                        leftMargin: 12 * pt
                        verticalCenter: closeButton.verticalCenter
                    }
                    font: mainFont.dapFont.bold14
                    color: currTheme.textColor
                    text: qsTr("Info about certificate")
                }
            }  //titleRectangle

            ListView {
                id: certificateDataListView
                y: titleRectangle.y + titleRectangle.height + 11 * pt
                width: parent.width
                height: 550 * pt
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
    }
}   //root



