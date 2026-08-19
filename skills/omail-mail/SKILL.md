---
name: omail-mail
description: "Email management via omail CLI — send, reply, forward, redirect,
  triage inbox, read messages, search, move, flag, draft, watch for new mail,
  and raw JMAP mail methods. Use when the user asks to read, send, search,
  organize, or manage email."
argument-hint: "[send | reply | forward | triage | read | search | move | flag | draft | watch]"
---

# omail mail — OfficeMail Email Management

> Works only with the OfficeMail service. Not compatible with other email providers.

## Argument routing

- `$ARGUMENTS` = `send` → skip to **Send & reply** section
- `$ARGUMENTS` = `triage` → skip to **Read & triage** section
- `$ARGUMENTS` = `search` → skip to **Search by date range** recipe
- `$ARGUMENTS` = `read` → skip to **Read & triage** section
- `$ARGUMENTS` = `reply` → skip to **Send & reply** section
- `$ARGUMENTS` = `forward` → skip to **Send & reply** section
- `$ARGUMENTS` = `move` → skip to **Draft, organize, watch** section
- `$ARGUMENTS` = `flag` → skip to **Draft, organize, watch** section
- `$ARGUMENTS` = `draft` → skip to **Draft, organize, watch** section
- `$ARGUMENTS` = `watch` → skip to **Draft, organize, watch** section
- Empty or anything else → use full skill reference

## Binary path

    ${CLAUDE_PLUGIN_DATA}/omail

## Safety

- NEVER send email without explicit user confirmation (use --dry-run first)
- See omail skill for global flags, exit codes, and full security rules

## Helpers

| Command      | Description                                                                                            |
| ------------ | ------------------------------------------------------------------------------------------------------ |
| `+send`      | Send an email (`-a` for attachments, `--cc`, `--bcc`, `--html`, `--from`)                              |
| `+reply`     | Reply with auto-threading (`-a` for attachments)                                                       |
| `+reply-all` | Reply-all (`-a` for attachments)                                                                       |
| `+forward`   | Forward (`-a`, `--include-attachments`, `--raw`)                                                       |
| `+redirect`  | Redirect (bounce) preserving original headers                                                          |
| `+triage`    | Unread inbox summary (`--mailbox`, `--limit`, `--page-all`)                                            |
| `+read`      | Read message body (`--raw`, `--save-attachments [dir]`)                                                |
| `+search`    | Full-text search (`--query`, `--after`, `--before`, `--mailbox`, `--limit`, `--page-all`, `--backend`) |
| `+thread`    | Thread navigation: `by-message-id <id>` resolves a Message-ID to its full tree                         |
| `+move`      | Move between mailboxes                                                                                 |
| `+flag`      | Set/unset keywords                                                                                     |
| `+draft`     | Save to Drafts (`--cc`, `--html`)                                                                      |
| `+watch`     | Watch for new emails via EventSource (`--raw`, `--ping`)                                               |

## Usage examples

### Read & triage

    ${CLAUDE_PLUGIN_DATA}/omail mail +triage                         # unread INBOX summary
    ${CLAUDE_PLUGIN_DATA}/omail mail +triage --mailbox Sent          # sent mail summary
    ${CLAUDE_PLUGIN_DATA}/omail mail +triage --limit 10              # top 10
    ${CLAUDE_PLUGIN_DATA}/omail mail +triage --page-all              # all unread
    ${CLAUDE_PLUGIN_DATA}/omail mail +read --message-id <id>         # full message body
    ${CLAUDE_PLUGIN_DATA}/omail mail +read --message-id <id> --save-attachments       # download to cwd
    ${CLAUDE_PLUGIN_DATA}/omail mail +read --message-id <id> --save-attachments /tmp  # download to dir
    ${CLAUDE_PLUGIN_DATA}/omail mail +search --query "from:bob budget" --limit 20
    ${CLAUDE_PLUGIN_DATA}/omail mail +search --query "report" --page-all
    ${CLAUDE_PLUGIN_DATA}/omail mail +search --query "messageid:<root-id>"          # exact Message-ID
    ${CLAUDE_PLUGIN_DATA}/omail mail +search --query "references:<root-id>"         # all replies in a thread
    ${CLAUDE_PLUGIN_DATA}/omail mail +search --query "inreplyto:<msg-id>"           # direct replies to a message
    ${CLAUDE_PLUGIN_DATA}/omail mail +thread by-message-id "<root-id>"               # full thread tree (Cyrus 3.12+)

