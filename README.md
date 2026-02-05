# Social Content Agent

A local AI-powered social media content generation agent built on [OpenClaw AI](https://openclaw.ai/). Communicate via **Telegram** to generate platform-optimized content for 7 social networks.

## What It Does

- Generates tailored content for **Instagram, Threads, LinkedIn, X/Twitter, TikTok, YouTube, and Telegram**
- Respects each platform's character limits, hashtag rules, tone, and formatting conventions
- **Two modes**: Quick generation (topic in, posts out) and conversational brainstorming
- **Self-learning**: Remembers your preferences, learns from feedback, improves over time
- Runs **100% locally** -- your data stays on your machine

## Architecture

```
You (Telegram) ──> OpenClaw (local) ──> AI Model (OpenAI GPT-4o)
                        |
                   ┌────┴────┐
                Skills    Memory
              (platform   (preferences,
              knowledge)   feedback)
```

## Platform Limits

| Platform  | Max Chars | Hashtags | Tone |
|-----------|-----------|----------|------|
| Instagram | 2,200     | up to 30 | Authentic, visual, emoji-friendly |
| Threads   | 500       | 0-3      | Casual, conversational |
| LinkedIn  | 3,000     | 3-5      | Professional, thought leadership |
| X/Twitter | 280       | 1-2      | Punchy, direct, opinionated |
| TikTok    | 2,200     | 3-6      | Gen-Z friendly, hook-driven |
| YouTube   | Title 100, Desc 5,000 | 0-3 | SEO-focused, structured |
| Telegram  | 4,096     | 0        | Rich formatting, long-form |

---

## Setup Guide

### Prerequisites

- **Windows 10/11** with WSL2 (Windows Subsystem for Linux)
- **OpenAI API key** (get one at https://platform.openai.com/api-keys)
- **Telegram account**

### Step 1: Install WSL2 (if not already installed)

Open **PowerShell as Administrator** and run:

```powershell
wsl --install
```

Restart your computer, then set up the Ubuntu distribution that opens automatically.

### Step 2: Install Node.js 22+ in WSL2

Open your WSL2 terminal (Ubuntu) and run:

```bash
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt-get install -y nodejs
node --version   # Should show v22+
```

### Step 3: Install OpenClaw

```bash
npm install -g openclaw@latest
openclaw --version
```

### Step 4: Create Your Telegram Bot

1. Open Telegram on your phone or desktop
2. Search for **@BotFather** (verified bot with a blue checkmark)
3. Send `/start` to BotFather
4. Send `/newbot`
5. When asked for a name, type: `Social Content Agent` (or your preferred name)
6. When asked for a username, type something ending in `bot`, e.g.: `my_content_agent_bot`
7. BotFather will reply with your **bot token** -- it looks like: `123456789:ABCdefGhIjKlMnOpQrStUvWxYz`
8. **Copy this token** -- you'll need it in the next step

**Optional but recommended:**
- Send `/setdescription` to BotFather, then describe your bot
- Send `/setcommands` to BotFather, then paste:
  ```
  generate - Generate content for a topic
  brainstorm - Start a brainstorming session
  platforms - List supported platforms and limits
  preferences - View your saved preferences
  feedback - Give feedback on generated content
  new - Start a fresh conversation
  ```

### Step 5: Find Your Telegram User ID

You need your numeric Telegram user ID for security (so only you can use the bot).

**Method 1** -- Use a bot:
1. Search for `@userinfobot` on Telegram
2. Send it any message
3. It replies with your user ID (a number like `123456789`)

**Method 2** -- Use the Bot API:
1. Send any message to YOUR new bot on Telegram
2. In your terminal, run:
   ```bash
   curl "https://api.telegram.org/bot<YOUR_BOT_TOKEN>/getUpdates"
   ```
3. Look for `"from":{"id":123456789}` in the response

### Step 6: Deploy the Agent

From WSL2, navigate to the project directory:

```bash
# If your Windows project is at F:\development\social_agent:
cd /mnt/f/development/social_agent

# Run the deployment script
bash scripts/deploy.sh
```

The script will:
1. Check prerequisites (Node.js, OpenClaw)
2. Create `~/.openclaw/.env` from the template (first run only)
3. Deploy configuration and workspace files
4. Install the content validation plugin
5. Validate the setup

### Step 7: Configure Your Credentials

Edit the environment file:
```bash
nano ~/.openclaw/.env
```

Fill in your actual values:
```
OPENAI_API_KEY=sk-your-actual-key-here
TELEGRAM_BOT_TOKEN=123456789:ABCdefGhIjKlMnOpQrStUvWxYz
```

Edit the config to add your Telegram user ID:
```bash
nano ~/.openclaw/openclaw.json
```

Find `YOUR_TELEGRAM_USER_ID` and replace it with your numeric ID (e.g., `"123456789"`).

### Step 8: Start the Agent

```bash
openclaw gateway
```

Now open Telegram, find your bot, and send a message!

---

## Usage

### Quick Generation
Just send a topic and platform:

```
Write a LinkedIn post about remote work productivity
```

```
Create Instagram and Twitter posts about AI trends
```

```
Generate posts about mindfulness for all platforms
```

### Brainstorming Mode
Start a collaborative session:

```
/brainstorm
```

The bot will guide you through topic selection, angle options, drafting, and refinement.

### Bot Commands
- `/generate` -- Generate content for a topic
- `/brainstorm` -- Start a brainstorming session
- `/platforms` -- View platform limits and rules
- `/preferences` -- See your saved preferences
- `/feedback` -- Give feedback on content
- `/new` -- Start a fresh conversation

### Teaching the Bot
The agent learns from your feedback:

```
Make it more casual
Too long, shorten it
I prefer fewer hashtags on LinkedIn
Love this style, keep doing this
```

Preferences are stored persistently and applied to all future content.

---

## Project Structure

```
social_agent/
├── README.md                              # This file
├── .env.example                           # Environment variable template
├── config/
│   └── openclaw.json5                     # OpenClaw configuration
├── workspace/                             # Agent workspace files
│   ├── AGENTS.md                          # Operating instructions
│   ├── SOUL.md                            # Agent persona
│   ├── USER.md                            # User profile (auto-populated)
│   ├── IDENTITY.md                        # Bot identity
│   ├── TOOLS.md                           # Tools reference
│   ├── MEMORY.md                          # Long-term memory
│   ├── memory/                            # Daily session logs
│   ├── skills/
│   │   ├── social-content-gen/            # Main content generation skill
│   │   │   ├── SKILL.md                   # Generation orchestrator
│   │   │   └── references/                # Platform-specific rules
│   │   │       ├── instagram.md
│   │   │       ├── threads.md
│   │   │       ├── linkedin.md
│   │   │       ├── twitter.md
│   │   │       ├── tiktok.md
│   │   │       ├── youtube.md
│   │   │       └── telegram-content.md
│   │   ├── content-feedback/              # Feedback processing
│   │   │   └── SKILL.md
│   │   └── content-brainstorm/            # Brainstorming sessions
│   │       └── SKILL.md
│   └── .openclaw/extensions/
│       └── social-content-tool/           # Validation plugin
│           ├── openclaw.plugin.json
│           ├── index.ts
│           └── package.json
└── scripts/
    └── deploy.sh                          # Deployment script
```

## Troubleshooting

**Bot doesn't respond:**
- Check that the gateway is running: `openclaw gateway status`
- Check logs: `openclaw logs --follow`
- Verify Telegram connection: `openclaw channels status`
- Make sure your user ID is in the allowlist in the config

**"Pairing required" message:**
- Your Telegram user ID may not be in the allowlist
- Check the config file and ensure `allowFrom` contains your numeric user ID

**Skills not loading:**
- Verify skills are detected: `openclaw skills list`
- Check that files are in `~/.openclaw/workspace/skills/`

**General diagnostics:**
```bash
openclaw doctor          # Full health check
openclaw channels status # Channel connectivity
openclaw skills list     # Loaded skills
openclaw logs --follow   # Live logs
```

## Future Plans

- Image prompt generation (DALL-E / Midjourney)
- Content calendar and scheduling
- Analytics integration (learn from engagement data)
- Auto-posting to platforms with Telegram approval
- Multi-brand/multi-user support
- Local model support (Ollama)

## License

MIT
