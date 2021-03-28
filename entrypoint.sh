#!/bin/sh

if [ "$INPUT_FAIL_ON_ERROR" = true ] ; then
  set -o pipefail
fi

cd "$GITHUB_WORKSPACE"

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

echo Flutter version: "$(flutter --version)"
echo dartcop version: "$(dartcop --version)"

"$(dartcop --options analysis_options.yaml .)"

cat output_checkstyle.xml | reviewdog -f=checkstyle -name="dartanalyzer" -reporter="${INPUT_REPORTER}" -filter-mode="${INPUT_FILTER_MODE}" -level="${INPUT_LEVEL}"