### Send & reply

    ${CLAUDE_PLUGIN_DATA}/omail mail +send --to alice@example.com --subject "Hello" --body "Hi"
    ${CLAUDE_PLUGIN_DATA}/omail mail +send --to alice@example.com --subject "Report" --body "See attached" -a report.pdf
    ${CLAUDE_PLUGIN_DATA}/omail mail +send --to alice@example.com --subject "Bold" --body '<b>Bold</b>' --html
    ${CLAUDE_PLUGIN_DATA}/omail mail +send --to alice@example.com --subject "Test" --body "Hi" --from alias@example.com
    ${CLAUDE_PLUGIN_DATA}/omail mail +reply --message-id <id> --body "Thanks!"
    ${CLAUDE_PLUGIN_DATA}/omail mail +reply --message-id <id> --body "See attached" -a notes.pdf
    ${CLAUDE_PLUGIN_DATA}/omail mail +reply-all --message-id <id> --body "Noted."
    ${CLAUDE_PLUGIN_DATA}/omail mail +reply-all --message-id <id> --body "Noted." -a summary.pdf
    ${CLAUDE_PLUGIN_DATA}/omail mail +forward --message-id <id> --to bob@example.com --body "FYI"
    ${CLAUDE_PLUGIN_DATA}/omail mail +forward --message-id <id> --to bob@example.com --include-attachments
    ${CLAUDE_PLUGIN_DATA}/omail mail +forward --message-id <id> --to bob@example.com -a extra.pdf --include-attachments
    ${CLAUDE_PLUGIN_DATA}/omail mail +forward --message-id <id> --to bob@example.com --raw
    ${CLAUDE_PLUGIN_DATA}/omail mail +redirect --message-id <id> --to bob@example.com
    ${CLAUDE_PLUGIN_DATA}/omail mail +redirect --message-id <id> --to alice@example.com bob@example.com

### Draft, organize, watch

    ${CLAUDE_PLUGIN_DATA}/omail mail +draft --to alice@example.com --subject "Draft" --body "WIP"
    ${CLAUDE_PLUGIN_DATA}/omail mail +move --message-id <id> --to Archive
    ${CLAUDE_PLUGIN_DATA}/omail mail +flag --message-id <id> --set '$flagged'
    ${CLAUDE_PLUGIN_DATA}/omail mail +flag --message-id <id> --unset '$seen'
    ${CLAUDE_PLUGIN_DATA}/omail mail +watch                            # enriched new email stream
    ${CLAUDE_PLUGIN_DATA}/omail mail +watch --raw                      # raw SSE events
    ${CLAUDE_PLUGIN_DATA}/omail mail +watch --ping 30                  # custom ping interval

## +send flags

| Flag           | Required | Description                                  |
| -------------- | -------- | -------------------------------------------- |
| `--to`         | Yes      | Recipient email(s)                           |
| `--subject`    | Yes      | Subject line                                 |
| `--body`       | Yes      | Message body (plain text or HTML)            |
| `--cc`         | No       | CC recipients                                |
| `--bcc`        | No       | BCC recipients                               |
| `--from`       | No       | Send-as alias                                |
| `--html`       | No       | Treat body as HTML                           |
| `-a, --attach` | No       | File attachment (repeatable, max 25MB total) |
| `--dry-run`    | No       | Preview without sending                      |

## +triage flags

| Flag         | Required | Default | Description          |
| ------------ | -------- | ------- | -------------------- |
| `--mailbox`  | No       | INBOX   | Mailbox name or role |
| `--limit`    | No       | 50      | Max results per page |
| `--page-all` | No       | false   | Fetch all pages      |

## +triage output (JSON)

    {
      "mailbox": "INBOX",
      "totalEmails": 142,
      "unreadEmails": 5,
      "showing": 5,
      "total": 5,
      "pageAll": false,
      "messages": [
        {
          "id": "msg001",
          "from": "alice@example.com",
          "subject": "Budget Q2",
          "receivedAt": "2026-03-20T09:00:00Z",
          "preview": "Hi, please review...",
          "hasAttachment": true,
          "isRead": false,
          "isFlagged": false
        }
      ]
    }

## Recipes

### Triage and reply

1. `${CLAUDE_PLUGIN_DATA}/omail mail +triage` — get unread summary
2. Pick a message from the results using its `id` field
3. `${CLAUDE_PLUGIN_DATA}/omail mail +read --message-id <id>` — read full message
4. `${CLAUDE_PLUGIN_DATA}/omail mail +reply --message-id <id> --body "..." --dry-run`
   — preview
5. `${CLAUDE_PLUGIN_DATA}/omail mail +reply --message-id <id> --body "..."`
   — send after confirm

### Reply to a specific email

When the user says "reply to this email" without specifying which one:

1. Ask which message, or use the most recently read/triaged message id
2. `${CLAUDE_PLUGIN_DATA}/omail mail +read --message-id <id>` — confirm content
3. `${CLAUDE_PLUGIN_DATA}/omail mail +reply --message-id <id> --body "..." --dry-run`
4. Show preview, send after user confirms

