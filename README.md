# Template Buildkite Plugin

A Buildkite plugin for something awesome

## Options

These are all the options available to configure this plugin's behaviour.

### Required

#### `mandatory` (string)

A great description of what this is supposed to do.

### Optional

#### `optional` (string)

Describe how the plugin behaviour changes if this option is not specified, allowed values and its default.

## Examples

Show how your plugin is to be used

```yaml
steps:
  - label: "🔨 Running plugin"
    command: "echo template plugin"
    plugins:
      - template#v1.0.0:
          mandatory: "value"
```

## And with other options as well

If you want to change the plugin behaviour:

```yaml
steps:
  - label: "🔨 Running plugin"
    command: "echo template plugin with options"
    plugins:
      - template#v1.0.0:
          mandatory: "value"
          optional: "example"
```

## ⚒ Developing

You can use the [bk cli](https://github.com/buildkite/cli) to run the [pipeline](.buildkite/pipeline.yml) locally:

```bash
bk local run
```

## 👩‍💻 Contributing

Your policy on how to contribute to the plugin!

## 📜 License

The package is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
