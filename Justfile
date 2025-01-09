tuist:
    zig build
    cd macos && tuist generate

dotnet:
    zig build
    cd dotnet && dotnet build
