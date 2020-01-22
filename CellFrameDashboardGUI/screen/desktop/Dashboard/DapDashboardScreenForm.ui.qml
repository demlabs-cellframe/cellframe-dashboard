import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.2
import "qrc:/widgets"
import "../../"

DapAbstractScreen
{
    id: dapdashboard
    dapFrame.color: "#FFFFFF"
    textTest.text: "Here text"
    anchors.fill: parent
    anchors.leftMargin: 24 * pt
    anchors.rightMargin: 24 * pt

    property string bitCoinImage: "qrc:/res/icons/tkn1_icon_light.png"
    property string ethereumImage: "qrc:/res/icons/tkn2_icon.png"
    property string newGoldImage: "qrc:/res/icons/ng_icon.png"
    property string kelvinImage: "qrc:/res/icons/ic_klvn.png"

    property alias walletNameEditButton: _walletNameEditButton
    property alias walletNameEditButtonArea: _walletNameEditButtonArea

    Rectangle
    {
        id: title
        anchors.top: parent.top
        anchors.topMargin: 20 * pt
        anchors.bottomMargin: 20 * pt
        anchors.left: parent.left
        anchors.right: parent.right
        height: 36 * pt

        RowLayout
        {
            anchors.fill: parent

            Text
            {
                font.pixelSize: 20 * pt
                font.family: "Roboto"
                font.styleName: "Normal"
                font.weight: Font.Normal
                text: "My first wallet"
            }

            Image
            {
                id: _walletNameEditButton
                property bool isHovered: false
                width: 20 * pt
                height: 20 * pt
                source: isHovered ? "qrc:/res/icons/ic_edit_hover.png" : "qrc:/res/icons/ic_edit.png"
                sourceSize.width: width
                sourceSize.height: height

                MouseArea
                {
                    id: _walletNameEditButtonArea
                    anchors.fill: parent
                    hoverEnabled: true
                }
            }

            Item
            {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            DapButton
            {
                widthButton: 132 * pt
                heightButton: 36 * pt
                textButton: "New payment"
                colorBackgroundButton: "#3E3853"
                colorBackgroundHover: "red"
                colorButtonTextNormal: "#FFFFFF"
                colorButtonTextHover: "#FFFFFF"
                normalImageButton: "qrc:/res/icons/new-payment_icon.png"
                hoverImageButton: "qrc:/res/icons/new-payment_icon.png"
                widthImageButton: 20 * pt
                heightImageButton: 20 * pt
                indentImageLeftButton: 20 * pt
                indentTextRight: 20 * pt
            }
        }
    }

    ListView
    {
        anchors.top: title.bottom
        anchors.topMargin: 20 * pt
        anchors.bottom: parent.bottom
        width: parent.width
        spacing: 5 * pt
        clip: true
        model: 10
        delegate: _delegate

    }
}
