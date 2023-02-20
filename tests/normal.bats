#!/usr/bin/env bats

# To debug stubs, you can use the following variables:
# export CURL_STUB_DEBUG=/dev/tty
# export FIND_STUB_DEBUG=/dev/tty

setup() {
  load "$BATS_PLUGIN_PATH/load.bash"

  # Buildkite Build Variables
  export BUILDKITE_BRANCH='develop'
  export BUILDKITE_BUILD_ID='test'
  export BUILDKITE_BUILD_URL='https://localhost/build'
  export BUILDKITE_COMMIT='git-local'
  export BUILDKITE_REPO='https://github.com/buildkite-plugins/aviator-buildkite-plugin'

  # Plugin variables
  export AVIATOR_API_KEY='SECRET_VALUE'
  export BUILDKITE_PLUGIN_AVIATOR_FILES='*.xml'
}

@test 'Single file upload' {
  stub find 'echo file.xml'
  stub curl "echo Uploaded file \${22}"

  run "${PWD}"/hooks/pre-exit

  assert_success
  assert_output --partial "Uploading file.xml"
  assert_output --partial "Uploaded file @file.xml"

  unstub find
  unstub curl
}

@test 'Curl failure does not explode' {
  stub find 'echo file.xml'
  stub curl 'exit 1'

  run "${PWD}"/hooks/pre-exit

  assert_success
  assert_output --partial "Uploading file.xml"
  assert_output --partial "Error uploading, will continue"

  unstub find
  unstub curl
}

@test 'Curl failure continues multiple upload' {
  stub find 'echo file.xml; echo file-2.xml'
  stub curl \
    'exit 1' \
    "echo Uploaded file \${22}"

  run "${PWD}"/hooks/pre-exit

  assert_success
  assert_output --partial "Uploading file.xml"
  assert_output --partial "Error uploading, will continue"
  assert_output --partial "Uploading file-2.xml"

  unstub find
  unstub curl
}

@test 'Multiple file upload' {
  stub find 'echo file.xml; echo file-2.xml'
  stub curl \
    "echo Uploaded file \${22}" \
    "echo Uploaded file \${22}"

  run "${PWD}"/hooks/pre-exit

  assert_success
  assert_output --partial "Uploading file.xml"
  assert_output --partial "Uploading file-2.xml"

  unstub find
  unstub curl
}

@test 'Can change API endpoint' {
  export BUILDKITE_PLUGIN_AVIATOR_API_URL='https://example.com/upload'

  stub find 'echo file.xml'
  stub curl "echo Uploaded \${22} to \${23}"

  run "${PWD}"/hooks/pre-exit

  assert_success
  assert_output --partial 'Uploaded @file.xml to https://example.com/upload'

  unstub find
  unstub curl
}