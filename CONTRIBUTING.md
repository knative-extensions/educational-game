# Contribution Guidelines

So you want to hack on the Knative Educational Game? Yay! 🎉

Before diving in, please read Knative's overall
[Contribution Guidelines](https://knative.dev/community/contributing/) for
community norms, the Code of Conduct, and the CLA process.

This document focuses on the **local development workflow** and **project-specific
conventions** for this repository.

---

## Table of Contents

1. [Prerequisites](#1-prerequisites)
2. [Getting the Code](#2-getting-the-code)
3. [Running the Game Locally](#3-running-the-game-locally)
4. [Project Structure](#4-project-structure)
5. [Coding Conventions](#5-coding-conventions)
6. [Branching Strategy](#6-branching-strategy)
7. [Making a Change](#7-making-a-change)
8. [Pull Request Checklist](#8-pull-request-checklist)
9. [Reporting Bugs & Requesting Features](#9-reporting-bugs--requesting-features)

---

## 1. Prerequisites

| Tool | Version | Download |
|------|---------|----------|
| Godot Engine | **4.3 (Standard)** | [godotengine.org/download/archive/4.3-stable](https://godotengine.org/download/archive/4.3-stable/) |
| Git | ≥ 2.34 | [git-scm.com](https://git-scm.com/) |

> **Note**: Only the **Standard** Godot build is required. The Mono/C# build is
> not needed because all game logic is written in GDScript.

---

## 2. Getting the Code

```bash
# Fork the repository on GitHub, then clone your fork:
git clone https://github.com/<YOUR_GITHUB_USERNAME>/educational-game.git
cd educational-game

# Add the upstream remote so you can pull future changes:
git remote add upstream https://github.com/knative-extensions/educational-game.git
```

---

## 3. Running the Game Locally

1. Launch the Godot 4.3 executable.
2. In the **Project Manager** click **Import**.
3. Navigate to the cloned `educational-game/` folder, select `project.godot`,
   and click **Import & Edit**.
4. Press **F5** (or the ▶️ Play button) to start the game from the main scene
   (`res://Scenes/basicEventFlow.tscn`).

---

## 4. Project Structure

```
educational-game/
├── Scripts/           # GDScript autoloads and component logic
│   ├── level.gd              # Level state autoload (Level singleton)
│   ├── ConveyerController.gd # Conveyor & event routing autoload
│   ├── AudioManager.gd       # Sound effects autoload
│   ├── event_box.gd          # Draggable event box behaviour
│   ├── sink.gd / SinkClick.gd # Sink node and click handler
│   ├── broker.gd / broker_area.gd # Broker duplication logic
│   ├── dls.gd / dlqPattern.gd     # Dead Letter Sink / DLQ level
│   ├── transformer_click.gd       # Event transformation logic
│   ├── draggable_filter.gd        # Draggable filter component
│   ├── multi_sink.gd              # Multi-sink helper
│   ├── multisinkkanddls.gd        # Combined multi-sink + DLS level
│   ├── conveyor.gd                # Line2D conveyor visual
│   ├── restart.gd                 # Restart button handler
│   ├── message_display.gd         # HUD message overlay
│   └── event_button.gd            # Event spawn button
├── Scenes/            # Godot scene files (.tscn) for each level
├── Levels/            # Design docs, sketches, level transition diagrams
├── 2D Assets/         # PNG sprites and imported textures
├── Fonts/             # Font resources
├── SoundEffects/      # WAV audio clips
└── project.godot      # Godot project configuration
```

**Autoloads (singletons)** registered in `project.godot`:

| Name | Script | Purpose |
|------|--------|---------|
| `ConveyerController` | `Scripts/ConveyerController.gd` | Global event-routing state |
| `Level` | `Scripts/level.gd` | Level progression & validation |
| `AudioManager` | `Scripts/AudioManager.gd` | Centralised sound playback |

---

## 5. Coding Conventions

### GDScript Style

- Follow the official [GDScript Style Guide](https://docs.godotengine.org/en/4.3/tutorials/scripting/gdscript/gdscript_styleguide.html).
- Use **tabs** (not spaces) for indentation — Godot's editor enforces this.
- **snake_case** for variables, functions, and file names.
- **PascalCase** for class names (when using `class_name`).
- Prefer explicit type annotations (`var foo: int`) for public/exported variables.
- Keep functions short and single-purpose. If a function exceeds ~30 lines,
  consider splitting it.

### Autoload Access

- The three autoloads (`ConveyerController`, `Level`, `AudioManager`) are
  global. Access them by name, e.g. `ConveyerController.initialise()`.
- **Always call autoload `initialise()` / reset methods before triggering a
  scene change**, not after. Scene `_ready()` callbacks fire before any code
  after `change_scene_to_file()` or `reload_current_scene()` returns.

### Signals & Tweens

- Prefer Godot signals over direct function calls between nodes where possible.
- Always `await tween.finished` before modifying tween targets again to avoid
  animation conflicts.
- Use `get_tree().create_tween()` (not `create_tween()`) inside nodes that may
  be freed mid-animation so the tween is owned by the scene tree.

### Comments

- Write comments that explain **why**, not **what**.
- Remove Godot-generated placeholder comments like
  `# Replace with function body.` before committing.
- Use `# TODO:` or `# FIXME:` tags for known issues, with a brief description.

---

## 6. Branching Strategy

| Branch | Purpose |
|--------|---------|
| `main` | Stable, release-ready code |
| `dev/<issue-number>` | Feature or fix work tied to a specific GitHub issue |

Always branch from `main`:

```bash
git fetch upstream
git checkout -b dev/<issue-number> upstream/main
```

---

## 7. Making a Change

1. **Open or find a GitHub issue** for the work you want to do. If none exists,
   create one first and wait for a maintainer to triage it.
2. **Branch** from `main` using the naming convention above.
3. **Make focused, atomic commits.** One logical change per commit.
4. **Use Conventional Commit messages**:

   ```
   <type>(<scope>): <short summary in imperative mood>

   <body — explain WHY this change is needed, not just what it does>

   Signed-off-by: Your Name <your@email.com>
   ```

   Valid types: `feat`, `fix`, `docs`, `test`, `refactor`, `chore`.

5. **Test your change** in Godot 4.3 by playing through all six levels end-to-end.
6. **Push your branch** and open a Pull Request against `main`.

---

## 8. Pull Request Checklist

Before marking your PR as ready for review, confirm each item:

- [ ] Branched from `main`, not from another feature branch.
- [ ] Commit messages follow the Conventional Commits format.
- [ ] Each commit includes a `Signed-off-by:` line (DCO).
- [ ] Placeholder comments (`# Replace with function body.`) have been removed.
- [ ] The game launches without errors in Godot 4.3.
- [ ] All six levels can be played through to completion without regressions.
- [ ] New GDScript files follow the style guide (tabs, snake_case, type hints).
- [ ] PR title follows the Conventional Commit format.
- [ ] PR description links to the relevant GitHub issue (`Closes #<issue-number>`).

---

## 9. Reporting Bugs & Requesting Features

- **Bugs**: Open a GitHub issue with the label `bug`. Include steps to reproduce,
  expected behaviour, actual behaviour, and your Godot version.
- **Feature requests**: Open an issue with the label `enhancement`. Link to the
  relevant EDA pattern in `Levels/brainstorm.md` if applicable.
- **Questions**: Use the
  [#knative-education](https://cloud-native.slack.com/archives/knative) Slack
  channel or open a GitHub Discussion.