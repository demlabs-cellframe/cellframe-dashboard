package com.Cellframe.Dashboard;
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

import com.Cellframe.Dashboard.DashboardService;

public class DashboardActivity extends QtActivity
{
@Override
    public void onCreate(final Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
    }

@Override
    protected void onDestroy()
    {
        stopService();
        super.onDestroy();
    }

    public void stopService()
    {
        getApplicationContext().stopService(new Intent(getApplicationContext(), DashboardService.class));
    }

    public String getExtFilesDir()
    {
        return getExternalFilesDir(null).getPath();
    }
}
