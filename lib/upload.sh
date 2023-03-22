#!/bin/bash

upload() {
  local API_KEY=$1
  local FILE_TO_UPLOAD="$2"

  if [ "${BUILDKITE_COMMAND_EXIT_STATUS:-0}" = "0" ]; then
    BUILD_STATUS="${3:-success}"
  else
    BUILD_STATUS="${3:-failure}"
  fi

  local curl_args=(
    '-X' 'POST'
    '--silent'
    '--show-error'
    '-H' 'Provider-Name: buildkite'
    '-H' "Job-Name: ${BUILDKITE_LABEL:-aviator}"
    '-H' "Build-URL: ${BUILDKITE_BUILD_URL}"
    '-H' "Build-ID: ${BUILDKITE_BUILD_ID}"
    '-H' "Commit-SHA: ${BUILDKITE_COMMIT}"
    '-H' "Repo-Url: ${BUILDKITE_REPO}"
    '-H' "Branch-Name: ${BUILDKITE_BRANCH}"
    '-H' "Build-Status: ${BUILD_STATUS}"
    '-F' "file[]=@${FILE_TO_UPLOAD}"
  )

  curl_args+=("${BUILDKITE_PLUGIN_AVIATOR_API_URL:-https://upload.aviator.co/api/test-report-uploader}")
  
  curl_args+=("-H" "x-Aviator-Api-Key: ${API_KEY}")

  curl "${curl_args[@]}"
}