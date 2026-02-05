---
name: content-feedback
description: >
  Process user feedback on generated social media content. Use when the user
  comments on content quality, requests changes, rates content, or uses
  evaluative language like "too formal", "more hashtags", "shorter", "not my
  style", "love it", "perfect", or "change the tone". Stores feedback as
  persistent memory for future content generation improvement.
---

# Content Feedback Processor

## When to Activate
- User comments on recently generated content (positive or negative)
- User explicitly uses `/feedback` command
- User uses evaluative language about content quality
- User requests specific changes to generated content

## Feedback Processing Workflow

### Step 1: Identify Feedback Category

| Category | Signal Words |
|----------|-------------|
| **Tone** | too formal, too casual, more professional, more fun, too serious, lighter |
| **Length** | too long, too short, more detailed, more concise, shorter, expand |
| **Hashtags** | more hashtags, fewer hashtags, different hashtags, no hashtags |
| **Structure** | different format, more bullet points, add CTA, rearrange, less listy |
| **Content** | different angle, more personal, more data, more storytelling, off-topic |
| **Positive** | love it, perfect, great, exactly right, nailed it, keep doing this |

### Step 2: Acknowledge and Act

1. Acknowledge the specific feedback ("Got it -- you want a more casual tone for LinkedIn.")
2. If actionable, **immediately regenerate** improved content
3. Show the comparison: "Here's the updated version:"

### Step 3: Store in Memory

**Daily log** (`memory/YYYY-MM-DD.md`):
```
## Feedback - [time]
- Platform: [platform]
- Category: [tone/length/hashtags/structure/content]
- Feedback: "[exact user words]"
- Action: [what was changed]
```

**Long-term preferences** (`MEMORY.md`):
Update only when a clear pattern emerges (3+ similar feedback items):
```
### [Platform]
- [Date]: [Preference description]
  Example: "2026-02-05: LinkedIn - User prefers conversational tone over formal"
```

**Positive feedback** also stored:
```
## Successful Content Patterns
- [Date]: [Platform] - [What worked and why]
```

### Step 4: Confirm Learning
Tell the user: "I've noted this preference. Next time I generate [platform] content, I'll [apply the learned preference]."

## Feedback-to-Action Mapping

| Feedback | Immediate Action |
|----------|-----------------|
| "Too formal" | Regenerate with casual, conversational language |
| "Too long" | Cut by 30-40%, keep only the strongest points |
| "More hashtags" | Add hashtags up to platform maximum |
| "Different angle" | Ask what angle they prefer, then regenerate |
| "Love it" | Store the pattern as a successful template |
| "Not my style" | Ask what their style is, store for future reference |
