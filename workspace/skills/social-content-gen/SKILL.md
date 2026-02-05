---
name: social-content-gen
description: >
  Generate optimized social media content for Instagram, Threads, LinkedIn,
  X/Twitter, TikTok, YouTube, and Telegram. Use when the user asks to create,
  write, draft, or generate posts, captions, descriptions, titles, or content
  for any social media platform. Also use when adapting content across multiple
  platforms or when the user says "all platforms" or "cross-post".
---

# Social Content Generator

## Quick Reference: Platform Limits

| Platform  | Max Chars | Hashtags | Key Rule |
|-----------|-----------|----------|----------|
| Instagram | 2,200     | up to 30 | Visual-first, hook in line 1, hashtag block at end |
| Threads   | 500       | 0-3      | Conversational, casual, no hashtag blocks |
| LinkedIn  | 3,000     | 3-5      | Professional, thought leadership, structured |
| X/Twitter | 280       | 1-2      | Punchy, every word counts, threads for depth |
| TikTok    | 2,200     | 3-6      | Hook-driven, Gen-Z friendly, trending tags |
| YouTube   | Title 100, Desc 5,000 | 0-3 | SEO-first, timestamps, keywords |
| Telegram  | 4,096     | 0        | Rich formatting (bold/italic/code), long-form |

## Generation Workflow

1. **Identify platforms** from the user's request
   - If no platform specified, ask: "Which platform(s)? Or I can generate for all 7."
2. **Load reference files** for each target platform from `{baseDir}/references/`:
   - Instagram: `references/instagram.md`
   - Threads: `references/threads.md`
   - LinkedIn: `references/linkedin.md`
   - X/Twitter: `references/twitter.md`
   - TikTok: `references/tiktok.md`
   - YouTube: `references/youtube.md`
   - Telegram: `references/telegram-content.md`
3. **Search memory** for user preferences: `memory_search("content preferences [platform]")`
4. **Generate content** following platform-specific rules from the reference file
5. **Validate** character count against platform limit
6. **Present** using the output format below

## Output Format

For each platform, present content exactly as:

---

**[Platform Name]** (X/Y characters)

[Generated content here]

---

After all platforms, add:
"Want me to adjust the tone, length, or adapt this for other platforms?"

## Multi-Platform Generation

When generating for multiple platforms:
- Adapt the **core message** to each platform's unique style
- Do NOT copy-paste the same text across platforms
- Instagram gets hashtags and emojis; LinkedIn gets professional structure; Twitter gets punchy brevity
- Present each platform's content separated by horizontal rules
- Show character count for every platform

## Content Quality Checklist

Before presenting any content, verify:
- [ ] Character count is within platform limit
- [ ] Hashtag count respects platform rules
- [ ] First line is a compelling hook
- [ ] Tone matches platform culture
- [ ] Contains a call-to-action appropriate for the platform
- [ ] Formatting follows platform conventions (line breaks, emojis, structure)
