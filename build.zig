const std = @import("std");
const buildpkg = @import("buildpkg/main.zig");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    if (target.result.isDarwin()) {
        // Create static libraries for aarch64 and x86_64
        const static_lib_aarch64 = b.addStaticLibrary(.{
            .name = "mylib",
            .root_source_file = b.path("src/root.zig"),
            .target = b.resolveTargetQuery(.{
                .cpu_arch = .aarch64,
                .os_tag = .macos,
            }),
            .optimize = optimize,
        });

        b.installArtifact(static_lib_aarch64);

        const static_lib_x86_64 = b.addStaticLibrary(.{
            .name = "mylib",
            .root_source_file = b.path("src/root.zig"),
            .target = b.resolveTargetQuery(.{
                .cpu_arch = .x86_64,
                .os_tag = .macos,
            }),
            .optimize = optimize,
        });

        b.installArtifact(static_lib_x86_64);

        // Create the universal static library
        const static_lib_universal = buildpkg.LipoStep.create(b, .{
            .name = "mylib",
            .out_name = "libmylib.a",
            .input_a = static_lib_aarch64.getEmittedBin(),
            .input_b = static_lib_x86_64.getEmittedBin(),
        });
        static_lib_universal.step.dependOn(&static_lib_aarch64.step);
        static_lib_universal.step.dependOn(&static_lib_x86_64.step);

        // Create the XCFramework
        const xcframework = buildpkg.XCFrameworkStep.create(b, .{
            .name = "MylibKit",
            .out_path = "macos/MylibKit.xcframework",
            .libraries = &[_]buildpkg.XCFrameworkStep.Library{
                .{
                    .library = static_lib_universal.output,
                    // This is the path to the headers that will be included in the XCFramework
                    .headers = b.path("include"),
                },
            },
        });
        xcframework.step.dependOn(static_lib_universal.step);
        b.default_step.dependOn(xcframework.step);
    }

    // Since GhosttyKit from C# runs anywhere, we can just always create the shared library
    // TODO: hide the different libraries behind different flags
    const shared_lib = b.addSharedLibrary(.{
        .name = "mylib",
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(shared_lib);

    // Creates a step for unit testing. This only builds the test executable
    // but does not run it.
    const lib_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);

    // Similar to creating the run step earlier, this exposes a `test` step to
    // the `zig build --help` menu, providing a way for the user to request
    // running the unit tests.
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_lib_unit_tests.step);
}
