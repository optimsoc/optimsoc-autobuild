OpTiMSoC Autobuild
==================

This repository contains configuration for GitLab CI to build and test OpTiMSoC, and deploy binary artifacts to Bintray.
Builds are performed by GitLab CI Runners at the Chair of Integrated Systems (LIS) @ TUM.
All build configuration can be found in the `.gitlab-ci.yml` file.

Performed Jobs
--------------

The following jobs are performed for each pipeline run.

- `get-src-optimsoc`: Get the current `master` of OpTiMSoC and package it into a source package.
- `srctest-cocotb`: Execute all cocotb tests in the tree
- `build-base`: Build OpTiMSoC itself (without any examples).
- `build-ext-examples`: Build the Verilator simulation examples, and the "small" examples used in the tutorial (none of which need more than Vivado Webpack).
- `build-ext-spyglass`: Run Spyglass Lint on the HDL source code.
- `build-ext-compute_tile_vcu108_eightcore_usb3`: Build a `compute_tile_dm` example with eight cores and Cypress FX3 (USB3) support for the VCU108 board.
- `build-ext-system_2x2_cccc_vcu108_dualcore_usb3`: Build a 2x2 tiled system with two cores per tile for the VCU108 board
- `test`: Run all system tests in the OpTiMSoC repository. This includes tests with boot Linux on real hardware.
- `dist-nightly`: Publish the build artifacts (for nightly builds from master)
- `dist-release`: Publish the build artifacts (for tagged release builds)

Nightly Builds
--------------

The nightly builds are triggered every night by GitLab.
They build and test the current `master` branch of OpTiMSoC and upload the build artifacts to the [OpTiMSoC nightly channel on Bintray](https://bintray.com/optimsoc/nightly/).


Release Builds
---------------

Release builds can be triggered by setting the job variable `OPTIMSOC_RELEASE_TAG` to a valid git release tag, e.g. `v2016.1`.
If a release build is successful the build artifacts are uploaded to GitHub Releases, but not published.
