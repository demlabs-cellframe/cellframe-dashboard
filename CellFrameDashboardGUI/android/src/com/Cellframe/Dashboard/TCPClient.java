package com.Cellframe.Dashboard;
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.Socket;
import android.content.ContentResolver;
import android.content.Context;
import android.database.Cursor;
import android.net.Uri;
import android.provider.MediaStore;
import java.util.ArrayList;

public class TCPClient {
    public void sendRequest(Context context) {
        try {
            Socket clientSocket = new Socket ("localhost",8079);
            InputStream is = clientSocket.getInputStream();
            BufferedReader br = new BufferedReader(new InputStreamReader(is));
            String receivedData = br.readLine();
            System.out.println("Received Data: "+receivedData);
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        }
}
