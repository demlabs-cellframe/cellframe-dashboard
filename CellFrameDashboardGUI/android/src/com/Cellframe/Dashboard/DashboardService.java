package com.Cellframe.Dashboard;
import org.qtproject.qt5.android.bindings.QtService;
import org.qtproject.qt5.android.bindings.QtApplication;
import android.content.Context;
import android.content.Intent;
import android.app.Activity;
import android.app.ActivityManager;
import android.app.PendingIntent;
import android.app.Service;
import android.os.Build;
import android.os.Bundle;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.NotificationChannel;
import android.support.v4.app.NotificationCompat;
import android.util.Log;

public class DashboardService extends QtService
{
    public static NotificationChannel channel;

@Override
    public void onCreate()
    {
        super.onCreate();
        String CHANNEL_ID = "cellchannel";
        channel = new NotificationChannel(CHANNEL_ID, "Cell Notifier", NotificationManager.IMPORTANCE_DEFAULT);
        ((NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE)).createNotificationChannel(channel);
        Intent nIntent = new Intent(getApplicationContext(), DashboardActivity.class);
        PendingIntent pIntent = PendingIntent.getActivity(getApplicationContext(), 0, nIntent, 0);
        Notification notification = new NotificationCompat.Builder(this, CHANNEL_ID).setContentTitle("")
        .setContentText("Dashboard is running").setAutoCancel(true).setOngoing(true).setSmallIcon(R.drawable.icon_bar).setContentIntent(pIntent).build();
        startForeground(8, notification);
        Log.i("!!!", "Service started");
    }

@Override
    public void onDestroy()
    {
        super.onDestroy();
    }

    public String getExtFilesDir()
    {
        return getExternalFilesDir(null).getPath();
    }
}

