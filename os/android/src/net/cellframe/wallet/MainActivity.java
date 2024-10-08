package net.cellframe.wallet;
import org.qtproject.qt5.android.bindings.QtApplication;
import org.qtproject.qt5.android.bindings.QtActivity;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import android.content.Context;
import android.content.BroadcastReceiver;
import android.content.IntentFilter;
import android.app.Activity;
import android.Manifest;
import com.cellframe.node.INodeServiceInterface;
import com.cellframe.node.INodeNotifyListner;

import android.content.ComponentName;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.Bundle;
import android.os.IBinder;
import android.os.RemoteException;

public class MainActivity extends QtActivity
{
    private String TAG = "CellframeWallet";
    private boolean doesNodeInstalled = false;

    private void startServiceAndTryBind()
    {
        Intent intent = new Intent();
        intent.setComponent(new ComponentName("com.cellframe.node", "com.cellframe.node.NodeService"));
        if (startForegroundService(intent) != null) {
            Log.d(TAG,"Service exists");
            doesNodeInstalled = true;
        }
        else {
            Log.d(TAG,"Service not exists");
            doesNodeInstalled = false;
        }

        Log.d(TAG, "Goint to bind:"+String.valueOf(doesNodeInstalled));

        if (doesNodeInstalled)
            bindToService();
    }

    @Override
    public void onCreate(final Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        Log.d(TAG,"MainActivity created.");

        Log.d(TAG,"Starting Node Service");
        startServiceAndTryBind();
    }

    @Override
    protected void onDestroy()
    {
        super.onDestroy();
    }

    public String getExtFilesDir()
    {
        return getExternalFilesDir(null).getPath();
    }

    public boolean isNodeServicePresent() {
        if (!doesNodeInstalled) { //check, probably somthing changes since activity started
           startServiceAndTryBind();
        }
        return doesNodeInstalled;
    }
    
    public boolean isNodeServiceReady() throws RemoteException{ 
        return doesNodeInstalled && nodeService != null;
    }

    public boolean isNodeServiceRunning() throws RemoteException { 
        if (isNodeServiceReady()) return nodeService.isNodeRunning();
        return false;
    }



    public boolean startNode() throws RemoteException { 
        if  (isNodeServiceReady()) return nodeService.startNode();
        return false;
    }

    public boolean stopNode() throws RemoteException { 
        if (isNodeServiceReady()) return nodeService.stopNode();
        return false;
    }

    public String nodeConfig(String req) throws RemoteException { 
        if (isNodeServiceReady()) return nodeService.config(req);
        return false;
    }

    private void bindToService() {
        try {
            Intent intent = new Intent();
            intent.setComponent(new ComponentName("com.cellframe.node", "com.cellframe.node.NodeService"));
            bindService(intent, nodeServiceConnection, BIND_AUTO_CREATE);
        } catch (Exception e) {
            Log.i(TAG, "e: " + e.getMessage());
            Log.d(TAG, "[!!] Error connecting to service.");
        }
    }

    private INodeServiceInterface nodeService = null;
    private ServiceConnection nodeServiceConnection = new ServiceConnection() {
        @Override
        public void onServiceConnected(ComponentName componentName, IBinder iBinder) {
            Log.i(TAG, "onServiceConnected");
            try {
                Log.d(TAG, "[*] Connected to CellframeNode Service");

                nodeService = INodeServiceInterface.Stub.asInterface(iBinder);
                Log.d(TAG, "[*] Node runnung: " + String.valueOf(nodeService.isNodeRunning()));
                nodeService.setNotifyLisnter(new INodeNotifyListner.Stub() {
                    @Override
                    public void onNotify(final String notification_data) throws RemoteException {
                        runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                Log.d(TAG, "[N]: " + notification_data);
                            }
                        });
                    }


                });
            }catch ( Exception e) {
                Log.i(TAG, "onServiceConnected error: " + e.getMessage());
                Log.d(TAG, "[*] Error connecting to CellframeNode service");
            }
        }

        @Override
        public void onServiceDisconnected(ComponentName componentName) {
            Log.d(TAG, "[!] Disconnected from cellframe-node-service");
            nodeService = null;
        }
    };
}
