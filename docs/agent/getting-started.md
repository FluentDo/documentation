# Getting Started

This quick guide helps you install Telemetry Forge Agent and run a minimal Fluent Bit pipeline that tails logs and prints them to stdout.

The Telemetry Forge Agent is based on upstream Fluent Bit, so the configuration model and most plugins follow standard Fluent Bit behaviour.

All binaries and installers are available at [https://packages.telemetryforge.io](https://packages.telemetryforge.io/index.html) and via our [GitHub repository releases](https://github.com/telemetryforge/agent/releases).

=== "Linux"

    ## 1. Install Telemetry Forge Agent

    Use the official installer script:

    ```bash
    curl -fsSL https://raw.githubusercontent.com/telemetryforge/agent/refs/heads/main/install.sh -o install.sh
    chmod +x install.sh
    ./install.sh
    ```

    Optional: install a specific version:

    ```bash
    ./install.sh --version 26.4.4
    ```

    Verify installation:

    ```bash
    /opt/telemetryforge-agent/bin/fluent-bit --version
    ```

    This installs a systemd or init.d service for automatic startup.

    ## 2. Create a minimal YAML configuration

    Create a file named `getting-started.yaml`:

    ```yaml
    service:
      flush: 1
      log_level: info

    pipeline:
      inputs:
        - name: tail
          tag: demo.logs
          path: /var/log/*.log
          # Only required to read existing data in the log file before we start
          read_from_head: true

      outputs:
        - name: stdout
          match: demo.logs
    ```

    If your logs are in a different location, update `path`.

    ## 3. Run the agent

    ```bash
    sudo /opt/telemetryforge-agent/bin/fluent-bit -c ./getting-started.yaml
    ```

    You should see tailed log records printed to stdout.

    `sudo` is used to ensure access to protected log files.

=== "macOS"

    ## 1. Install Telemetry Forge Agent

    Use the official installer script:

    ```bash
    curl -fsSL https://raw.githubusercontent.com/telemetryforge/agent/refs/heads/main/install.sh -o install.sh
    chmod +x install.sh
    ./install.sh
    ```

    Optional: install a specific version:

    ```bash
    ./install.sh --version 26.4.4
    ```

    Verify installation:

    ```bash
    /opt/telemetryforge-agent/bin/fluent-bit --version
    ```

    This installs a launchctl script for automatic startup.

    ## 2. Create a minimal YAML configuration

    Create a file named `getting-started.yaml`:

    ```yaml
    service:
      flush: 1
      log_level: info

    pipeline:
      inputs:
        - name: tail
          tag: demo.logs
          path: /var/log/*.log
          # Only required to read existing data in the log file before we start
          read_from_head: true

      outputs:
        - name: stdout
          match: demo.logs
    ```

    If your logs are in a different location, update `path`.

    ## 3. Run the agent

    ```bash
    sudo /opt/telemetryforge-agent/bin/fluent-bit -c ./getting-started.yaml
    ```

    You should see tailed log records printed to stdout.

=== "Windows"

    ## 1. Install Telemetry Forge Agent

    Preferred option: use our native Windows binaries/installers from [https://packages.telemetryforge.io](https://packages.telemetryforge.io/index.html).

    Download the Windows package for your architecture and install it.

    If you use the Microsoft Installer (MSI) or executable (EXE) installer, a Windows service is created for automatic startup.

    Alternative option: Windows Subsystem for Linux 2 (WSL2) if you prefer a Linux runtime:

    1. Install WSL2:

    ```powershell
    wsl --install
    ```

    2. Open your Linux distribution in WSL and follow the Linux tab on this page.

    ## 2. Create a minimal YAML configuration

    Create a file named `getting-started.yaml`:

    ```yaml
    service:
      flush: 1
      log_level: info

    pipeline:
      inputs:
        - name: winlog
          channels: Setup,Windows Powershell
          interval_sec: 1

      outputs:
        - name: stdout
          match: '*'
    ```

    ## 3. Run the agent

    ```shell
    <install path>\bin\fluent-bit -c .\getting-started.yaml
    ```

=== "Containers"

    ## 1. Choose an image

    Container images are available at [https://ghcr.io/telemetryforge/agent](https://ghcr.io/telemetryforge/agent):

    - `ghcr.io/telemetryforge/agent:<VERSION>`: Universal Base Image (UBI)-based image
    - `ghcr.io/telemetryforge/agent:<VERSION>-slim`: Debian-based image (closer to upstream Fluent Bit)

    Substitute `VERSION` with your required release, for example `26.6.1`.

    ## 2. Create a minimal YAML configuration

    Create a file named `getting-started.yaml`:

    ```yaml
    service:
      flush: 1
      log_level: info

    pipeline:
      inputs:
        - name: tail
          tag: demo.logs
          path: /var/log/*.log
          read_from_head: true

      outputs:
        - name: stdout
          match: demo.logs
    ```

    ## 3. Run the container

    ```bash
    docker run --rm -it \
        -v "$PWD/getting-started.yaml:/fluent-bit/etc/fluent-bit.yaml:ro" \
        <IMAGE> -c "/fluent-bit/etc/fluent-bit.yaml"
    ```

    Substitute `IMAGE` with your chosen image variant.

    Remember to mount any log files, volumes, or credentials required by your input and output plugins.

## Next steps

- Replace `stdout` with or add your target output plugin (OpenSearch, Elasticsearch, HTTP, etc.).
- Replace `tail` or add your target input plugins.
- Add any additional processing/filtering required.
- Update the systemd service to use your specific configuration.
- Review [Environment Variables](./features/environment-variables.md) for AGENT_DISTRO, AGENT_PACKAGE_TYPE, AGENT_VERSION, OS_TYPE, and HOSTNAME interpolation.
- Review our custom [GitOps plugin](./features/git-config-auto-reload.md) to simplify configuration management.
- Review [Supported Platforms](./supported-platforms.md).
- Review [Version Mapping](./version-mapping.md) to align with your upstream Fluent Bit baseline.
- See upstream plugin/config docs at [docs.fluentbit.io](https://docs.fluentbit.io).

