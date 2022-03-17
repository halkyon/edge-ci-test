#!/usr/bin/env bash
set -euo pipefail

# this was copied from mint release.sh and modified to ensure we don't
# unnecessarily build tests we don't need, and don't run anyway. some of
# these skipped tests also fail to build due to the image differences of
# the edge CI container that's based off debian, whereas mint is
# based off ubuntu.

export MINT_ROOT_DIR=${MINT_ROOT_DIR:-/mint}
export MINT_RUN_CORE_DIR="$MINT_ROOT_DIR/run/core"
export MINT_RUN_BUILD_DIR="$MINT_ROOT_DIR/build"
export WGET="wget --quiet --no-check-certificate"

"${MINT_ROOT_DIR}"/create-data-files.sh

for pkg in "$MINT_ROOT_DIR/build"/*/install.sh; do
	test=$(basename "$(dirname "$pkg")")

	# we don't run these tests, so don't bother building them.
	if [ "$test" == "healthcheck" ] || \
		[ "$test" == "mc" ] || \
		[ "$test" == "minio-dotnet" ] || \
		[ "$test" == "minio-java" ] || \
		[ "$test" == "minio-js" ] || \
		[ "$test" == "minio-py" ] || \
		[ "$test" == "versioning" ]
	then
		echo "Skipping $pkg"
		continue
	fi

    echo "Running $pkg"
    $pkg
done
