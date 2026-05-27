# Common Use Cases

This page covers common telemetry pipeline fleet-management scenarios and how Fleet Manager helps.

## 1. Standardise Logging Across Mixed Platforms

**Problem:** Different deployment targets (Kubernetes, Linux hosts, edge devices, Windows laptops, and macOS endpoints) often run inconsistent Fluent Bit settings, producing uneven telemetry quality.

**With Fleet Manager:**

1. Create a shared baseline for parsers, tags, and common outputs.
2. Apply platform-specific overlays for Kubernetes, Linux hosts, Windows/macOS mobile device management (MDM) endpoints, and edge devices.
3. Roll out by platform, region, or environment group.
4. Confirm all agents report the expected revision.

**Outcome:** Consistent fields, parsers, and routing across the organisation.

## 2. Safe Production Changes (Canary Then Global)

**Problem:** A parsing change might break downstream dashboards or alerts if pushed everywhere at once.

**With Fleet Manager:**

1. Assign the new revision to a canary group (for example 5% of nodes).
2. Watch health and delivery metrics.
3. Promote to broader groups if results are healthy.
4. Stop or roll back quickly if regressions appear.

**Outcome:** Faster delivery with lower operational risk.

## 3. Version Compliance and Upgrade Tracking

**Problem:** You need to know which agents are out of date for security or support reasons.

**With Fleet Manager:**

1. View version distribution across the fleet.
2. Identify lagging environments.
3. Coordinate upgrades with operations teams.
4. Track adoption until required groups are compliant.

**Outcome:** Better security posture and easier audit readiness.

## 4. Incident Response During Backend Changes

**Problem:** During an outage or backend migration, you must reroute telemetry quickly.

**With Fleet Manager:**

1. Prepare an emergency revision (for example, alternate output destination).
2. Apply it to affected groups only.
3. Monitor status to verify successful propagation.
4. Revert to normal routing when stable.

**Outcome:** Faster mitigation and reduced data loss during incidents.

## 5. Multi-Region Change Coordination

**Problem:** Large estates require staggered change windows by geography and business-criticality.

**With Fleet Manager:**

1. Segment groups by region and service tier.
2. Sequence rollouts from low-risk to high-risk regions.
3. Track per-group status and convergence before expanding.
4. Pause expansion automatically when health checks degrade.

**Outcome:** Predictable global changes with less operational disruption.

## 6. Mobile Device Management (MDM)-Managed Endpoint Telemetry

**Problem:** Security and information technology (IT) teams need consistent observability from corporate Windows and macOS fleets, but endpoint policies and deployment timing vary.

**With Fleet Manager:**

1. Group agents by endpoint platform (`windows-mdm`, `macos-mdm`) and business unit.
2. Align rollout waves with MDM policy rings (pilot, broad, enterprise).
3. Track configuration revision and Fluent Bit version adoption by endpoint cohort.
4. Roll back targeted cohorts quickly if endpoint stability or data quality degrades.

**Outcome:** Controlled endpoint telemetry rollout with clear auditability.

## 7. Edge and Embedded Telemetry at Scale

**Problem:** Edge gateways and embedded systems may connect intermittently, making fleet-wide changes harder to coordinate safely.

**With Fleet Manager:**

1. Group edge agents by hardware type, location, and connectivity profile.
2. Use staged revision rollouts with longer observation windows.
3. Monitor lagging or offline nodes separately from always-online infrastructure.
4. Reconcile late-arriving updates as connectivity resumes.

**Outcome:** Reliable telemetry operations across constrained and intermittently connected environments.

## 8. Reduce Vendor Lock-In While Standardising Operations

**Problem:** Teams want central fleet control without being forced into one proprietary agent distribution or one hosted control plane.

**With Fleet Manager:**

1. Manage both upstream Fluent Bit (OSS) and Telemetry Forge Agent fleets from a shared control workflow.
2. Deploy Fleet Manager as self-hosted when data residency or internal platform policy requires local control.
3. Keep configuration and rollout practices consistent across hosted and self-hosted environments.
4. Move between deployment models without rebuilding your operational model.

**Outcome:** Strong operational consistency with lower platform lock-in risk.

## 9. GitOps-Style Configuration Control

**Problem:** Platform teams want Git to remain the source of truth for telemetry configuration, with auditable pull-request workflows and controlled promotion between environments.

**With Fleet Manager:**

1. Store Fluent Bit configuration in Git repositories per environment.
2. Use the Agent [Git Configuration Auto-Reload](../agent/features/git-config-auto-reload.md) plugin where Git-driven hot reload is required.
3. Use Fleet Manager groups and rollout policy to coordinate change windows and progressive deployment.
4. Track fleet convergence and version status centrally after Git changes are promoted.

**Outcome:** Git-centred change control plus central fleet operations and visibility.
