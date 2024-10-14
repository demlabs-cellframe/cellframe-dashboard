package net.cellframe.wallet;

import android.content.Context;
import android.util.Log;

import org.w3c.dom.Document;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.net.MalformedURLException;
import java.net.URI;
import java.nio.charset.StandardCharsets;

public class FileUtils
{
    private static final String LOG_TAG = "NODEFILEUTILS";

    //==============================================================================================
    public static boolean copyAssetFolder(Context context, String srcName, String dstName) {
        try {
            boolean result = true;
            String fileList[] = context.getAssets().list(srcName);
            if (fileList == null) return true;

            if (fileList.length == 0) {
                result = copyAssetFile(context, srcName, dstName);
            } else {
                File file = new File(dstName);
                file.mkdirs();
                for (String filename : fileList) {
                    result &= copyAssetFolder(context, srcName + File.separator + filename, dstName + File.separator + filename);
                }
            }
            return result;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean copyAssetFile(Context context, String srcName, String dstName) {
        try {
            InputStream in = context.getAssets().open(srcName);
            File outFile = new File(dstName);
            OutputStream out = new FileOutputStream(outFile);
            byte[] buffer = new byte[1024];
            int read;
            while ((read = in.read(buffer)) != -1) {
                out.write(buffer, 0, read);
            }
            in.close();
            out.close();
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }

    //==============================================================================================
    public static void fileStream2File(InputStream input, File output_file) throws IOException
    {
        try (FileOutputStream output_stream = new FileOutputStream(output_file))
        {
            byte[] buffer = new byte[1024];

            while (true)
            {
                final int read_size = input.read(buffer);

                if (read_size <= 0)
                    break;

                output_stream.write(buffer, 0, read_size);
            }
        }
    }

    public static String readAssetToString(Context ctx, String asset) throws IOException {
        InputStream is = ctx.getResources().getAssets().open(asset);
        byte[] buffer = new byte[1024];
        ByteArrayOutputStream baos = new ByteArrayOutputStream();

        for (int length = is.read(buffer); length != -1; length = is.read(buffer)) {
            baos.write(buffer, 0, length);
        }

        is.close();
        baos.close();

        return new String(baos.toByteArray());

    }

    public static boolean writeStringToFile(String data, File file) {
        try {
            OutputStreamWriter outputStreamWriter = new OutputStreamWriter(new FileOutputStream(file));
            outputStreamWriter.write(data);
            outputStreamWriter.close();
            return true;
        }
        catch (IOException e) {
            Log.e("Exception", "File write failed: " + e.toString());
            return false;
        }
    }

    public static boolean copyFile(URI url, String dir, String name)
    {
        try
        {
            File output_file = new File(dir + "/" + name);

            if (output_file.isDirectory())
                return false;

            {
                File dir_path = output_file.getParentFile();

                if (dir_path != null)
                {
                    dir_path.mkdirs();
                }
            }

            Log.i(LOG_TAG, "copy from: " + url.toString());
            Log.i(LOG_TAG, "to: " + output_file.getAbsolutePath());

            try (InputStream input = new FileInputStream(new File(url)))
            {
                FileUtils.fileStream2File(input, output_file);
            }
        }
        catch (MalformedURLException e)
        {
            e.printStackTrace();
            return false;
        }
        catch (IOException e)
        {
            e.printStackTrace();
            return false;
        }

        return true;
    }

}
