#!/bin/bash
# Upload a nightly build to Bintray
#
# Environment variables
#
# BUILDINFO_GIT_COMMIT
#   Git commit hash
#
# BUILDINFO_NIGHTLY_VERSION
#   Nightly version string (YYYY-MM-DD-HH-MM-SS)
#
# OPTIMSOC_VERSION
#   OpTiMSoC version to be uploaded
#
# BINTRAY_USER
#   Bintray username
#
# BINTRAY_API_KEY
#   Bintray API key

# Check environment
[ -z "$BUILDINFO_GIT_COMMIT" ] && echo 'BUILDINFO_GIT_COMMIT not set.' >&2 && exit 1
[ -z "$BUILDINFO_NIGHTLY_VERSION" ] && echo 'BUILDINFO_NIGHTLY_VERSION not set.' >&2 && exit 1
[ -z "$OPTIMSOC_VERSION" ] && echo 'OPTIMSOC_VERSION not set.' >&2 && exit 1
[ -z "$BINTRAY_USER" ] && echo 'BINTRAY_USER not set.' >&2 && exit 1
[ -z "$BINTRAY_API_KEY" ] && echo 'BINTRAY_API_KEY not set.' >&2 && exit 1

BUILD_DESC="OpTiMSoC nightly build created on $BUILDINFO_NIGHTLY_VERSION from commit $BUILDINFO_GIT_COMMIT"

# Install and configure JFrog CLI
# Documentation: https://www.jfrog.com/confluence/display/CLI/CLI+for+JFrog+Bintray
curl -sfL https://getcli.jfrog.io | sh >/dev/null

./jfrog bt config --user=$BINTRAY_USER --key=$BINTRAY_API_KEY --licenses MIT

# Upload
for pkg in src base examples examples-ext; do
    ./jfrog bt version-create --vcs-tag="$BUILDINFO_GIT_COMMIT" --desc="$BUILD_DESC" "optimsoc/nightly/optimsoc-$pkg/$OPTIMSOC_VERSION"
    ./jfrog bt upload --publish optimsoc-*-$pkg.tar.gz optimsoc/nightly/optimsoc-$pkg/$OPTIMSOC_VERSION
done

# Cleanup
rm jfrog
