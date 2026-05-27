# Comparisons

This section compares Fleet Manager with common telemetry fleet-management approaches used in observability teams.

## What This Covers

- How Fleet Manager fits alongside common centralised agent-management patterns.
- Why mixed-agent support (upstream Fluent Bit OSS and Telemetry Forge Agent) can simplify real-world operations.
- How self-hosted deployment helps reduce vendor lock-in risk.
- How a GitOps-style option can be added through the Agent [Git Configuration Auto-Reload](../../agent/features/git-config-auto-reload.md) plugin.

## Comparison Guides

- [Fleet Compatibility](./fleet-compatibility.md) - Compare mixed-agent and mixed-platform operations against common tooling models.
- [Deployment and Lock-In](./deployment-and-lock-in.md) - Compare hosted-only and self-hosted control-plane approaches.

## Practical Recommendation

For most teams, choose the operating model that preserves portability:

1. Keep configuration logic portable across agent channels.
2. Standardise rollout workflows independent of deployment model.
3. Use self-hosted deployment where compliance, data residency, or platform policy requires local control.
