import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0
import Qt.labs.settings 1.0
import QtQuick.Layouts 1.3
import "qrc:/widgets"

Page{
    title: qsTr("Coming Soon")
    background: Rectangle {color: currTheme.mainBackground}
    hoverEnabled: true

    RowLayout{
        anchors.fill: parent

        DapImageRender {
            id: under_cunstruct_img
            Layout.preferredWidth: 200
            Layout.preferredHeight: 100

            Layout.alignment: Qt.AlignCenter


            source: "qrc:/walletSkin/Resources/" + pathTheme + "/Illustratons/comingsoon_illustration.svg"
            fillMode: Image.PreserveAspectFit
            sourceSize.width: 200
            sourceSize.height: 100

            ColorOverlay {
                id: overlay
                anchors.fill: under_cunstruct_img
                source: under_cunstruct_img
                color: "#FFFF0000"
                visible: false
              }
        }
    }
}
