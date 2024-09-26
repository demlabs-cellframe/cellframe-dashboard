import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "qrc:/widgets"

Component {
    Item{
        width: tokenView.width
        height: tokenView.heightDelegate

        Item
        {
            anchors.fill: parent
            anchors.rightMargin: 16
            anchors.leftMargin: 16

            Rectangle
            {
                id: itemRect
                anchors.fill: parent
                color: mouseArea.containsMouse ?
                           currTheme.mainButtonColorNormal0 :
                           currTheme.thirdBackground
                radius: 12
            }

            DropShadow {
                anchors.fill: itemRect
                radius: 5
                samples: 10
                horizontalOffset: 0
                verticalOffset: 4
                color: "#000000"
                opacity: 0.24
                source: itemRect
            }
            InnerShadow {
                id: shadow
                anchors.fill: itemRect
                radius: 3
                samples: 10
                horizontalOffset: 1
                verticalOffset: 1
                color: currTheme.reflection
                opacity: 0.51
                source: itemRect
            }

            RowLayout
            {
                anchors.fill: parent
                anchors.topMargin: 20
                anchors.bottomMargin: 20
                anchors.leftMargin: 16
                anchors.rightMargin: 16

                Text {
//                    Layout.fillWidth: true

                    text: tokenName
                    font: mainFont.dapFont.medium16
                    color: currTheme.white
                }

                DapBigText {
                    Layout.fillWidth: true
                    height: 20
                    fullText: value
                    textFont: mainFont.dapFont.medium16
                    textColor: currTheme.white
                    horizontalAlign: Text.AlignRight
                }

                DapImageRender{
                    Layout.alignment:  Qt.AlignRight | Qt.AlignVCenter
                    Layout.leftMargin: 16
                    id: aboutButton
                    source: "qrc:/walletSkin/Resources/" + pathTheme + "/icons/new/icon_rightChevron.svg"
                }
            }

            MouseArea
            {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked:
                {
                    tokenView.tokenIndex = index
                    selectedToken.clear()
                    var data = model
                    selectedToken.append(data)
                    dapBottomPopup.show("qrc:/walletSkin/forms/Wallets/Parts/TokenInfo.qml")
                }
            }
        }
    }
}
