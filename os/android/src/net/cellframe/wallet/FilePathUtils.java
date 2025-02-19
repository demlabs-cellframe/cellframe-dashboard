package net.cellframe.wallet;
import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.webkit.MimeTypeMap;
import android.provider.OpenableColumns;

public class FilePathUtils {

    public static String getFileName(Uri uri, Context context) {
        String fileName = getFileNameFromCursor(uri, context);
//        String fileName = "hello";

        if (fileName == null) {
            String fileExtension = getFileExtension(uri, context);
            fileName = "temp_file" + (fileExtension != null ? "." +
                                                        fileExtension : "");
        } else if (!fileName.contains(".")) {
            String fileExtension = getFileExtension(uri, context);
            fileName = fileName + "." + fileExtension;
        }

        return fileName;
    }

    public static String getFileExtension(Uri uri, Context context) {
        String fileType = context.getContentResolver().getType(uri);
        return MimeTypeMap.getSingleton().getExtensionFromMimeType(fileType);
    }

    public static String getFileNameFromCursor(Uri uri, Context context) {
        Cursor fileCursor = context.getContentResolver().query(uri, new String[]
                               {OpenableColumns.DISPLAY_NAME}, null, null, null);
        String fileName = null;
        if (fileCursor != null && fileCursor.moveToFirst()) {
            int cIndex = fileCursor.getColumnIndex(OpenableColumns.DISPLAY_NAME);
            if (cIndex != -1) {
                fileName = fileCursor.getString(cIndex);
            }
        }
        return fileName;
    }
}
