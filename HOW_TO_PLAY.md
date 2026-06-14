# How to Play

## 1. Introduction

The **Knative Educational Game** is an interactive puzzle game built with [Godot Engine 4.3](https://godotengine.org/download/archive/4.3-stable/) that teaches **Event-Driven Architecture (EDA)** concepts through hands-on gameplay.

The game is part of the [knative-extensions](https://github.com/knative-extensions) project and was developed during the LFX Mentorship program. It makes abstract EDA concepts — event routing, filtering, dead letter queues, and event transformation — tangible by turning them into visual, interactive puzzles.

No prior knowledge of Knative or EDA is required. Each level introduces a new concept, and players learn by experimenting with event routes and observing the results.

---

## 2. Goal of the Game

The player's objective is to **correctly route events from a Broker to the appropriate Sink(s)** in each level. As levels progress, new mechanics are introduced:

- **Route events** by creating conveyor paths between components.
- **Match event types** to the correct destinations (color-coded).
- **Use filters** to block unwanted events from reaching the wrong sink.
- **Handle failed events** using a Dead Letter Queue (DLQ).
- **Transform events** before they reach their final destination.

Each level teaches a specific [Knative Eventing](https://knative.dev/docs/eventing/) concept. Complete all level objectives to finish the game.

---

## 3. Core Concepts

These are the key components players interact with during gameplay:

### Event (Event Box)

Events are represented as **colored boxes** on screen. Each event has a **type** indicated by its color:

| Color | Label |
|-------|-------|
| Red | EVENT R |
| Blue | EVENT B |
| Green | EVENT G |

Hover over an event box to see its type label. In EDA terms, these represent messages or data payloads flowing through the system.

> **Source:** Event types and labels are defined in `Scripts/event_box.gd`.

### Broker

The **Broker** is the central routing hub. In Knative Eventing, a Broker receives events and distributes them to subscribers based on configured triggers.

In the game, the Broker:
- Acts as the **starting point** for creating event routes — click it to select it as the source.
- When multiple sinks are connected, the Broker **duplicates events** so each route receives a copy.
- In the transformation level, the Broker receives transformed events returning from the Transformer before re-routing them.

> **Source:** `Scripts/broker_area.gd` (click-to-select), `Scripts/broker.gd` (event duplication and return handling).

### Sink

A **Sink** is the destination where events are delivered. Each Sink has an **expected event type** (`expectedType`). In levels that require type matching, events must arrive at the sink that matches their type for the level to succeed.

> **Source:** `Scripts/sink.gd` defines the `expectedType` export. `Scripts/SinkClick.gd` checks `boxType != expectedType` on arrival.

### Conveyor (Event Route)

**Conveyors** are the visual paths (drawn as `Line2D` nodes) that events travel along. They are created by:
1. Clicking the **Broker** (to select it as the source).
2. Clicking a **Sink** or **Transformer** (to set it as the destination).

Events animate linearly along conveyor paths when the level starts.

> **Source:** `Scripts/ConveyerController.gd` (`create_conveyor()`, `send_event()`).

### Filter

**Filters** are draggable components that can be positioned on the game field. Each filter has a specific **color** (e.g., Blue, Red, Green). When an event passes through a filter:

- If the event's type **matches** the filter color → the event **passes through**.
- If the event's type **does not match** → the event is **destroyed** (with a "poof" sound effect).

Filters teach the concept of Knative **Triggers with filter attributes**.

> **Source:** `Scripts/draggable_filter.gd` — destroys events where `boxType != filterColor`.

### Dead Letter Sink (DLS / DLQ)

The **Dead Letter Sink** (DLS) handles events that cannot be delivered normally. In the DLQ level:

- A **blockage** prevents events from reaching the normal sink.
- The player must **click the DLS** to create an alternative route from the blockage to the DLS.
- Blocked events are then redirected to the Dead Letter Sink.
- If the DLS is not clicked, blocked events stop at the blockage with no fallback.

This teaches the Knative concept of a Dead Letter Queue — a fallback destination for undeliverable events.

> **Source:** `Scripts/dlqPattern.gd` (blockage handling, DLS click, event redirection).

### Transformer

The **Transformer** modifies events before they continue their route. In the transformation level:

- Events are routed to the Transformer first.
- The Transformer **changes the event's type and appearance** (e.g., the texture and `boxType` are updated).
- The transformed event then **returns to the Broker** automatically, where it can be re-routed to a final sink.

This teaches the EDA concept of event transformation — modifying event data in-flight before delivery.

> **Source:** `Scripts/transformer_click.gd` — changes `boxType`, updates texture, tweens event back to broker position.

---

## 4. Quick Start

```
Broker
  ↓
Sink
  ↓
Create Route
  ↓
Start
  ↓
Event Flow
  ↓
Success / Retry
```

### Step-by-Step

1. **Click the Broker** — Selects it as the route source.
2. **Click a Sink (or Transformer)** — Creates a conveyor route from the Broker to that destination.
3. **(If present) Position Filters** — Drag color-coded filters to intercept event paths.
4. **(If present) Click the Dead Letter Sink** — Establishes the DLQ fallback route.
5. **Press Start** — The Broker duplicates events (if multiple routes exist) and begins sending them along conveyors.
6. **Watch events travel** — Events animate along routes. Filters destroy non-matching events.
7. **Check the result** — The game displays **"Success"** or **"Failed. Try Again"**.

---

## 5. Understanding Success and Failure

### What Causes Success

The game evaluates the following conditions (varying by level):

| Condition | When Required | Description |
|-----------|---------------|-------------|
| **Sink used** | All levels | At least one event must reach a sink. |
| **Event-type matching** | Levels 2, 3, 5 | Every event that arrives must match the sink's `expectedType`. Any mismatch fails the level. |
| **DLS used** | Level 4 | The Dead Letter Sink must receive blocked events. |
| **Transformer used** | Level 5 | Events must pass through the Transformer, and transformed events must match the sink type. |

On success: a **"Success"** message displays, a level-clear sound plays, and the game advances to the next level.

> **Source:** `Scripts/level.gd` — `sinkBoxMatchNeeded`, `dlsRequired`, `transformerRequired` arrays define per-level conditions; `next_level()` evaluates them.

### What Causes Failure

- **No events reach any sink** — no conveyor routes were created.
- **Event-type mismatch** — an event arrives at a sink expecting a different type.
- **DLS not used** — in the DLQ level, the DLS was not clicked before starting.
- **Transformer not used** — in the transformation level, events were not routed through the Transformer.

On failure: a **"Failed. Try Again"** message displays and a failure sound plays. Use the **Restart** button to reload the current level.

---

## 6. Current Playable Levels

The game contains **5 implemented levels** played sequentially:

| # | Scene Name | Pattern |
|---|------------|---------|
| 1 | `basicEventFlow` | Basic Event Flow |
| 2 | `boxClick` | Using Filters |
| 3 | `multiSink` | Filters with Multiple Sinks |
| 4 | `dlqPattern` | Dead Letter Queue |
| 5 | `transformation_level` | Event Transformation |

After completing all levels, an end-of-game screen is displayed.

> **Source:** `Scripts/level.gd` — `levels` array defines the order; each entry maps to a `.tscn` file in `Scenes/`.

---

### Level 1 — Basic Event Flow

**Concept:** Events travel from a source through a Broker to a Sink.

**Objective:** Create a route from the Broker to the Sink and deliver the events.

**How to Complete:**
1. Click the **Broker** to select it.
2. Click the **Sink** to create a conveyor route.
3. Press **Start**.
4. Events travel to the Sink → level succeeds.

**Key Lesson:** The simplest EDA pattern — events flow from a source to a destination through a broker. No type matching is required (`sinkBoxMatchNeeded[0] = false`).

> **Scene:** Contains 1 Broker, 1 Sink (default type "Blue"), 2 event boxes (Red + Blue), 1 conveyor.

---

### Level 2 — Using Filters

**Concept:** Events are selectively processed based on type using Triggers and Filters.

**Objective:** Route events to the Sink while using a filter to block events that don't match the Sink's expected type.

**How to Complete:**
1. Click the **Broker** to select it.
2. Click the **Sink** to create a conveyor route.
3. **Drag a filter** into a position where it intercepts events traveling along the route.
4. Press **Start**.
5. Non-matching events are destroyed by the filter; matching events pass through.

**Common Mistakes:**
- Forgetting to position the filter, allowing mismatched events to reach the sink.
- Placing the filter where it does not intercept the event path.

**Key Lesson:** Filters act as Knative Triggers with filter attributes — they selectively allow events based on type.

> **Scene:** Contains 1 Broker, 1 Sink (expectedType "Blue"), 2 event boxes (Red + Blue), 2 draggable filters, 1 conveyor.

---

### Level 3 — Using Filters with Multiple Sinks

**Concept:** Events are routed to multiple sinks, each expecting a specific event type.

**Objective:** Create routes to multiple sinks and position filters so each sink only receives its expected event type.

**How to Complete:**
1. Click the **Broker**, then click the **first Sink** to create a route.
2. Click the **Broker** again, then click the **second Sink** (repeat for additional sinks).
3. **Drag the color-coded filters** so each route only allows the correct event type through.
4. Press **Start**.
5. The Broker duplicates events across routes. Filters destroy mismatched events on each path.

**Common Mistakes:**
- Creating routes but forgetting to place filters, causing type mismatches.
- Swapping which filter goes on which route.

**Key Lesson:** In Knative Eventing, multiple Triggers can subscribe to a Broker with different filter criteria, routing events to different services.

> **Scene:** Contains 1 Broker, 3 Sinks (Blue, Red, Green), 3 event boxes (Blue, Red, Green), 3 filters (Blue, Red, Green), 3 conveyors.

---

### Level 4 — Dead Letter Queue (DLQ) Pattern

**Concept:** Events that cannot be delivered normally are redirected to a Dead Letter Queue.

**Objective:** Handle blocked events by routing them to the Dead Letter Sink (DLS).

**How to Complete:**
1. **Click the Dead Letter Sink (DLS)** to create a fallback route from the blockage to the DLS.
2. Create the primary route from the **Broker** to the **Sink**.
3. Press **Start**.
4. Events travel toward the Sink but hit the **blockage**.
5. Because the DLS route is configured, blocked events are redirected to the Dead Letter Sink.

**Common Mistakes:**
- Forgetting to click the DLS, leaving blocked events with no fallback.
- Only creating the primary route without the DLS fallback.

**Key Lesson:** In production EDA systems, a Dead Letter Queue prevents data loss by capturing events that fail delivery.

> **Scene:** Contains 1 Broker, 1 Sink, 1 DLS, 1 Blockage, 2 event boxes (Red + Blue), 1 conveyor + 1 DLS conveyor.

---

### Level 5 — Event Transformation

**Concept:** Events are modified (transformed) before reaching their final destination.

**Objective:** Route events through a Transformer, which changes their type, then deliver the transformed events to a Sink that expects the transformed type.

**How to Complete:**
1. Click the **Broker** to select it.
2. Click the **Transformer** to create a route (Broker → Transformer).
3. Click the **Broker** again, then click the **Sink** to create a second route (Broker → Sink).
4. **Position filters** to control which events reach the Sink after transformation.
5. Press **Start**.
6. Events travel to the Transformer, where they are transformed (type and appearance change).
7. Transformed events return to the Broker automatically.
8. The Broker re-sends transformed events along the second route to the Sink.

**Common Mistakes:**
- Routing directly to the Sink without going through the Transformer first.
- Forgetting to create the second route from Broker to Sink after transformation.
- Not accounting for the **transformed** event type when positioning filters.

**Key Lesson:** Event transformation is a common EDA pattern — middleware modifies events in-flight (e.g., enriching data, changing formats, or translating schemas).

> **Scene:** Contains 1 Broker, 1 Transformer, 1 Sink (expectedType "PinkRect"), 1 event box (type "YellowRect"), 2 filters ("PinkRect" + "YellowRect"), 2 conveyors. Uses timer-based evaluation (`olderlevels = false`).

---

## 7. Planned Future Levels

The following EDA patterns are documented in [Levels/brainstorm.md](./Levels/brainstorm.md) but are **not yet implemented**:

| Pattern | Concept |
|---------|---------|
| **Sequence Pattern** | Events pass through multiple steps in a predefined order. |
| **Retry Pattern** | Failed events are retried to ensure eventual processing. |
| **DataRef Pattern** | Large payloads are replaced with references to stored data. |
| **Outbox Pattern** | Events are recorded before publishing to prevent data loss. |
| **Multi-Broker Setup** | Events are routed through multiple brokers. |
| **Multi-Sink + DLQ** | Combines multiple sinks with the Dead Letter Queue pattern. |

Level transition designs for some of these are in `Levels/Level Transitions/`.

> **Source:** `Levels/brainstorm.md` — sections A (Key EDA Patterns), C (Level Transition Ideas), and F (Future Works).

---

## 8. Tips for New Contributors

- **Read [Levels/brainstorm.md](./Levels/brainstorm.md)** — Design vision, sketches, level transition ideas, and references.

- **Run the game locally** — Follow the [README](./README.md) setup instructions and play through all levels.

- **Experiment** — Try wrong routes intentionally to understand type matching and failure conditions.

- **Key files to explore:**
  - `Scripts/level.gd` — Level order, progression, and success/failure evaluation.
  - `Scripts/ConveyerController.gd` — Conveyor creation and event routing (autoloaded singleton).
  - `Scripts/broker.gd` — Event duplication and return handling.
  - `Scripts/SinkClick.gd` — Sink interaction and type matching.
  - `Scripts/draggable_filter.gd` — Filter drag-and-drop and event filtering.
  - `Scripts/dlqPattern.gd` — Blockage and DLS routing.
  - `Scripts/transformer_click.gd` — Event transformation and return-to-broker.
  - `Scripts/event_box.gd` — Event types and visual labels.

- **Understand the autoloads** — Three singletons are defined in `project.godot`: `ConveyerController`, `Level`, and `AudioManager`.

---

## Additional Resources

- [Knative Eventing Documentation](https://knative.dev/docs/eventing/)
- [Knative Community](https://knative.dev/docs/community/)
- [Godot Engine 4.3 Documentation](https://docs.godotengine.org/en/4.3/)
- [CONTRIBUTING.md](./CONTRIBUTING.md)
