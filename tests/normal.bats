#!/usr/bin/env bats

# To debug stubs, you can use the following variables:
# export CURL_STUB_DEBUG=/dev/tty
# export FIND_STUB_DEBUG=/dev/tty
# export ZIP_STUB_DEBUG=/dev/tty

setup() {
  load "$BATS_PLUGIN_PATH/load.bash"

  # Buildkite Build Variables
  export BUILDKITE_BRANCH='develop'
  export BUILDKITE_BUILD_ID='test'
  export BUILDKITE_BUILD_URL='https://localhost/build'
  export BUILDKITE_COMMIT='git-local'
  export BUILDKITE_PIPELINE_SLUG='test-pipeline'
  export BUILDKITE_REPO='https://github.com/buildkite-plugins/aviator-buildkite-plugin'

  # Plugin variables
  export AVIATOR_API_TOKEN='SECRET_VALUE'
  export BUILDKITE_PLUGIN_AVIATOR_FILES='*.xml'
}

@test 'Single file upload' {
  stub find 'echo file.xml'
  stub curl "echo Uploaded file \${24}"

  run "${PWD}"/hooks/pre-exit

  assert_success
  assert_output --partial "Uploading file.xml"
  assert_output --partial "Uploaded file file[]=@file.xml"
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

@test 'Multiple file upload' {
  stub find 'echo file.xml; echo file-2.xml'
  stub curl "echo Uploaded file \${24}"

  stub zip "echo -n Compressing into \$1':'; shift; echo ' '\$@"

  run "${PWD}"/hooks/pre-exit

  assert_success
  assert_output --partial "Multiple files found"
  assert_output --partial "compressing into single file"
  refute_output --partial "Uploading file.xml"
  refute_output --partial "Uploading file-2.xml"

  unstub find
  unstub curl
  unstub zip
}

@test 'Can change API endpoint' {
  export BUILDKITE_PLUGIN_AVIATOR_API_URL='https://example.com/upload'

  stub find 'echo file.xml'
  stub curl "echo Uploaded \${24} to \${25}"

  run "${PWD}"/hooks/pre-exit

  assert_success
  assert_output --partial 'Uploaded file[]=@file.xml to https://example.com/upload'

  unstub find
  unstub curl
}

@test 'Step failure reports status as failure' {
  export BUILDKITE_COMMAND_EXIT_STATUS=1

  stub find 'echo file.xml'
  stub curl "echo Uploaded file \${24} with \${20}"

  run "${PWD}"/hooks/pre-exit

  assert_success
  assert_output --partial "Uploading file.xml"
  assert_output --partial "Uploaded file file[]=@file.xml"
  assert_output --partial "with Build-Status: failure"
  
  unstub find
  unstub curl
}

@test 'Step OK reports status as success' {
  export BUILDKITE_COMMAND_EXIT_STATUS=0

  stub find 'echo file.xml'
  stub curl "echo Uploaded file \${24} with \${20}"

  run "${PWD}"/hooks/pre-exit

  assert_success
  assert_output --partial "Uploading file.xml"
  assert_output --partial "Uploaded file file[]=@file.xml"
  assert_output --partial "with Build-Status: success"

  unstub find
  unstub curl
}