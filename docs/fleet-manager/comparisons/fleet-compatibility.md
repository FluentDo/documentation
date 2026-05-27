# Fleet Compatibility

Many observability tools provide central agent management, but differ in how tightly they couple control workflows to one agent distribution.

Fleet Manager is designed for mixed estates where teams may run:

- Upstream Fluent Bit (open source software (OSS)).
- Telemetry Forge Agent (commercial distribution).
- Multiple deployment targets at the same time (Kubernetes, virtual machines (VMs), edge systems, and endpoint fleets).

## Comparison: Common Tooling Patterns

## Pattern 1: Single-Agent Control Planes

Some platforms are built primarily around one vendor agent and one operational model.

Typical trade-off:

- Strong integration for that specific stack.
- More migration work when teams need mixed agents or cross-platform consistency.

Fleet Manager advantage:

- One operational workflow across OSS and commercial agent channels.
- Less rework when teams merge estates or standardise across business units.

## Pattern 2: Kubernetes-First Management

Some tooling focuses mainly on cluster-native control patterns.

Typical trade-off:

- Excellent in-cluster ergonomics.
- Additional effort for endpoint, edge, or non-cluster Linux estates.

Fleet Manager advantage:

- First-class mixed-fleet model across cluster and non-cluster environments.
- Shared rollout and status model for Kubernetes, VM, endpoint, and edge groups.

## Pattern 3: Fragmented Agent Tooling

Some organisations run one process for OSS agents and a separate process for commercial agents.

Typical trade-off:

- Short-term local optimisation.
- Long-term operational overhead and inconsistent change control.

Fleet Manager advantage:

- Unified revision, rollout, and health workflows across agent channels.
- Easier audit and operations review because the control model is shared.

## Benefits for Customers

- Lower operational complexity across mixed estates.
- Better continuity during platform transitions.
- Clearer governance when different teams prefer different agent channels.
- Faster rollout standardisation without forced re-platforming.
