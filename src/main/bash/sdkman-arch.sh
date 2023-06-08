#!/usr/bin/env bash

#
#   Copyright 2021 Marco Vermeulen
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#

function __sdk_arch() {
	local candidate="$1"

	if [[ -z "$candidate" ]]; then
		__sdkman_list_candidates
	else
		__sdkman_arch_versions "$candidate"
	fi
}

function __sdkman_arch_versions() {
	local candidate versions_csv

	candidate="$1"
	versions_csv="$(__sdkman_build_version_csv "$candidate")"

	__sdkman_arch_version_list "$candidate" "$versions_csv"
}

function __sdkman_arch_version_list() {
	local candidate arch

	candidate="$1"
	arch=""

	if [[ -d "${SDKMAN_CANDIDATES_DIR}/${candidate}" ]]; then
		for version in $(find "${SDKMAN_CANDIDATES_DIR}/${candidate}" -maxdepth 1 -mindepth 1 \( -type l -o -type d \) -exec basename '{}' \; | sort -r); do
			if [[ "$version" != 'current' ]]; then
				arch=$(file -b "${SDKMAN_CANDIDATES_DIR}/${candidate}/${version}/bin/java")
				__sdkman_echo_no_colour "${version}: ${arch}"
			fi
		done
		versions_csv=${versions_csv%?}
	fi
}
