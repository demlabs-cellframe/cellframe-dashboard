import QtQuick 2.4
import QtQml 2.12
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import "qrc:/widgets"
import "../logic"

//Transaction list delegate.
Component
{
    ItemDelegate
    {
        anchors.left: parent.left
        anchors.right: parent.right
        height: 27 * pt

        Text
        {
            id: timeExchangeHistory
            text: time
            color: currTheme.textColor
            font.family:  mainFont.dapFont.regular12
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: 8 * pt
            width: 87 * pt
        }

        Text
        {
            id: statusExchangeHistory
            text: status
            color:
            {
                if(status === "Buy")
                    return "#4B8BEB"
                else
                    return "#6F9F00"
            }
            font.family:  mainFont.dapFont.regular10
            anchors.left: timeExchangeHistory.right
            anchors.leftMargin: 20 * pt
            anchors.top: parent.top
            anchors.topMargin: 8 * pt
            width: 42 * pt
        }

        Text
        {
            id: priceExchangeHistory
            text: price
            color: currTheme.textColor
            font.family:  mainFont.dapFont.regular11
            anchors.left: statusExchangeHistory.right
            anchors.leftMargin: 20 * pt
            anchors.top: parent.top
            anchors.topMargin: 8 * pt
            width: 104 * pt
        }

        Text
        {
            id: tokenExchangeHistory
            text: token
            color: currTheme.textColor
            font.family:  mainFont.dapFont.regular11
            anchors.left: priceExchangeHistory.right
            anchors.leftMargin: 20 * pt
            anchors.top: parent.top
            anchors.topMargin: 8 * pt
            width: 117 * pt
        }

        Rectangle
        {
            id:lineBottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 1 * pt
            visible:
            {
                if(index < modelExchangeHistory.count - 1)
                    return true;
                else
                    return false;
            }
            color: currTheme.lineSeparatorColor
        }
    }

}

