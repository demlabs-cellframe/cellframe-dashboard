package net.demlabs.CellFrameDashboard;
import org.qtproject.qt5.android.bindings.QtActivity;

import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;

import net.demlabs.CellFrameDashboard.DashboardService;

public class MainActivity extends QtActivity
{
    public final static String LOG_TAG="Dashboard GUI";

@Override
    public void onCreate(final Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
    }

@Override
    protected void onDestroy()
    {
        super.onDestroy();
    }

    public void startService()
    {
        Log.i(LOG_TAG, "START SERVICE <JAVA -> MAIN ACTIVITY>");
        Intent intent = new Intent(getApplicationContext(), DashboardService.class);
        if (Build.VERSION.SDK_INT >= 26) {
            getApplicationContext().startForegroundService(intent);
            Log.i(LOG_TAG, "FOREGROUND <JAVA -> MAIN ACTIVITY>");
            } else {
            getApplicationContext().startService(intent);
            Log.i(LOG_TAG, "SIMPLE START <JAVA -> MAIN ACTIVITY>");
            }
    }

    public void stopService()
    {
        Log.i(LOG_TAG, "Stop service");
        getApplicationContext().stopService(new Intent(getApplicationContext(), DashboardService.class));
    }
}
