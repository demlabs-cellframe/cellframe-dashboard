package com.demlabs.dap;

import org.qtproject.qt5.android.bindings.QtActivity;
import android.os.Bundle;
import android.content.Context;
import android.content.Intent;
import com.demlabs.Cellframe.R;
import com.demlabs.dap.CellframeService;

public class CellframeMainActivity extends QtActivity
{
    @Override
    public void onCreate(Bundle savedInstanceState) {
        onStartService();
        super.onCreate(savedInstanceState);
    }

    public void onStartService() {
        Intent newIntent = new Intent(getApplicationContext(), CellframeService.class);
        getApplicationContext().startService(newIntent);
    }

}
