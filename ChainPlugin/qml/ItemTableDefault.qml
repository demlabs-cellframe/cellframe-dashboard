import QtQuick 2.8

Rectangle{
            id:itemDel
            property bool editedCell: false
            property bool selectCell: {
                if(styleData.row !== chainTable.activeCellRow || styleData.column !== chainTable.activeCellColumn || styleData.column === 0)
                    return false
                else
                    return true
            }
            border.width:1
            border.color:"#aeaeae"
            color:{if(styleData.column === 0)
                {
                    return "#e6e6e6"
                }
                else
                {if(!editedCell)return "#ffffff"
                    else return "green"
                }
            }
            Text {
                text: styleData.value
                width: parent.width
                height: parent.height
                //font.pointSize: 18
                minimumPointSize: 3
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            MouseArea {
                id:itemTable
                anchors.fill: parent
                onClicked: {
                    if(styleData.column!==0)
                    {
                        chainTable.activeCellColumn = styleData.column
                        chainTable.activeCellRow = styleData.row
                    }
                    model.currentIndex = styleData.row
                    parent.forceActiveFocus()
                }
            }
            Loader {
                id: loaderEditor
                anchors.fill: parent
                sourceComponent: selectCell ? editor : null
                Component {
                    id: editor
                    Rectangle{
                        border.color:{
                            if(selectCell) return "#23824c"
                            else return "#aeaeae"
                        }
                        border.width: {
                            if(selectCell) return 2
                            else return 1
                        }
                        color:{if(!editedCell)return "#ffffff"
                            else return "green"
                        }
                        TextInput {
                            id: textinput
                            text: styleData.value
                            width: parent.width
                            height: parent.height
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            color: "black"//styleData.textColor
                            onEditingFinished: {
                                //styleData.value = text;
                                var index_model = TableModel.index(styleData.row,styleData.column)
                                if (typeof styleData.value === 'number')
                                {
                                    if(TableModel.setData(index_model, Number(parseFloat(text).toFixed(0)), styleData.role))
                                    {editedCell = true

                                    }
                                }
                                else
                                {
                                    TableModel.setData(index_model, text, styleData.role)
                                }
                            }
                            MouseArea {
                                id: mouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: {
                                    textinput.forceActiveFocus()
                                }
                            }
                        }
                    }
                }
            }
        }
