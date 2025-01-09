# zig-native-apps

This is a proof-of-concept for building apps with native UI backed by business code in zig.

See Also: [Integrating Zig and SwiftUI](https://mitchellh.com/writing/zig-and-swiftui)

# Windows

The Windows solution is a fair bit simpler than originally thought. 
It works by calling `zig build` before the main build step in MSBuild and then telling MSBuild to included the generate files with the assembly.
Then, the zig functions can be called via `DllImport`. 

`MylibKit` is the project containing the zig build logic and the static extern functions. 
It is then consumed by `MyApp`, so that all `MyApp` sees is a set of static C# functions. 
The build logic and extern functions could just be written in `MyApp`, but this provides a clean seperation 
and mimics some of the naming from the intended macOS solution. 

## MylibKit.Tests

`MylibKit.Tests` runs some quick tests to ensure the library is imported properly. 
It's pretty redundant, but it's nice to have to run and quickly verify everything works.

## Crossplatform MylibKit

`MylibKit` is actually cross platform! 
If you wanted, you could write crossplatform UI with .NET MAUI or Avalonia, but it wouldn't be native UI.