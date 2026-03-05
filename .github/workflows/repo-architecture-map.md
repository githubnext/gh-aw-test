---
name: Repository Architecture Map
description: Weekly code architecture analysis and visualization posted as a GitHub Issue

on:
  schedule: weekly

permissions:
  contents: read

safe-outputs:
  create-issue:
    max: 1

network:
  allowed:
    - defaults
    - node

engine: copilot
---

# Repository Architecture Map Generator

You are an AI agent that analyzes the repository structure and generates a comprehensive code architecture map.

## Your Task

Create a detailed architecture overview of this repository that includes:

1. **Repository Overview**
   - Brief description of what this repository does
   - Primary programming language(s) and frameworks
   - Key technologies and tools used

2. **Directory Structure**
   - High-level folder organization
   - Purpose of each major directory
   - Key configuration files and their roles

3. **Code Architecture**
   - Main components/modules and their responsibilities
   - How components interact with each other
   - Entry points and main execution flows
   - Key design patterns used

4. **Dependencies & Integrations**
   - External libraries and frameworks
   - APIs or services integrated
   - Build tools and development dependencies

5. **Testing & Quality**
   - Test structure and organization
   - CI/CD configuration
   - Linting and quality tools

## Analysis Guidelines

- Use `bash` commands to explore the repository structure (`find`, `tree`, `ls`, `cat`, etc.)
- Read key files like `package.json`, `README.md`, configuration files
- Identify the main entry points by examining package.json scripts or similar
- Look for common patterns in file organization
- Identify architectural patterns (MVC, microservices, monolith, etc.)

## Output Format

Create a GitHub issue with:

**Title:** `📐 Repository Architecture Map - [Current Date]`

**Body:** A well-formatted markdown document with:
- Clear sections with emoji headers
- Code blocks for directory trees
- Mermaid diagrams if helpful for visualizing component relationships
- Links to key files in the repository
- Summary of architectural decisions and patterns

## Example Output Structure

```markdown
# 🏗️ Repository Architecture Overview

## 📦 Project Type
[Describe what this repo does]

## 🗂️ Directory Structure
[Tree or list of main directories with descriptions]

## 🔧 Core Components
[Main modules/components and their purposes]

## 🔗 Component Interactions
[How pieces fit together - consider a Mermaid diagram]

## 📚 Key Dependencies
[Important libraries and frameworks]

## 🧪 Testing Strategy
[Test organization and tools]

## 🚀 Build & Deploy
[Build scripts and deployment configuration]

## 💡 Architectural Highlights
[Notable patterns, decisions, or design choices]
```

## Important Notes

- Focus on providing actionable insights, not just listing files
- Highlight architectural decisions and patterns
- Keep the map concise but comprehensive
- Make it useful for new developers joining the project
- Update this weekly to track architectural evolution

## Safety

Use the `create-issue` safe output to post your architecture map. The issue will be automatically created with your generated content.
