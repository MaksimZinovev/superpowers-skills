---
name: Multi-Subagent TMUX Workflow Manager
description: >
  Coordinates multiple Claude Code subagents across parallel or sequential workflows 
  using tmux-based session management. Enables multi-domain reasoning by assigning 
  specialized roles, isolating contexts, and merging results into coherent outputs. 
  Use this skill for any scenario requiring distributed expertise — research, analysis, 
  code review, testing, design, documentation, or planning.
---

# Multi-Subagent Workflow Manager

## Purpose

Orchestrate collaboration among specialized subagents that each handle a focused part of a complex task.  
Encourage **autonomous reasoning**, **structured synthesis**, and **feedback-driven iteration**,
managed via **tmux sessions** for parallel execution and visibility.

---

## General Pattern

```bash
> Start a tmux session for each subagent.
> Assign clear roles and deliverables.
> Let them reason independently within separate tmux windows.
> Collect results and refine through feedback loops.
```

---

## Example Scenarios

- Multi-perspective code review
- Research synthesis and report writing
- Sequential design → implementation → QA workflows
- Multi-domain analysis (e.g., policy + technical + risk)
- Collaborative documentation or planning

> These examples represent **patterns**, not templates — adapt roles and flows freely.

---

## Coordination Workflow Checklist

```
Subagent Coordination Progress:
- [ ] Step 1: Define roles and objectives
- [ ] Step 2: Initialize tmux session and subagent windows
- [ ] Step 3: Run subagents independently
- [ ] Step 4: Collect and normalize outputs
- [ ] Step 5: Cross-reference and verify
- [ ] Step 6: Synthesize final deliverable
- [ ] Step 7: Reflect and improve via feedback loop
```

**Step 1:** Define subagent goals and expected outputs.
**Step 2:** Launch a tmux session; each subagent runs in its own window or pane.
**Step 3:** Allow independent reasoning; subagents maintain isolated context.
**Step 4:** Gather outputs into a shared workspace or log buffer.
**Step 5:** Cross-check findings for overlap or inconsistency.
**Step 6:** Merge into a unified summary or plan.
**Step 7 (Feedback Loop):**

- Evaluate gaps, clarity, or contradictions.
- Send focused follow-ups to subagents.
- Iterate until the synthesis meets defined goals.

---

## Built-in Feedback Loop Template

```bash
> Phase 1: Collect outputs from all tmux subagent windows.
> Phase 2: Critique inconsistencies and identify missing depth.
> Phase 3: Re-prompt targeted subagents to revise their sections.
> Phase 4: Synthesize again and log final version.
```

> Repeat this loop until outputs converge on the desired quality.

---

## Best Practices

- **Use tmux always:** each subagent = one tmux window or pane.
- **Clarity First:** define expected output structure before running.
- **Autonomy:** subagents plan independently within their own tmux context.
- **Controlled Sync:** merge results manually or via shared log pane.
- **Feedback Loop:** review, reflect, and iterate as a standard phase.
- **Recoverability:** if one subagent fails, restart its tmux window only.
- **Adaptability:** works across technical, analytical, and creative domains.

---

## tmux Example Setup

```bash
tmux new -s subagents
tmux neww -n research && tmux send-keys 'claude' Enter
tmux neww -n analysis && tmux send-keys 'claude' Enter
tmux neww -n synthesis && tmux send-keys 'claude' Enter
tmux split-window -v -t synthesis && tmux send-keys 'tail -f logs/output.log' Enter
```

> Each window corresponds to a subagent; all collaboration happens within this session.
