import QtQuick 2.7
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.7
import QtQuick.Layouts 1.2

import "qrc:/widgets"

DapRectangleLitAndShaded {
    id: cell

    contentData:
    Item {
        anchors.fill: parent

        Rectangle {
            id: headerFrame

            width: parent.width
            height: 30

            LinearGradient
            {
                anchors.fill: parent
                source: parent
                start: Qt.point(0,parent.height/2)
                end: Qt.point(parent.width,parent.height/2)
                gradient:
                    Gradient {
                        GradientStop
                        {
                            position: 0;
                            color: cell.GridView.isCurrentItem ? currTheme.mainButtonColorHover0 :
                                                       currTheme.mainBackground
                        }
                        GradientStop
                        {
                            position: 1;
                            color: cell.GridView.isCurrentItem ? currTheme.mainButtonColorHover1 :
                                                       currTheme.mainBackground

                        }
                    }
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 16
                font:  mainFont.dapFont.medium12
                elide: Text.ElideRight
                color: currTheme.white
                text: (logicOrders.currentTabTechName + qsTr(" Order ") + model.index)
            }

            Image {
                id: orderIcon
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 16
                mipmap: true
                source: "qrc:/Resources/"+ pathTheme +"/icons/other/ic_info.svg"
            }
        }

        MouseArea {
            anchors.fill: parent

            onClicked: {
                cell.forceActiveFocus();
                if(control.currentIndex === index)
                   control.currentIndex = -1
                else
                {
                    control.currentIndex = index;

                    logicOrders.initDetailsModel(model)
                    navigator.orderInfo()
//                    orderDetailsShow(model.index)
                }
            }
        }
    }
}
