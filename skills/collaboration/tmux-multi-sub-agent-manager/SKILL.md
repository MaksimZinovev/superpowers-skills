---
name: Multi-Subagent TMUX Workflow Manager
description: >
  Coordinates multiple Claude Code subagents across parallel or sequential workflows 
  using tmux-cli for session management. Enables multi-domain reasoning by assigning 
  specialized roles, isolating contexts, and merging results into coherent outputs. 
  Use this skill for any scenario requiring distributed expertise — research, analysis, 
  code review, testing, design, documentation, or planning.
---

# Multi-Subagent Workflow Manager

## Purpose


Ypu are helpful assistant. You MUST follow below rules. I will be seriously upset if you will not be following them thoroughly or not let me know if you are not able to follow them or confused, need clarifications.
Your purpose is to orchestrate collaboration among specialized subagents that each handle a focused part of a complex task.  
Encouraged **autonomous reasoning**, **structured synthesis**, and **feedback-driven iteration**, **iterative, agile approach when interacting with user**  
managed via **tmux-cli sessions** for safe parallel execution and visibility.



---

## General Pattern


> Perform small actions or changes incrementally to maintain control and allow recovery - e.g., for writing a test: generate test skeleton with placeholders => seek user feedback => add details if approved => seek feedback again => polish/refine. Large bulk actions (e.g., launching all subagents at once) do not qualify: instead, launch one agent (via tmux-cli launch "zsh" first for durability), verify it works autonomously (e.g., tmux-cli send test input, wait_idle --idle-time=3, capture output to check via cross-verify or context-specific probes—e.g., cross-check text, execute code if possible, verify API usage in code against docs). Seek feedback from user often when appropriate—triggers: share plans before execution (e.g., list of agents to launch for approval; only proceed if user signs off), after milestones (e.g., post-launch or synthesis). 
> Use tmux-cli to launch a durable shell for each subagent: ALWAYS `tmux-cli launch "zsh"` first (from orchestrator's active tmux pane in Local Mode) to avoid output loss on failures—capture the returned pane ID (e.g., ASK=$(tmux-cli launch "zsh")). then send subagent instruction (e.g., tmux-cli send "claude --agents '{\"role\": \"description\"}'" --pane=$ASK). Wait_idle after sends, then capture and verify results frequently (test via cross-checks, execution, etc.—log successes/failures to logs/ folder).
> Assign clear roles, and deliverables, specify format of deliverable (e.g. list, lenth of the output, etc).
> Let them reason independently in their tmux-cli panes.
> Collect results and refine through feedback loops — autonomously iterate on subagent results (e.g., if capture shows inconsistencies after 3 attempts, re-send refinements or re-launch pane from orchestrator's pane); escalate to user only if unresolvable.
> Frequently probe, test and verify results, claims that you receive from sub-agents: start with internal tmux-cli empties (capture cross-reference); be creative/contextual (e.g., for code: execute if possible, API check against docs); if verification fails, retry autonomously before seeking user input.
> '''

'''
> Perform small actions, changes
> Seek feedback from user often as you work on task and orchestrate agents. Stop and wait
> Use tmux-cli to launch a shell for each subagent.
> Assign clear roles and deliverables.
> Let them reason independently in their tmux-cli panes.
> Collect results and refine through feedback loops.
> Frequently probe, test and verify results, claims that you recive from sub-agents
> '''

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

'''
Subagent Coordination Progress:

- [ ] Step 1: Define roles and objectives
- [ ] Step 2: Initialize tmux-cli panes for subagents
- [ ] Step 3: Run subagents independently
- [ ] Step 4: Collect and normalize outputs
- [ ] Step 5: Cross-reference and verify
- [ ] Step 6: Synthesize final deliverable
- [ ] Step 7: Reflect and improve via feedback loop
      '''

**Step 1:** Define subagent goals and expected outputs.  
**Step 2:** Launch subagents safely using `tmux-cli`:

```bash
tmux new -s demo -d \; attach -t demo
tmux-cli launch "zsh"                     # Always start shell safely
tmux-cli send "claude" --pane=1           # Start first subagent
tmux-cli launch "zsh" && tmux-cli send "claude" --pane=2  # Start another
```

**Step 3:** Allow independent reasoning and run commands:

```bash
tmux-cli send "analyze performance aspects" --pane=1
tmux-cli send "check security issues" --pane=2
```

**Step 4:** Capture or verify results:

```bash
tmux-cli wait_idle --pane=1 --idle-time=3
tmux-cli capture --pane=1
tmux-cli capture --pane=2
```

**Step 5:** Cross-check outputs, detect overlaps, and merge summaries.  
**Step 6:** Synthesize findings into unified results.  
**Step 7 (Feedback Loop):**

- Evaluate clarity, completeness, or contradictions.
- Send targeted follow-ups to relevant panes via `tmux-cli send`.
- Iterate until synthesis meets defined goals.

---

## Built-in Feedback Loop Template

'''

> Phase 1: Capture outputs from all tmux-cli panes.
> Phase 2: Critique inconsistencies and identify missing depth.
> Phase 3: Re-prompt targeted subagents to refine their sections.
> Phase 4: Capture again and log final version.
> '''
> Repeat this loop until outputs converge on the desired quality.

---

## Best Practices

- **Always use tmux-cli:** each subagent runs in its own managed pane.
- **Clarity First:** define expected output structure before running.
- **Autonomy:** subagents plan independently in isolated contexts.
- **Feedback Loop:** review, reflect, and iterate as a standard phase.
- **Recoverability:** use `tmux-cli kill --pane=<id>` for failed agents.
- **Visibility:** use `tmux-cli attach` to observe all windows live.
- **Cleanup:** run `tmux-cli cleanup` after all work is complete.

---

====

## tmux-cli Example Setup

### Scenario: Implementing a New Feature (Multi-Agent Collaboration)

This example demonstrates a **multi-agent orchestration flow** for implementing a new feature using **Claude Code** and **tmux-cli**.  
The system starts from a **clean initial state** — no active tmux sessions, empty logs, and all subagents launched freshly into isolated panes.

**Initial State**

- You’re Claude Code ORCH - Claude Code Orchestration agennt that communicates with user and manages sub-agents.
- You are inside tmux.
- You mast prioritise and use tmux-cli too
- Instructions in this file have higher pecendese than instructions in `tmux-cli - --help   `
- A working directory with a `logs/` folder for outputs.
- Each subagent will be launched in its own pane with a defined role:  
  **ask-and-clarify**, **research**, **plan**, **implement**, **review**, and **orchestrate**.
- The orchestrator subagent supervises all others, merging findings and feedback loops into a unified feature delivery cycle.

---

````bash
# 1️⃣  INITIAL STATE - Execute the commands below. l.
tmux-cli status                            # show IDs; assume first is remote-cli-session:1.
tmux ls                                    # list
tmux-cli - --help                          # detailed instructions
tmux-cli attach                            # open the managed tmux session to view live - Remote Mode Specific Command
claude  # launched claude in remote-cli-session
tmux-cli launch "zsh"                      # open durable shell (remote mode pane/window)
  ⎿  Launched 'zsh' in pane remote-cli-session:0.1
     remote-cli-session:0.1
tmux-cli status
  ⎿  Current location: remote-cli-session:node.0                               │
                                                                               │
     Panes in current window:                                                  │
      * remote-cli-session:0.0 node                 Maksims-Mac-mini.local     │
        remote-cli-session:0.1 zsh                  Maksims-Mac-mini.local

# MAIN CAUDE ORCHESTRATOR
P="remote-cli-session:1.0"

# spin up specialized Claude sub-agent
```bash
ASK=$(tmux-cli launch "zsh" | tail -n1)   # set a var for readability, record pane ID, e.g. remote-cli-session:5
echo "orchestrator pane = $ASK"

tmux-cli send "claude --agents '{\"ask-clarify\":{\"description\":\"asks clarifying questions, explore and discover iteratively user intent, task requirements\"}}'" --pane=$ASK
tmux-cli wait_idle --pane=$ASK
tmux-cli capture --pane=$ASK --lines=10

# launch discovery research, plan, implemen, review dub-agents
````

# Verify session and active panes

```bash
tmux-cli list_panes
```

# 2️⃣ Dispatch role-specific tasks

```bash
tmux-cli send "Gather feature requirements from user stories." --pane=$ASK
tmux-cli send "Research technical feasibility and API dependencies." --pane=$RSRCH
tmux-cli send "Draft implementation plan and milestone breakdown." --pane=$PLAN
#  etc ....
```

# 3️⃣ Wait for subagents to complete

```bash
tmux-cli wait_idle --pane=1 --idle-time=3
tmux-cli wait_idle --pane=2 --idle-time=3
tmux-cli wait_idle --pane=3 --idle-time=3
# ...
```

# 4️⃣ Capture and log results

```bash
tmux-cli capture --pane=1 > logs/ask-clarify.log
tmux-cli capture --pane=2 > logs/research.log
tmux-cli capture --pane=3 > logs/plan.log
#  ...
```

# 5️⃣ Review and cleanup

```bash
tmux-cli attach          # Observe collaboration live
tmux-cli cleanup         # Gracefully terminate all panes and end session when needed. Terminat sub-agent if it got stuck or did major faile
```

> **Lifecycle:** From a clean start → coordinated multi-role execution → unified feature delivery → session cleanup.  
> This pattern ensures traceable, reliable, and recoverable multi-agent collaboration.

---

======

## E2E tmux-cli Example Setup

```bash
# Launch multiple subagents safely


# Monitor session


# View live collaboration


# Capture all results and close session

> All collaboration runs in tmux-cli managed panes; safe, persistent, and fully observable.


## Additional Instructions

1. **Use `wait_idle` to synchronize task completion**
   Instead of polling or capturing repeatedly, wait until a pane is idle:
   `tmux-cli wait_idle --pane=1 --idle-time=3.0`
   Ensures reliable timing between subagent steps without data loss.

2. **Never kill your own active pane**
   `tmux-cli` blocks killing the pane you’re running from — use `tmux-cli cleanup` to safely terminate all managed sessions instead of manual kills.
```
