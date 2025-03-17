import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

ProgressBar {
    id: progressBar
    maximumValue: 100
    minimumValue: 0

    style: ProgressBarStyle {
        background: Rectangle {
            radius: 3
            color: "#ffffff"
            implicitWidth: 80
            implicitHeight: 10
        }
        progress: Rectangle {
            color: progressBar.value < 40 ? currTheme.lightGreen
                 : progressBar.value < 80 ? currTheme.orange
                                          : currTheme.red
            radius: 2
        }
    }
}
