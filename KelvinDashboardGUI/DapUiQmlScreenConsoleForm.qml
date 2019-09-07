import QtQuick 2.9
import QtQml 2.12
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.12

Page {
    TextEdit {
        id: txtCommands
        property int positionLine: 2
        anchors.fill: parent

        text: "> "
        wrapMode: TextEdit.WordWrap

        onTextChanged: {
            if(txtCommands.cursorPosition === txtCommands.positionLine)
            {
                txtCommands.text += " ";
                txtCommands.cursorPosition = txtCommands.text.length
            }
        }

        function acceptedResopose(responce)
        {
            txtCommands.readOnly = false;
            txtCommands.append(responce);
            txtCommands.append("> ");
            console.debug(txtCommands.positionLine);
            console.debug(txtCommands.cursorPosition);
            txtCommands.positionLine = txtCommands.cursorPosition + 1;
        }

        Keys.onPressed: {

            switch(event.key)
            {
            case Qt.Key_Up: console.debug("UP"); break;
            case Qt.Key_Down: console.debug("Down"); break;
            default: break;
            }
        }

        Keys.onReturnPressed: {
            console.debug("ENTER");
            txtCommands.readOnly = true;
            acceptedResopose("New resp");
        }
    }
}
