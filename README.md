# [Aviator](https://aviator.co) Test Reporter Buildkite Plugin

A Buildkite plugin for uploading JUnit files to [Aviator :plane:](https://aviator.co)

## Options

These are all the options available to configure this plugin's behaviour.

### Required

#### `files` (string)

Pattern of files to upload, relative to the checkout path (`./` will be added to it). May contain `*` to match any number of characters of any type (unlike shell expansions, it will match `/` and `.` if necessary).

### Optional

#### `api-key-env-name` (string)

Name of the environment variable that contains the Aviator API token. Defaults to: `AVIATOR_API_TOKEN`

#### `api-url` (string)

Full URL for the API to upload to. Defaults to `https://upload.aviator.co/api/test-report-uploader`

## Examples

To upload all files from an XML folder from a build step:

```yaml
steps:
  - label: "🔨 Test"
    command: "make test"
    plugins:
      - aviator#v1.0.0:
          files: "test/junit-*.xml"
```

### Using build artifacts

You can also use build artifacts generated in a previous step:

```yaml
steps:
  # Run tests and upload 
  - label: "🔨 Test"
    command: "make test --junit=tests-N.xml"
    artifact_paths: "tests-*.xml"

  - wait

  - label: ":plane: Aviator"
    command: buildkite-agent artifact download tests-*.xml
    plugins:
      - aviator#v1.0.0:
          files: "tests-*.xml"
```

## ⚒ Developing

You can use the [bk cli](https://github.com/buildkite/cli) to run the [pipeline](.buildkite/pipeline.yml) locally:

```bash
bk local run
```

## 👩‍💻 Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/buildkite-plugins/aviator-buildkite-plugin

## 📜 License

The package is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
