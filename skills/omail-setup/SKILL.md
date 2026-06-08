---
name: omail-setup
description:
  "Set up OfficeMail CLI — OAuth login, manual JMAP configuration, token
  refresh, auth troubleshooting, multi-profile management, and connection diagnostics
  (doctor). Use when the user asks to log in, configure auth, fix connection issues,
  manage multiple accounts, or set up omail for the first time."
argument-hint: "[doctor | login | logout | reset | report | status | alias]"
---

# omail setup — OfficeMail Auth & Diagnostics

> This tool connects only to the OfficeMail service (Cyrus IMAP + Postfix based).

## Argument routing

- `$ARGUMENTS` = `doctor` → skip to **Diagnostics** section
- `$ARGUMENTS` = `login` → skip to **Re-authenticate**
- `$ARGUMENTS` = `logout` → skip to **Logout**
- `$ARGUMENTS` = `reset` → skip to **Reset**
- `$ARGUMENTS` = `report` → skip to **Report (send debug logs)**
- `$ARGUMENTS` = `status` → skip to **Multi-profile commands** section
- `$ARGUMENTS` = `alias` → skip to **Alias commands** section
- Empty or anything else → run the full setup flow from Step 1

## Binary path

    ${CLAUDE_PLUGIN_DATA}/omail

## Claude Code Plugin Setup

### Step 1: Check binary

    ${CLAUDE_PLUGIN_DATA}/omail --version

If missing, ask the user to restart the session.

### Step 2: Setup

#### Option A: OAuth login (recommended for OfficeNEXT users)

Ask the user for their email address, then run:

    ${CLAUDE_PLUGIN_DATA}/omail auth setup --email <email>
    ${CLAUDE_PLUGIN_DATA}/omail --profile work auth setup --email <email>

**Always use prod (default). Only add `--env dev` if the user explicitly requests dev.**

A browser window will open for authentication. The user clicks "Sign in",
completes OAuth login in the popup, and tokens are saved automatically.

#### Option B: Manual setup (OfficeMail JMAP URL + Bearer token)

    ${CLAUDE_PLUGIN_DATA}/omail auth setup --url <officemail-domain> --token <token>
    ${CLAUDE_PLUGIN_DATA}/omail --profile work auth setup --url <domain> --token <token>

### Step 3: Verify connection

    ${CLAUDE_PLUGIN_DATA}/omail doctor

### Step 4: Test

    ${CLAUDE_PLUGIN_DATA}/omail mail +triage

If this returns inbox data, setup is complete.

## Auth commands

    ${CLAUDE_PLUGIN_DATA}/omail auth setup         # Add account (OAuth or manual)
    ${CLAUDE_PLUGIN_DATA}/omail --profile <name> auth setup  # add account to a named profile
    ${CLAUDE_PLUGIN_DATA}/omail auth login         # Re-authenticate existing profile
    ${CLAUDE_PLUGIN_DATA}/omail auth logout        # clear credentials for current profile (keeps config)
    ${CLAUDE_PLUGIN_DATA}/omail auth reset         # delete all profiles, credentials, and config
    ${CLAUDE_PLUGIN_DATA}/omail auth token <t>     # update Bearer token
    ${CLAUDE_PLUGIN_DATA}/omail auth whoami        # verify current session
    ${CLAUDE_PLUGIN_DATA}/omail auth refresh       # force-refresh OAuth access token (if any) + session cache

## Multi-profile commands

    ${CLAUDE_PLUGIN_DATA}/omail auth list          # list all profiles
    ${CLAUDE_PLUGIN_DATA}/omail auth switch <name> # change default profile
    ${CLAUDE_PLUGIN_DATA}/omail auth remove <name> # remove a profile
    ${CLAUDE_PLUGIN_DATA}/omail auth rename <old> <new>  # rename a profile
    ${CLAUDE_PLUGIN_DATA}/omail auth status        # health check all profiles

## Alias commands

    ${CLAUDE_PLUGIN_DATA}/omail auth alias add <profile> <alias>    # add alias
    ${CLAUDE_PLUGIN_DATA}/omail auth alias remove <profile> <alias> # remove alias
    ${CLAUDE_PLUGIN_DATA}/omail auth alias list [profile]           # list aliases

## Report (send debug logs)

Send system info and CLI debug logs (JSONL) as an email.
Ask the user for the recipient email address, then run:

    ${CLAUDE_PLUGIN_DATA}/omail auth report <email>
    ${CLAUDE_PLUGIN_DATA}/omail --profile work auth report <email>

## Multi-profile usage

    ${CLAUDE_PLUGIN_DATA}/omail --profile work mail +triage   # use "work" profile
    ${CLAUDE_PLUGIN_DATA}/omail --profile personal mail +send --to ...

## Re-authenticate

`omail auth login` re-authenticates the current profile.
OAuth profiles re-open the browser for login. Manual profiles prompt for a new token.

**Always execute the login command directly** — never tell the user to run it
themselves. The command opens a browser for OAuth automatically; the user
completes login there. No interactive input is needed for OAuth profiles.

    ${CLAUDE_PLUGIN_DATA}/omail auth login
    ${CLAUDE_PLUGIN_DATA}/omail --profile work auth login

## Logout

Clear credentials (token + session cache) for the current profile but keep
the profile config so the user can re-login without re-entering the server URL.

    ${CLAUDE_PLUGIN_DATA}/omail auth logout
    ${CLAUDE_PLUGIN_DATA}/omail --profile work auth logout

After logout, run `omail auth login` to re-authenticate.

## Reset

Delete all profiles, credentials, session caches, and the config file.
This is a full factory reset — the user must set up from scratch.

    ${CLAUDE_PLUGIN_DATA}/omail auth reset

## Diagnostics

    ${CLAUDE_PLUGIN_DATA}/omail doctor             # diagnose connection, auth, capabilities

## Notes

- Config stored at `~/.config/officemail/config.json` (chmod 600)
- Multi-profile: config uses `{ default, profiles: { name: config } }` format
- Old single-account config is auto-migrated on first load
- Claude Code plugin, Claude Desktop MCP, and CLI all share the same config
- OAuth tokens auto-renew: any command hitting a 401 with a valid refresh
  token mints a new access token and retries — including `doctor` and
  `auth refresh`. A `doctor` auth failure means the refresh token itself is
  exhausted, so `omail auth login` is genuinely required (not a transient
  expiry). Manual (Bearer-token) profiles cannot auto-renew.
- The refresh token is a sliding window (renewed on every refresh). Re-login
  is only needed after the refresh-token lifetime elapses with NO activity —
  any command that triggers a refresh resets the window. Access-token
  lifetimes are short and server-controlled (e.g. dev is shorter than prod),
  but the renewal is transparent.
- `--profile` selects auth credentials; `--account` overrides JMAP accountId
- MCP tools accept an optional `profile` parameter for per-call profile selection
- MCP `account_switch` sets session-level default (in-process, does not persist)
