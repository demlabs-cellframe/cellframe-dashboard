import QtQuick 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5

ColumnLayout {

    ProgressBar
    {
        Layout.topMargin: 10 * pt
        Layout.preferredWidth: 300 * pt
        Layout.preferredHeight: 60 * pt
        Layout.alignment:  Qt.AlignTop | Qt.AlignHCenter
    }

    Text
    {
        Layout.alignment:  Qt.AlignTop | Qt.AlignHCenter
        text: "Total: 120"
    }

    RowLayout
    {
        Layout.fillWidth: true
        Layout.leftMargin: 10 * pt
        Layout.rightMargin: 10 * pt
        spacing: 10 * pt

        Rectangle
        {
            Layout.alignment: Qt.AlignLeft
            Layout.preferredHeight: 70 * pt
            Layout.preferredWidth: 70 * pt
        }
        Item {
            Layout.fillWidth: true
        }
        Rectangle
        {
            Layout.alignment: Qt.AlignRight
            Layout.preferredHeight: 70 * pt
            Layout.preferredWidth: 70 * pt
        }
        Rectangle
        {
            Layout.alignment: Qt.AlignRight
            Layout.preferredHeight: 70 * pt
            Layout.preferredWidth: 70 * pt
        }
    }



}
