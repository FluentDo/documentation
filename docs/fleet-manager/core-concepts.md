# Core Concepts

This page introduces the core objects and workflow used in Fleet Manager.

## Why Teams Use Fleet Manager

As telemetry deployments grow, configuration drift becomes a common reliability risk. Teams often end up with:

- Different agent versions across hosts.
- Inconsistent parsing or routing rules.
- Slow and risky manual changes.
- Limited visibility into what is actually running.

Fleet Manager addresses this by giving operators a central way to define, deploy, and monitor Fluent Bit behaviour across a fleet.

In the observability domain, this follows a common fleet-management model: central policy management, controlled rollout rings, and fleet-wide status reporting.

Fleet Manager supports mixed deployment models. A single fleet can include:

- Kubernetes-based agents.
- Native Linux deployments on virtual machines (VMs) or bare metal.
- Edge or embedded deployments with intermittent connectivity.
- Windows and macOS endpoints deployed through mobile device management (MDM) workflows.

Fleet Manager also supports mixed agent channels in the same estate:

- Upstream Fluent Bit (OSS).
- Telemetry Forge Agent (commercial distribution).

This lets teams adopt commercial support where needed while keeping direct compatibility with OSS deployments.

## Core Objects

### Agent

A running Fluent Bit instance connected to Fleet Manager.

### Group

A logical collection of agents, such as:

- Environment (`dev`, `staging`, `production`)
- Region (`us-east`, `eu-west`)
- Platform (`kubernetes`, `linux-vm`, `bare-metal`, `edge-embedded`, `windows-mdm`, `macos-mdm`)

### Configuration Revision

A versioned telemetry configuration that can be assigned to one or more groups.

### Rollout

A controlled deployment of a configuration revision to selected agents or groups.

## Typical User Journey

1. Connect agents to Fleet Manager.
2. Organise agents into groups.
3. Create or import a Fluent Bit configuration.
4. Validate in a low-risk environment.
5. Roll out progressively to production.
6. Monitor fleet status and version adoption.

## Recommended Grouping Model

Start with clear, stable dimensions:

- First dimension: environment (`dev`, `staging`, `production`)
- Second dimension: platform (`kubernetes`, `linux-vm`, `windows-mdm`, `macos-mdm`, `edge-embedded`)
- Optional third dimension: region

This structure keeps targeting predictable during rollouts and incident response.

For larger estates, add a connectivity dimension such as `always-online` and `intermittent` so rollout and monitoring expectations match real operating conditions.
