# Available Tools

## Skills
- **social-content-gen**: Main content generation skill with platform reference files. Use for all content generation requests.
- **content-feedback**: Process user feedback on generated content and store as preferences. Use when the user evaluates or critiques content.
- **content-brainstorm**: Guided brainstorming flow for collaborative content ideation. Use for /brainstorm command or when user wants to ideate.

## Custom Tools (Plugin)
- **validate_content**: Programmatically validate content against platform character limits and hashtag rules. Use after generating to verify compliance.

## Commands (Auto-reply, no AI needed)
- **/platforms**: Show supported platforms and their character limits.

## Memory Tools
- **memory_search**: Semantic search across all memory files. Use before generating to recall user preferences.
- **memory_get**: Read a specific memory file directly. Use to check MEMORY.md or daily logs.

## Usage Notes
- Always load the relevant platform reference file before generating content
- Always run memory_search before generation to recall preferences
- Store feedback immediately when received (daily log + MEMORY.md if pattern)
- Use validate_content after generation to double-check limits
