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

Rectangle {
    id: container

    // --- properties
    property QtObject model: undefined
    property Item delegate
    //property alias suggestionsModel: filterItem.model
    //property alias filter: filterItem.filter
    //property alias property: filterItem.property
    signal itemSelected(variant item)


    // --- behaviours
    z: parent.z + 100
    visible: model.length > 0
    height: visible ? childrenRect.height : 0


    Behavior on height {
        SpringAnimation { spring: 2; damping: 0.2 }
    }


    // --- defaults
    color: currTheme.backgroundMainScreen
    radius: 16
    border {
        width: 1
        color: currTheme.lineSeparatorColor
    }


   /* Filter {
        id: filterItem
        sourceModel: container.model
    }*/

    // --- UI
    Column {
        id: popup
        clip: true
        height: childrenRect.height
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
                    visible: index == 0
                }

                Text {
                    id: textComponent
                    color: index == 0 ?  currTheme.hilightTextColorComboBox : currTheme.textColor
                    text: modelData
                    y: parent.height * 0.5 - height * 0.5
                    x: 20 * pt
                    font: mainFont.dapFont.regular16
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: container.itemSelected(delegateItem.suggestion)
                }
            }
        }
    }

}

