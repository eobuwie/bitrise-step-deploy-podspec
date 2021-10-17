#!/bin/bash
set -x

pod repo add ${repo_name} ${podspec_repo_url}

cat ${podspec}

pod repo push ${repo_name} ${podspec} --skip-tests --skip-import-validation --allow-warnings --sources=${podspec_sources}
