# Environment Variables

The Telemetry Forge Agent pre-populates a small set of runtime environment variables that you can always reference in Fluent Bit configuration files rather than have to set explicitly.

Each variable will always pick up the value if set in the environment first.

These variables are available in Telemetry Forge Agent version 26.7.1 and later.

## Supported variables

| Variable | Description | Default when not provided in process environment |
| --- | --- | --- |
| HOSTNAME | Host identity used by the running process. | System hostname (when available) |
| OS_TYPE | Normalized operating system name. | linux, macos, windows, or unknown |
| AGENT_DISTRO | Build distribution metadata. | Value from build metadata, or unknown |
| AGENT_PACKAGE_TYPE | Build package type metadata. | Value from build metadata, or unknown |
| AGENT_VERSION | Agent version metadata. | Value from build metadata, or unknown |

## Values currently used in agent builds

These values are primarily for our [Fleet Management solution](../fleet-manager/index.md) but are available to all users as well.

### AGENT_PACKAGE_TYPE

Current build values:

- CONTAINER (container image builds)
- PACKAGE (native package and installer builds)

### AGENT_DISTRO

Current production build values are set based on our [supported targets](./supported-platforms.md) for each release but examples include:

- Container defaults:
  - debian/trixie
  - ubi/10.2
- Linux package build targets (release set):
  - almalinux/8
  - almalinux/9
  - almalinux/10
  - amazonlinux/2023
  - centos/6
  - centos/7
  - debian/bookworm
  - debian/trixie
  - ubuntu/22.04
  - ubuntu/24.04
  - ubuntu/26.04
  - suse/15
- Native package and installer platform values:
  - windows-x64
  - macos-15
  - macos-15-intel

## How values are resolved

Resolution order for each variable:

1. Existing process environment value is kept as-is.
2. If missing, the agent applies an internal preset set during the build.
3. If build metadata is unavailable for AGENT_DISTRO, AGENT_PACKAGE_TYPE, or AGENT_VERSION, the value is unknown.

## Use in Fluent Bit configuration

You can reference the variables with [standard bash interpolation syntax](https://docs.fluentbit.io/manual/administration/configuring-fluent-bit/yaml/environment-variables-section#external-variables).

```yaml
pipeline:
  inputs:
    - name: dummy
      tag: env.test
      dummy: '{"distro":"${AGENT_DISTRO}","package_type":"${AGENT_PACKAGE_TYPE}","version":"${AGENT_VERSION}","os":"${OS_TYPE}","hostname":"${HOSTNAME}"}'

  outputs:
    - name: stdout
      match: env.test
```

Expected output when run with the UBI container:

```text
[0] env.test: [[<timestamp>, {}], {"distro"=>"ubi/10.2", "package_type"=>"CONTAINER", "version"=>"26.7.1", "os"=>"linux", "hostname"=>"my-host"}]
```

If you use the one-off or container overrides below, the `distro`, `package_type`, and `version` fields reflect the override values.

## GitOps multi-platform example

You can use one Git repository for all operating systems and let `${OS_TYPE}` select the platform-specific configuration file automatically.

Example repository layout:

```text
fluent-bit-configs/
  platforms/
    linux/fluent-bit.yaml
    windows/fluent-bit.yaml
    macos/fluent-bit.yaml
```

Agent configuration:

```yaml
service:
  flush: 1
  log_level: info

customs:
  - name: git_config
    repo: https://github.com/myorg/fluent-bit-configs.git
    ref: main
    path: platforms/${OS_TYPE}/fluent-bit.yaml
    config_dir: /var/lib/fluent-bit/git-config
    poll_interval: 60
```

Path resolution examples:

- Linux agent: `platforms/linux/fluent-bit.yaml`
- Windows agent: `platforms/windows/fluent-bit.yaml`
- macOS agent: `platforms/macos/fluent-bit.yaml`

This lets you keep a single GitOps repository while still maintaining per-platform Fluent Bit configuration files.

## Override examples

### One-off process override

```bash
AGENT_PACKAGE_TYPE=CONTAINER AGENT_DISTRO=ubuntu/24.04 AGENT_VERSION=26.7.1 \
  /opt/telemetryforge-agent/bin/fluent-bit -c ./fluent-bit.yaml
```

### Container override

```bash
docker run --rm \
  -e AGENT_DISTRO=ubuntu/24.04 \
  -e AGENT_PACKAGE_TYPE=CONTAINER \
  -e AGENT_VERSION=26.7.1 \
  -v "$PWD/fluent-bit.yaml:/fluent-bit/etc/fluent-bit.yaml:ro" \
  ghcr.io/telemetryforge/agent:26.7.1 \
  -c /fluent-bit/etc/fluent-bit.yaml
```

### systemd service override

Add to your service unit:

```ini
[Service]
Environment=AGENT_DISTRO=rhel/9
Environment=AGENT_PACKAGE_TYPE=PACKAGE
Environment=AGENT_VERSION=26.7.1
```
