package com.Cellframe.Dashboard;
import java.io.DataOutputStream;
import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import android.content.ContentResolver;
import android.content.Context;
import android.database.Cursor;
import android.net.Uri;
import android.provider.MediaStore;
import java.util.ArrayList;

public class TCPServer {
    public static final int SERVER_PORT = 50001;

    public static void main(String[] args) {

        try {
            ServerSocket server = new ServerSocket(SERVER_PORT);
            Socket clientConn = server.accept();
            DataOutputStream serverOutput = new DataOutputStream(clientConn.getOutputStream());
            serverOutput.writeBytes("Java revisited\n");
            clientConn.close();
        } catch (IOException e) {
            e.printStackTrace();
        }

    }
}
