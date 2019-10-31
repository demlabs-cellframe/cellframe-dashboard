package com.demlabs.dap;

import org.qtproject.qt5.android.bindings.QtService;
import android.content.Context;
import android.content.Intent;

public class CellframeService extends QtService {

    public static void onStartService(Context context) {
        Intent intent = new Intent(context, CellframeService.class);
        context.startService(intent);
    }
}
