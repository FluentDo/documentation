# Deployment and Lock-In

A major difference between telemetry fleet-management options is whether the control plane can be deployed only as hosted software as a service (SaaS), or also as self-hosted infrastructure.

Fleet Manager supports both hosted and self-hosted deployment models.

## Why This Matters

Deployment model choice affects:

- Data residency and regulatory posture.
- Network and security boundary design.
- Procurement and long-term platform flexibility.
- Exit cost if priorities change.

## Hosted-Only vs Hosted-and-Self-Hosted

## Hosted-Only Pattern

Typical strengths:

- Fast initial setup.
- Lower day-one platform effort.

Typical constraints:

- Harder alignment with strict residency or internal hosting requirements.
- Higher migration effort if hosting policy changes later.

## Hosted-and-Self-Hosted Pattern (Fleet Manager)

Typical strengths:

- Choose deployment based on policy and environment constraints.
- Keep one operating model while changing where it runs.
- Reduce vendor lock-in by preserving deployment flexibility.

## Practical Anti-Lock-In Benefits

Fleet Manager helps reduce lock-in risk by supporting:

- Agent channel flexibility: upstream Fluent Bit OSS and Telemetry Forge Agent.
- Control-plane flexibility: hosted or self-hosted.
- Workflow portability: consistent grouping, revision, and rollout practices.

In practice, this means teams can change packaging, support level, or hosting placement without redesigning the whole fleet operations model.

## Decision Checklist

Use this checklist when selecting your Fleet Manager deployment model:

1. Do you have residency or sovereignty controls requiring self-hosted operation?
2. Do you need one model across cloud, on-premise, and edge estates?
3. Do you want to keep optionality between OSS and commercial agent channels?
4. Do you need a migration path that avoids operational redesign?

If most answers are yes, use Fleet Manager with a portability-first approach: keep rollout practices and configuration structure consistent across both hosted and self-hosted environments.
