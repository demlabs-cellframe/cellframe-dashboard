/*
    Copyright (C) 2011 Jocelyn Turcotte <turcotte.j@gmail.com>

    This program is free software; you can redistribute it and/or
    modify it under the terms of the GNU Library General Public
    License as published by the Free Software Foundation; either
    version 2 of the License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Library General Public License for more details.

    You should have received a copy of the GNU Library General Public License
    along with this program; see the file COPYING.LIB.  If not, write to
    the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
    Boston, MA 02110-1301, USA.
*/

import QtQuick 2.4

Image {
    id: container

    // --- properties
    property var model: ({})
    property Item delegate
    signal itemSelected(variant item)
    signal wordSelected(var word)
    source: "qrc:/Resources/ui_menu_light.png"

    property int selectedIndex: 0
    property int maxLenIndex: 0
    property int maxWidth: 500
    property int itemHeight: 24

    Component.onCompleted:
    {
        model = {}
    }

    onModelChanged:
    {
        selectedIndex = 0
    }

    // --- behaviours
    z: parent.z + 100
    visible: model.length > 0
    height: model.length * itemHeight < 240 * pt ? model.length * itemHeight : 240 * pt


    // --- UI
    property int flickContY: 0

    onSelectedIndexChanged:
    {
        if (selectedIndex == model.length - 1)
            flickContY = model.length * itemHeight * pt - height
        else
        if (selectedIndex == 0)
            flickContY = 0
        else
        if (selectedIndex * itemHeight > flickContY + height - itemHeight * pt)
            flickContY += itemHeight * pt
        else
        if (selectedIndex * itemHeight - itemHeight * pt < flickContY)
            flickContY -= itemHeight * pt
    }

    Flickable
    {
        anchors.fill: parent
        contentHeight: container.model.length * itemHeight
        clip: true
        contentY: flickContY
    Column {
        id: popup
        clip: true
        height: model.length * itemHeight
        width: parent.width - 6
        anchors.centerIn: parent


        property int selectedIndex
        property variant selectedItem: selectedIndex == -1 ? null : model[selectedIndex]
        signal suggestionClicked(variant suggestion)

        opacity: container.visible ? 1.0 : 0
        Behavior on opacity {
            NumberAnimation { }
        }
        Repeater {
            id: repeater
            model: container.model
            delegate: Item {
                id: delegateItem
                property variant suggestion: model

                height: itemHeight
                width: container.width

                Rectangle
                {
                    anchors.fill: parent
                    color: currTheme.lime
                    visible: index === selectedIndex
                    radius: 1
                }

                Text {
                    id: textComponent
                    color: index === selectedIndex ?  currTheme.boxes : currTheme.white
                    text: modelData
                    y: parent.height * 0.5 - height * 0.5 - 1
                    x: 10
                    font: mainFont.dapFont.regular14

                    Component.onCompleted:
                    {
                        if (maxLenIndex === index) {
                            container.width = x + getStrWidth() + x + 7
                        }
                    }

                    function getStrWidth()
                    {
                        var maxStr = container.model[maxLenIndex]
                        var widthStr = metrics.boundingRect(maxStr).width

                        if(maxWidth < widthStr) widthStr = maxWidth

                        return widthStr
                    }
                }

                FontMetrics {
                    id: metrics
                    font: textComponent.font
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: container.wordSelected(modelData)
                }
            }
        }
        }
    }

}
