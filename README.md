<div align="center">

# asdf-loki-logcli ![Build](https://github.com/comdotlinux/asdf-loki-logcli/workflows/Build/badge.svg) ![Lint](https://github.com/comdotlinux/asdf-loki-logcli/workflows/Lint/badge.svg)

[loki-logcli](https://grafana.com/oss/loki) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Why?](#why)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`: generic POSIX utilities.
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add loki-logcli
# or
asdf plugin add https://github.com/comdotlinux/asdf-loki-logcli.git
```

loki-logcli:

```shell
# Show all installable versions
asdf list-all loki-logcli

# Install specific version
asdf install loki-logcli latest

# Set a version globally (on your ~/.tool-versions file)
asdf global loki-logcli latest

# Now loki-logcli commands are available
logcli --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/comdotlinux/asdf-loki-logcli/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [GuruprasadKulkarni](https://github.com/comdotlinux/)
