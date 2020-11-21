# Contributing

Testing Locally:

```shell
asdf plugin test <plugin-name> <plugin-url> [--asdf-tool-version <version>] [--asdf-plugin-gitref <git-ref>] [test-command*]

#
asdf plugin test loki-logcli https://github.com/comdotlinux/asdf-loki-logcli.git "logcli --version"
```

Tests are automatically run in GitHub Actions on push and PR.
