# Fleet Manager

Fleet Manager helps you manage large fleets of Fluent Bit agents from one place.

Use it to:

- Roll out configuration changes safely.
- Track agent health and connection status.
- Verify versions across environments.
- Standardise telemetry collection at scale.

Fleet Manager is available as a hosted service at <https://manager.telemetryforge.io> and can also be deployed on-premise.

Fleet Manager provides a central control plane so operators can define and roll out telemetry configuration consistently across environments.

It is not limited to Kubernetes. You can manage mixed fleets that include in-cluster agents, native Linux hosts, edge and embedded systems, and Windows or macOS endpoints managed through mobile device management (MDM) tooling.

Fleet Manager works with upstream Fluent Bit (open source software (OSS)) and with the Telemetry Forge commercial Agent distribution, so teams can standardise fleet operations without forcing a single agent channel.

## Documentation

- [Core Concepts](./core-concepts.md) - Understand key Fleet Manager entities and the typical operating flow.
- [Common Use Cases](./use-cases.md) - Learn when teams use Fleet Manager and what outcomes to expect.
- [Operations Guide](./operations-guide.md) - Follow practical, step-by-step guidance for rollout, monitoring, and rollback.
- [Comparisons](./comparisons/index.md) - Compare Fleet Manager approaches with similar tooling patterns in observability.

## GitOps-Style Option

Fleet Manager can also be used with a GitOps-style configuration model by pairing it with the Agent [Git Configuration Auto-Reload](../agent/features/git-config-auto-reload.md) plugin.

This is useful when teams want configuration in Git as the source of truth while still using Fleet Manager for fleet grouping, rollout policy, and operational visibility.

## Quick Start Path

1. Review [Core Concepts](./core-concepts.md).
2. Choose your initial approach from [Common Use Cases](./use-cases.md).
3. Implement safely using the [Operations Guide](./operations-guide.md).

