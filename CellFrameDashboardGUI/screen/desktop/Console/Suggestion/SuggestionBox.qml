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

import QtQuick 2.0

Image {
    id: container

    // --- properties
    property var model: ({})
    property Item delegate
    signal itemSelected(variant item)
    signal wordSelected(var word)
    source: "qrc:/resources/icons/ui_menu_light.png"

    property int selectedIndex: 0
    property int maxLenIndex: 0

    Component.onCompleted:
    {
        console.log("yyyyyyyyyyyyyyyy", visible, model.length)
        model = {}
    }

    onModelChanged:
    {
        selectedIndex = 0
        maxLenIndex = commandCmdController.maxLengthText(model)
    }

    // --- behaviours
    z: parent.z + 100
    visible: model.length > 0
    height: model.length * 25 < 200 * pt ? model.length * 25 : 200 * pt


    // --- UI
    property int flickContY: 0

    onSelectedIndexChanged:
    {
        if (selectedIndex == model.length - 1)
            flickContY = model.length * 25 * pt - height
        else
        if (selectedIndex == 0)
            flickContY = 0
        else
        if (selectedIndex * 25 > flickContY + height - 25 * pt)
            flickContY += 25 * pt
        else
        if (selectedIndex * 25 - 25 * pt < flickContY)
            flickContY -= 25 * pt
    }

    Flickable
    {
        anchors.fill: parent
        contentHeight: container.model.length * 25
        clip: true
        contentY: flickContY
    Column {
        id: popup
        clip: true
        height: model.length * 25
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

                height: 25 * pt
                width: container.width

                Rectangle
                {
                    radius: 16
                    width: textComponent.width + 18
                    height: textComponent.height
                    x: textComponent.x - 9
                    y: textComponent.y
                    color: currTheme.hilightColorComboBox
                    visible: index == selectedIndex
                }

                Text {
                    id: textComponent
                    color: index == selectedIndex ?  currTheme.hilightTextColorComboBox : currTheme.textColor
                    text: modelData.word
                    y: parent.height * 0.5 - height * 0.5
                    x: 20 * pt
                    font: mainFont.dapFont.regular16

                    Component.onCompleted:
                    {
                        if (maxLenIndex == index)
                            container.width = width + 50 * pt
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: container.wordSelected(modelData.str)
                }
            }
        }
        }
    }

}
