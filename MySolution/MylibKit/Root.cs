using System.Runtime.InteropServices;

namespace MylibKit;

public static class Root
{
    [DllImport("mylib")]
    public static extern int add(int a, int b);
}