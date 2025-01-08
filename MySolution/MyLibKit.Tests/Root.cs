namespace MyLibKit.Tests;

using static MylibKit.Root;

public class Root
{
    [Fact]
    public void BasicAddFunctionality()
    {
        Assert.Equal(10, add(3, 7));
    }
}