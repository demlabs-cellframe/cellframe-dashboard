package com.demlabs;
import org.qtproject.qt5.android.bindings.QtService;

import android.util.Log;

public class DashboardService extends QtService
{
    private static final String TAG = "DashboardService";

    @Override
    public void onCreate() {
        super.onCreate();
        Log.i(TAG, "CREATING SERVICE <JAVA -> DashboardService>");
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        Log.i(TAG, "Destroying Service");
    }
}
