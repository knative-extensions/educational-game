This document outlines the key Event-Driven Architecture (EDA) patterns that will be incorporated into the game to teach players fundamental event-driven concepts, the rough sketches for the patterns, level transition ideas and the summary of all the works done during the LFX Mentorship- [Design and Implement Levels for Educational Game](https://github.com/knative-extensions/educational-game/issues/8).
## Contents
[A. Key EDA Patterns for the Game](#a-key-eda-patterns-for-the-game) <br>
[B. Rough Sketches for the EDA Patterns](#b-rough-sketches-for-the-eda-patterns) <br>
[C. Level Transition Ideas](#c-level-transition-ideas) <br>
[D. New Assets Created](#d-new-assets-created) <br>
[E. Levels Implemented](#e-levels-implemented) <br>
[F. Future Works](#f-future-works) <br>
[G. References used](#g-references-used) <br>

# A. Key EDA Patterns for the Game

## 1. Basic Event Flow

Concept: Events travel from sources to brokers and are eventually delivered to sinks.

## 2. Triggers and Filters

Concept: Events are processed based on specific conditions.

## 3. Event Transformation Pattern

Concept: Events can be modified before reaching their final destination.

## 4. Sequence Pattern

Concept: Events must pass through multiple steps in a predefined order before completion.

## 5. Retry Pattern

Concept: Failed events are retried to ensure eventual processing.

## 6. Dead Letter Queue (DLQ) Pattern

Concept: Events that fail multiple times are moved to a DLQ for manual review or alternative processing.

## 7. DataRef Pattern

Concept: Large event payloads are replaced with references to stored data to optimize processing.

## 8. Outbox Pattern

Concept: Ensures events are reliably recorded before being published, preventing data loss.

## 9. Multi-Broker Setup

Concept: Events can be routed through multiple brokers before final processing.

# B. Rough Sketches for the EDA Patterns

## 1. Transformation Pattern
### Sketch
![Transformation Pattern Sketch](./Rough%20Sketches%20for%20EDA%20Patterns/Rough%20Sketches%201.png)
### Reference
![Transformation Pattern Reference](./Rough%20Sketches%20for%20EDA%20Patterns/Rough%20Sketches%202.png)

## 2. Sequence Pattern
### Sketch
![Transformation Pattern Sketch](./Rough%20Sketches%20for%20EDA%20Patterns/Rough%20Sketches%203.png)
### Reference
![Transformation Pattern Reference](./Rough%20Sketches%20for%20EDA%20Patterns/Rough%20Sketches%204.png)

## 2. Dead Letter Queue Pattern
### Sketch
![Transformation Pattern Sketch](./Rough%20Sketches%20for%20EDA%20Patterns/Rough%20Sketches%205.png)
### Reference
![Transformation Pattern Reference](./Rough%20Sketches%20for%20EDA%20Patterns/Rough%20Sketches%206.png)

# C. Level Transition Ideas

## Level 1- Basic Event Flow
![Basic Event Flow Level](./Level%20Transitions/Knative%20Level%20Transitions-1.png)

## Level 2- Using Filters
![Using Filters](./Level%20Transitions/Knative%20Level%20Transitions-2.png)

## Level 3- Using Filters With Multiple Sinks
![Using Filters With Multiple Sinks](./Level%20Transitions/Knative%20Level%20Transitions-3.png)

## Level 4- DLQ Pattern
![DLQ Pattern](./Level%20Transitions/Knative%20Level%20Transitions-4.png)

## Level 5- Using Filters With Multiple Sinks and DLQ Pattern
![Using Filters With Multiple Sinks and DLQ Pattern](./Level%20Transitions/Knative%20Level%20Transitions-5.png)

## Level 6- Transformation Pattern
![Transformation Pattern](./Level%20Transitions/Knative%20Level%20Transitions-6.png)

# D. New Assets Created
### Representation of Blockage and Dead Letter Sink. ([#25](https://github.com/knative-extensions/educational-game/pull/25) , [#34](https://github.com/knative-extensions/educational-game/pull/34))
### Representation of Transformation Function. ([#25](https://github.com/knative-extensions/educational-game/pull/25) , [#34](https://github.com/knative-extensions/educational-game/pull/34))

# E. Levels Implemented

### Level 1- Basic Event Flow ([#36](https://github.com/knative-extensions/educational-game/pull/36))
### Level 2- Using Filters ([#36](https://github.com/knative-extensions/educational-game/pull/36))
### Level 3- Using Filters With Multiple Sinks ([#36](https://github.com/knative-extensions/educational-game/pull/36))
### Level 4- DLQ Pattern ([#28](https://github.com/knative-extensions/educational-game/pull/28))

# F. Future Works
## Design a representation of Broker
Currently, the game has all the logic of a broker, however, it lacks a representation. The next task could be designing a representation of a broker and attach the necessary scripts containing the logic to the asset representing the broker.

## Implement the Patterns and Levels already designed
The Transformation and Sequence pattern were designed in the mentorship, along with level transition ideas for these patterns. The level combining Multi Sink and DLQ Pattern was also designed. These patterns and levels will be implemented in the future.

## Design and Implement the remaining key EDA Patterns
Other EDA Patterns like the DataRef Pattern and Outbox Pattern will be designed and implemented in the future.

<br> <br>
This is the summary of the work done during the LFX Mentorship- [Design and Implement Levels for Educational Game](https://github.com/knative-extensions/educational-game/issues/8).<br>
Mentee- [Ankita Jana](https://github.com/ankitajana21).<br>
Mentor(s)- [Calum Murray](https://github.com/Cali0707), [Zainab Husain](https://github.com/zainabhusain227), [Angelina Zhai](https://github.com/AngelinaZhai).

# G. References used:

1. [Declarative Event-Driven-Application Patterns with Knative Eventing - Pierangelo Di Pilato & Matthias Wessendorf](https://www.youtube.com/watch?v=MqRy8J1WI3w)
2. [Gamifying Cloud Native: How to Design and Build an Educational Game for Your Project - Calum Murray, University of Toronto, Faculty of Applied Science and Engineering & Zainab Husain, OCAD University](https://youtu.be/TTBKh6F4v-g?si=MRmx6a2YJsl7y0Q-)
3. [Enterprise Integration Patterns- Messaging Patterns](https://www.enterpriseintegrationpatterns.com/patterns/messaging/)
4. [Knative Eventing Documentation](https://knative.dev/docs/eventing/)
5. [Godot 4.3 Docs](https://docs.godotengine.org/en/4.3/)
