# Operations Guide

Use this guide to operate Fleet Manager safely at scale.

## 1. Onboard Agents

1. Open Fleet Manager at <https://manager.telemetryforge.io>.
2. Register each Fluent Bit instance with Fleet Manager.
3. Assign agents to the correct groups during onboarding.
4. Verify agents appear as connected and healthy.

Tip: start with a small non-production group to validate connectivity and naming conventions.

Common onboarding patterns include:

- Kubernetes: DaemonSet-based Fluent Bit deployments per cluster.
- Native infrastructure: Linux services on virtual machines (VMs) or bare metal.
- Endpoint fleets: Windows and macOS deployments managed through mobile device management (MDM) tooling.
- Edge and embedded: site-local agents that may connect intermittently.

Agent channel patterns include:

- Upstream Fluent Bit (OSS) as a default baseline for broad portability.
- Telemetry Forge Agent for teams that want commercial packaging and support.
- Mixed-channel fleets where different business units use different agent distributions.

## 2. Build a Baseline Configuration

1. Define a baseline Fluent Bit configuration shared by most agents.
2. Add environment-specific differences as separate revisions or overlays.
3. Keep revisions small and focused to simplify troubleshooting.
4. Add meaningful revision notes so operators understand intent.

Optional GitOps-style approach:

- Keep baseline and environment overlays in Git repositories.
- Use the Agent [Git Configuration Auto-Reload](../agent/features/git-config-auto-reload.md) plugin for Git-driven hot reload where needed.
- Use Fleet Manager groups and rollout rings to control promotion and blast radius.

## 3. Roll Out Changes Safely

Use progressive rollout rings:

1. Canary group.
2. Staging group.
3. Production subset.
4. Full production.

At each step:

- Confirm agent health and configuration apply success.
- Validate telemetry quality in your destination platform.
- Proceed only when metrics are stable.

For mixed fleets, sequence by risk and connectivity. Example order:

1. Kubernetes canary.
2. Linux VM canary.
3. Windows/macOS MDM pilot ring.
4. Edge or embedded pilot locations.
5. Broader production rollout.

## 4. Monitor Fleet Health and Version Status

Use Fleet Manager to answer key operational questions:

- Which agents are online or disconnected?
- Which revision is each group running?
- Which Fluent Bit versions are in use?
- Where are rollout failures or lagging updates?

Also track platform-specific indicators:

- Endpoint adoption by MDM cohort.
- Edge update lag caused by offline periods.
- Drift between Kubernetes, server, and endpoint baselines.

Use this data for daily operations, release planning, and security reviews.

## 5. Roll Back When Needed

If a change causes issues:

1. Select the affected group.
2. Re-assign the previous known-good revision.
3. Confirm fleet convergence and telemetry recovery.
4. Document root cause before retrying the change.

## Best Practices

- Treat configuration as versioned change: small, reviewable revisions.
- Use progressive rollout rather than all-at-once production changes.
- Keep group naming consistent and environment-first.
- Track version drift regularly, not only during incidents.
- Maintain a known-good rollback revision for each production group.
- Keep hosted and self-hosted operating procedures aligned to reduce migration effort and lock-in.

## Example Operating Model

An operations team manages 2,500 Fluent Bit agents across three regions.

- They define one global baseline for common parsing and enrichment.
- They keep output destinations per environment as separate revisions.
- Every change follows canary -> staging -> production rollout.
- They review version compliance weekly and remediate laggards.

Result: faster, safer telemetry updates with fewer production incidents caused by configuration drift.
