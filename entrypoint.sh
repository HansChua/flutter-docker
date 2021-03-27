#!/bin/sh

if [ "$INPUT_FAIL_ON_ERROR" = true ] ; then
  set -o pipefail
fi

if [ "$INPUT_RELATIVE" = true ] ; then
  export RELATIVE=--relative
fi

cd "$GITHUB_WORKSPACE"

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

echo Flutter version: "$(flutter --version)"
echo dartcop version: "$(dartcop --version)"

echo "$(<analysis_options.yaml )"

dartcop --options analysis_options.yaml . \
  | reviewdog -f=checkstyle -name="ktlint" -reporter="${INPUT_REPORTER}" -filter-mode="${INPUT_FILTER_MODE}" -level="${INPUT_LEVEL}"
