# Knative Educational Game

An educational game to teach Knative Eventing concepts through interactive gameplay, primarily focused around Event Driven Architectures.

[![Slack Status](https://img.shields.io/badge/slack-join_chat-white.svg?logo=slack&style=social)](https://communityinviter.com/apps/cloud-native/cncf)

## Overview

This game teaches fundamental Event Driven Architecture (EDA) patterns through hands-on puzzles where players route events from sources through brokers to sinks. Players learn concepts like:

- **Basic Event Flow** - Events travel from sources to brokers and are delivered to sinks
- **Triggers and Filters** - Events are processed based on specific conditions
- **Dead Letter Queue (DLQ)** - Failed events are moved to a DLQ for alternative processing

## Requirements

- [Godot Engine 4.3](https://godotengine.org/download/) or later

## Running the Game

1. **Download Godot Engine 4.3** from [godotengine.org/download](https://godotengine.org/download/)
   - Select the **Standard** version for your operating system
   - Extract the downloaded zip file

2. **Open Godot Engine**
   - Run the Godot executable
   - In the Project Manager, click **Import**
   - Navigate to the cloned `educational-game` folder
   - Select the `project.godot` file and click **Import & Edit**

3. **Run the game**
   - Press **F5** or click the **▶️ Play** button in the top-right corner

## Contributing

If you are interested in contributing, see [CONTRIBUTING.md](./CONTRIBUTING.md).

For design documentation and planned features, see [Levels/brainstorm.md](./Levels/brainstorm.md).

## More Information

- [Knative Eventing Documentation](https://knative.dev/docs/eventing/)
- [Knative Community](https://knative.dev/docs/community/)
