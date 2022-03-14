package com.Cellframe.Dashboard;

public class JNIConnector {
    private static native void callFromJava(String message);

    public JNIConnector() {}

    public static void printFromJava(String message)
    {
        System.out.println("This is printed from JAVA, message is: " + message);
        callFromJava("Hello from JAVA!");
    }
}
