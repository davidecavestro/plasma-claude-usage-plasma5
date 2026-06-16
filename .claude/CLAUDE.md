# Claude Usage Widget - Development Guide

## Project Overview

This is a KDE Plasma 5 widget that displays Claude Code usage statistics (session and weekly limits) in the taskbar. (Originally a Plasma 6 widget, ported to Plasma 5 / KF5 / Qt 5.15.)

It is a **fork** of the upstream Plasma 6 widget by izll (<https://github.com/izll/plasma-claude-usage>), redistributed under GPL-3.0-or-later. The fork uses a distinct plugin ID (`org.kde.plasma.claudeusage.plasma5`) so it can coexist with the upstream widget without collision. Pull upstream changes via the `upstream` remote and re-port as needed.

## Architecture

The widget is **pure QML** with no external dependencies:

1. **Credentials reading**: Uses `PlasmaCore.DataSource` (`org.kde.plasma.core`) with "executable" engine to run `cat $HOME/.claude/.credentials.json`
2. **API calls**: Uses QML's built-in `XMLHttpRequest` to call Anthropic's OAuth usage API
3. **UI**: Standard Plasma/Kirigami components

## Key Files

- `contents/ui/main.qml` - All widget logic and UI
- `contents/icons/claude.svg` - Claude logo (orange #D97757)
- `metadata.desktop` - Plasma 5 widget metadata (INI format)
- `install.sh` - Installation script

## API Endpoint

```
GET https://api.anthropic.com/api/oauth/usage
Headers:
  Authorization: Bearer <oauth-token>
  Content-Type: application/json
  anthropic-beta: oauth-2025-04-20
```

The `anthropic-beta: oauth-2025-04-20` header is **required** - without it the API returns 401.

## Response Structure

```json
{
  "five_hour": {
    "utilization": 14.0,
    "resets_at": "2025-11-29T19:00:00+00:00"
  },
  "seven_day": {
    "utilization": 89.0,
    "resets_at": "2025-12-01T19:00:00+00:00"
  },
  "seven_day_sonnet": {
    "utilization": 31.0,
    "resets_at": "..."
  },
  "seven_day_opus": null
}
```

## Credentials Location

Claude Code stores OAuth credentials in `~/.claude/.credentials.json`:

```json
{
  "claudeAiOauth": {
    "accessToken": "sk-ant-oat01-...",
    "refreshToken": "sk-ant-ort01-...",
    "expiresAt": 1764462495036,
    "subscriptionType": "max",
    "rateLimitTier": "default_claude_max_20x"
  }
}
```

## Plan Tiers

- `default_claude_pro` → "Pro"
- `default_claude_max_5x` → "Max 5x"
- `default_claude_max_20x` → "Max 20x"

## Testing

1. Install: `./install.sh`
2. Restart Plasma: `kquitapp5 plasmashell && kstart5 plasmashell`
3. Check logs: `journalctl --user -f | grep -i claude`

## Common Issues

- **StandardPaths not working**: Use `$HOME` environment variable instead
- **API returns 401**: Make sure `anthropic-beta` header is included
- **Widget not updating**: Check if credentials file exists and is readable

## Publishing

The plugin ID is `org.kde.plasma.claudeusage.plasma5` (distinct from the upstream `org.kde.plasma.claudeusage`).

To publish to KDE Store:
1. Create a `.plasmoid` package: `zip -r claude-usage-widget.plasmoid metadata.desktop contents/`
2. Upload to <https://store.kde.org/> as a **separate Plasma 5 entry** — do not overwrite the upstream listing.

When publishing, make sure `metadata.desktop` reflects the fork:
- `X-KDE-PluginInfo-Name=org.kde.plasma.claudeusage.plasma5`
- `X-KDE-PluginInfo-Website` points at the fork repo
- `X-KDE-PluginInfo-Author` credits both izll and the porter
