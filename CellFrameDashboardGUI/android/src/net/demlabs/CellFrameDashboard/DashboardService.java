package net.demlabs.CellFrameDashboard;
import org.qtproject.qt5.android.bindings.QtService;

import android.util.Log;

public class DashboardService extends QtService {
    private static final String TAG = "Dashboard service";

    @Override
    public void onCreate() {
        super.onCreate();
        Log.i(TAG, "CREATING SERVICE <JAVA -> Dashboard service>");
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        Log.i(TAG, "DESTROYING SERVICE <JAVA -> Dashboard service>");
    }
}
