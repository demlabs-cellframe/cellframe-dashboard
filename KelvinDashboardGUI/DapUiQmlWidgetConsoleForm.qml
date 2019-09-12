import QtQuick 2.13

TextEdit {
    property int positionLine: 2

    id: txtCommands
    anchors.fill: parent

    text: "> "
    wrapMode: TextEdit.WordWrap

    Keys.onPressed: {

        switch(event.key)
        {
        case Qt.Key_Backspace:
            event.accepted = (txtCommands.cursorPosition <= txtCommands.positionLine);
            return;
        default: break;
        }
    }

    Keys.onUpPressed: {
        if(txtCommands.positionLine != txtCommands.text.length)
            txtCommands.remove(txtCommands.positionLine, txtCommands.text.length);
        txtCommands.text += dapConsoleController.getCommandUp();
    }

    Keys.onDownPressed: {
        if(txtCommands.positionLine != txtCommands.text.length)
            txtCommands.remove(txtCommands.positionLine, txtCommands.text.length);
        txtCommands.text += dapConsoleController.getCommandDown();
    }

    Keys.onReturnPressed: {
        txtCommands.readOnly = true;
        dapConsoleController.receiveRequest(txtCommands.text.slice(positionLine, txtCommands.text.length));
    }

    onCursorPositionChanged: {
        if(txtCommands.cursorPosition <= txtCommands.positionLine) {
            txtCommands.cursorPosition = txtCommands.positionLine;
        }
    }

    Connections {
        target: dapConsoleController
        onSendResponse: {
            txtCommands.readOnly = false;
            txtCommands.append(response);
            txtCommands.append("> ");
            txtCommands.positionLine = txtCommands.cursorPosition;
        }
    }
}

