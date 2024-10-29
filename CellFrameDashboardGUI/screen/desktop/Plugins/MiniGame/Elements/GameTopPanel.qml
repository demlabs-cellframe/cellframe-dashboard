import QtQuick 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5

ColumnLayout {

    ProgressBar
    {
        Layout.topMargin: 10 
        Layout.preferredWidth: 300 
        Layout.preferredHeight: 60 
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
        Layout.leftMargin: 10 
        Layout.rightMargin: 10 
        spacing: 10 

        Rectangle
        {
            Layout.alignment: Qt.AlignLeft
            Layout.preferredHeight: 70 
            Layout.preferredWidth: 70 
        }
        Item {
            Layout.fillWidth: true
        }
        Rectangle
        {
            Layout.alignment: Qt.AlignRight
            Layout.preferredHeight: 70 
            Layout.preferredWidth: 70 
        }
        Rectangle
        {
            Layout.alignment: Qt.AlignRight
            Layout.preferredHeight: 70 
            Layout.preferredWidth: 70 
        }
    }



}
