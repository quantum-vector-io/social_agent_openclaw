/**
 * Social Content Tool - OpenClaw Plugin
 *
 * Provides:
 * - validate_content: Validate content against platform character/hashtag limits
 * - /platforms: Auto-reply command showing supported platforms and their limits
 */

import { Type } from "@sinclair/typebox";

// Platform-specific limits and rules
const PLATFORM_LIMITS: Record<
  string,
  { maxChars: number; maxHashtags: number; label: string; idealChars?: string }
> = {
  instagram: {
    maxChars: 2200,
    maxHashtags: 30,
    label: "Instagram",
    idealChars: "800-1,500",
  },
  threads: {
    maxChars: 500,
    maxHashtags: 3,
    label: "Threads",
    idealChars: "200-400",
  },
  linkedin: {
    maxChars: 3000,
    maxHashtags: 5,
    label: "LinkedIn",
    idealChars: "1,200-1,800",
  },
  twitter: {
    maxChars: 280,
    maxHashtags: 2,
    label: "X/Twitter",
    idealChars: "200-270",
  },
  tiktok: {
    maxChars: 2200,
    maxHashtags: 6,
    label: "TikTok",
    idealChars: "150-300",
  },
  youtube_title: {
    maxChars: 100,
    maxHashtags: 0,
    label: "YouTube Title",
    idealChars: "60-70",
  },
  youtube_description: {
    maxChars: 5000,
    maxHashtags: 3,
    label: "YouTube Description",
    idealChars: "1,000-2,000",
  },
  telegram: {
    maxChars: 4096,
    maxHashtags: 0,
    label: "Telegram",
    idealChars: "500-2,000",
  },
};

export default function register(api: any) {
  // ──────────────────────────────────────────────
  // Tool: validate_content
  // ──────────────────────────────────────────────
  api.registerTool({
    name: "validate_content",
    description:
      "Validate social media content against platform character limits and hashtag rules. " +
      "Returns character count, limit utilization, hashtag count, and any warnings. " +
      "Use after generating content to verify it meets platform constraints.",
    parameters: Type.Object({
      platform: Type.String({
        description:
          "Target platform: instagram, threads, linkedin, twitter, tiktok, " +
          "youtube_title, youtube_description, telegram",
      }),
      content: Type.String({
        description: "The content text to validate",
      }),
    }),
    async execute(
      _id: string,
      params: { platform: string; content: string }
    ) {
      const limits =
        PLATFORM_LIMITS[params.platform as keyof typeof PLATFORM_LIMITS];

      if (!limits) {
        return {
          content: [
            {
              type: "text",
              text: JSON.stringify(
                {
                  valid: false,
                  error: `Unknown platform: "${params.platform}". Valid options: ${Object.keys(PLATFORM_LIMITS).join(", ")}`,
                },
                null,
                2
              ),
            },
          ],
        };
      }

      const charCount = params.content.length;
      const hashtags = params.content.match(/#\w+/g) || [];
      const hashtagCount = hashtags.length;
      const warnings: string[] = [];
      const suggestions: string[] = [];

      // Character limit check
      if (charCount > limits.maxChars) {
        warnings.push(
          `Over character limit: ${charCount}/${limits.maxChars} (${charCount - limits.maxChars} chars over)`
        );
        suggestions.push(
          `Trim ${charCount - limits.maxChars} characters to fit within the ${limits.maxChars} limit`
        );
      }

      // Hashtag limit check
      if (limits.maxHashtags > 0 && hashtagCount > limits.maxHashtags) {
        warnings.push(
          `Too many hashtags: ${hashtagCount}/${limits.maxHashtags}`
        );
        suggestions.push(
          `Remove ${hashtagCount - limits.maxHashtags} hashtag(s)`
        );
      }

      // No hashtags warning for platforms that don't use them
      if (limits.maxHashtags === 0 && hashtagCount > 0) {
        warnings.push(
          `${limits.label} doesn't use hashtags -- consider removing them`
        );
      }

      // Utilization suggestion
      const utilization = Math.round((charCount / limits.maxChars) * 100);
      if (utilization < 30 && params.platform !== "twitter") {
        suggestions.push(
          `Content is only ${utilization}% of the limit -- consider expanding for more impact`
        );
      }

      return {
        content: [
          {
            type: "text",
            text: JSON.stringify(
              {
                valid: warnings.length === 0,
                platform: limits.label,
                characters: {
                  count: charCount,
                  limit: limits.maxChars,
                  remaining: limits.maxChars - charCount,
                  utilization: `${utilization}%`,
                  idealRange: limits.idealChars,
                },
                hashtags: {
                  count: hashtagCount,
                  limit: limits.maxHashtags,
                  found: hashtags,
                },
                warnings,
                suggestions,
              },
              null,
              2
            ),
          },
        ],
      };
    },
  });

  // ──────────────────────────────────────────────
  // Command: /platforms
  // ──────────────────────────────────────────────
  api.registerCommand({
    name: "platforms",
    description: "Show supported platforms and their content limits",
    handler: () => ({
      text: [
        "<b>Supported Platforms & Limits</b>",
        "",
        "Platform         | Max Chars | Hashtags",
        "─────────────────┼───────────┼─────────",
        "Instagram        | 2,200     | up to 30",
        "Threads          | 500       | 0-3",
        "LinkedIn         | 3,000     | 3-5",
        "X/Twitter        | 280       | 1-2",
        "TikTok           | 2,200     | 3-6",
        "YouTube Title    | 100       | 0",
        "YouTube Desc     | 5,000     | 0-3",
        "Telegram         | 4,096     | 0",
        "",
        "Send me a topic and platform to generate content!",
      ].join("\n"),
    }),
  });
}
