This document outlines the key Event-Driven Architecture (EDA) patterns that will be incorporated into the game to teach players fundamental event-driven concepts. These patterns will be introduced progressively through interactive levels, ensuring an engaging and educational experience.

# Key EDA Patterns for the Game

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

## 10. Autoscaling and High-Throughput Processing

Concept: Systems dynamically scale to handle increased event load.
