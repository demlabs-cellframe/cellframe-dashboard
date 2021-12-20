package net.demlabs.CellFrameDashboard;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import org.qtproject.qt5.android.bindings.QtService;

public class DashboardService extends QtService {
    private static final String TAG = "MyService1";

       @Override
       public void onCreate() {
           super.onCreate();
           Log.i(TAG, "Creating Service");
       }

       @Override
       public void onDestroy() {
           super.onDestroy();
           Log.i(TAG, "Destroying Service");
       }

       @Override
       public int onStartCommand(Intent intent, int flags, int startId) {
           int ret = super.onStartCommand(intent, flags, startId);
           return ret;
       }

   public static void startDashboardService(Context ctx) {
       ctx.startService(new Intent(ctx, DashboardService.class));
       Log.i(TAG, "DO SOME WORK");
   }
}