### Redirect vs forward

- `+forward` — creates a new email with `Fwd:` subject and `From: you`
- `+forward --raw` — same as forward but without the separator header
- `+redirect` — bounces original as-is with `Resent-*` headers,
  original `From` preserved

### Search by date range

    ${CLAUDE_PLUGIN_DATA}/omail mail +search --query "report" --after "2026-03-18" --before "2026-03-25"
    ${CLAUDE_PLUGIN_DATA}/omail mail +search --after "2026-03-25" --limit 10

### Search backend

`+search` is served by one of two backends, and they can legitimately
return different results (e.g. servers that skip archived messages for
body-text terms on JMAP while the OpenSearch worker indexes everything).
The OpenSearch worker serves every query it can express: free text,
`subject:`, `body:`, `from:`, `to:` (any combination, ANDed), plus
`--after` and `--before`. JMAP serves the rest: `cc:`, `bcc:`,
`messageid:`, `inreplyto:`, `references:` filters, any query with
`--mailbox` (the worker's folder filter uses Cyrus-internal names,
which the CLI cannot translate from JMAP mailbox names/ids), empty
queries, profiles without a worker URL, and worker outages (connection
errors and 5xx fall back to JMAP automatically, with a warning on
stderr). The worker URL defaults to `search.{domain}` derived from the
profile's `jmapUrl` (e.g. `jmap.officesuite.co.kr` →
`search.officesuite.co.kr`); override with the `searchUrl` config field
or `OMAIL_SEARCH_URL` env.

The chosen backend is observable: the JSON result carries
`backend: "opensearch" | "jmap"`, and `--verbose` logs a
`Search backend: ...` line to stderr (JMAP lines include the routing
reason). To force a specific backend, pass `--backend jmap` or
`--backend opensearch` (the latter errors instead of falling back).
Note `--dry-run` always previews the JMAP request shape, even for
worker-routed queries. Same `--output json` shape from both backends.

### Draft for review

1. `${CLAUDE_PLUGIN_DATA}/omail mail +draft --to <email> --subject "..." --body "..."`
   — save to Drafts
2. User reviews in webmail/mobile
3. User sends manually when ready

## Raw methods

    ${CLAUDE_PLUGIN_DATA}/omail mail mailbox get --params '{...}'
    ${CLAUDE_PLUGIN_DATA}/omail mail mailbox query --params '{...}'
    ${CLAUDE_PLUGIN_DATA}/omail mail mailbox set --json '{"create":{"m1":{"name":"Archive"}}}'
    ${CLAUDE_PLUGIN_DATA}/omail mail mailbox changes --params '{"sinceState":"<state>"}'
    ${CLAUDE_PLUGIN_DATA}/omail mail mailbox queryChanges --params '{"sinceQueryState":"<qs>","filter":{}}'
    ${CLAUDE_PLUGIN_DATA}/omail mail email get --params '{"ids":["<id>"],"properties":["subject","from","bodyValues"]}'
    ${CLAUDE_PLUGIN_DATA}/omail mail email query --params '{"filter":{"inMailbox":"INBOX"}}'
    ${CLAUDE_PLUGIN_DATA}/omail mail email set --json '{"update":{"<id>":{"mailboxIds":{"<mailboxId>":true}}}}'
    ${CLAUDE_PLUGIN_DATA}/omail mail email changes --params '{"sinceState":"<state>"}'
    ${CLAUDE_PLUGIN_DATA}/omail mail email queryChanges --params '{"sinceQueryState":"<qs>","filter":{}}'
    ${CLAUDE_PLUGIN_DATA}/omail mail email copy --json '{"fromAccountId":"<a>","accountId":"<b>","create":{"c1":{"id":"<msg>","mailboxIds":{"<mb>":true}}}}'
    ${CLAUDE_PLUGIN_DATA}/omail mail thread get --params '{"ids":["<id>"]}'
    ${CLAUDE_PLUGIN_DATA}/omail mail thread changes --params '{"sinceState":"<state>"}'
    ${CLAUDE_PLUGIN_DATA}/omail mail searchsnippet get --params '{"filter":{"text":"budget"},"emailIds":["<id>"]}'

## Notes

- Handles MIME encoding automatically via JMAP EmailSubmission
- Use --dry-run first when composing with an AI agent
- Requires server support for `urn:ietf:params:jmap:submission`
- `searchsnippet get` requires BOTH `filter` and `emailIds` in
  `--params` (RFC 8621 §5.1); servers without SearchSnippet support
  return `unknownMethod`, and servers with no search engine answer
  with `subject: null` / `preview: null` snippets
