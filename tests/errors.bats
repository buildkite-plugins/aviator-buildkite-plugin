#!/usr/bin/env bats

setup() {
  load "$BATS_PLUGIN_PATH/load.bash"

  export MY_VAR='SECRET_VALUE'
  export BUILDKITE_PLUGIN_AVIATOR_API_KEY_ENV_NAME=MY_VAR
  export BUILDKITE_PLUGIN_AVIATOR_FILES='NON-EXISTING-FILES'
}

@test 'Missing default API key environment variable' {
  unset BUILDKITE_PLUGIN_AVIATOR_API_KEY_ENV_NAME
  run "${PWD}"/hooks/pre-exit

  assert_failure
  assert_output --partial 'Missing AVIATOR_API_TOKEN environment variable'
}

@test 'Missing custom API key environment variable' {
  unset MY_VAR

  run "${PWD}"/hooks/pre-exit

  assert_failure
  assert_output --partial 'Missing MY_VAR environment variable'
}

@test 'Missing files variable' {
  unset BUILDKITE_PLUGIN_AVIATOR_FILES
  run "${PWD}"/hooks/pre-exit

  assert_failure
  assert_output --partial 'Missing configuration for files to search for'
}

@test 'No files found' {
  run "${PWD}"/hooks/pre-exit

  assert_failure
  assert_output --partial 'No files found matching'
}

@test 'No files found (on command failure)' {
  export BUILDKITE_COMMAND_EXIT_STATUS=124

  run "${PWD}"/hooks/pre-exit

  assert_success
  assert_output --partial 'No files found matching'
  assert_output --partial 'Command already failed step, aborting without error'
}
