---
name: omail-contacts
description:
  "Contacts management via omail CLI — list, search, add, update, delete
  contacts and list address books. Use when the user asks about contacts,
  address book, or looking up people."
argument-hint: "[list | search | add | update | delete | get | addressbooks]"
---

# omail contacts — OfficeMail Contacts Management

> Works only with the OfficeMail service. Not compatible with other
> contacts providers.

## Argument routing

- `$ARGUMENTS` = `list` → skip to **List contacts** section
- `$ARGUMENTS` = `search` → skip to **Search contacts** section
- `$ARGUMENTS` = `add` → skip to **Add contact** section
- `$ARGUMENTS` = `update` → skip to **Update contact** section
- `$ARGUMENTS` = `delete` → skip to **Delete contact** section
- `$ARGUMENTS` = `get` → skip to **Get contact details** section
- `$ARGUMENTS` = `addressbooks` → skip to **Address books** section
- Empty or anything else → use full skill reference

## Binary path

    ${CLAUDE_PLUGIN_DATA}/omail

## Safety

- Always use --dry-run first when creating or modifying contacts via AI
- See omail skill for global flags, exit codes, and full security rules

## Browse methods

    ${CLAUDE_PLUGIN_DATA}/omail contacts --help
    ${CLAUDE_PLUGIN_DATA}/omail contacts contactcard get --params '{...}'
    ${CLAUDE_PLUGIN_DATA}/omail contacts addressbook get --params '{}'

## Contact Helpers

| Command         | Description                                   |
| --------------- | --------------------------------------------- |
| `+list`         | List contacts (`--addressbook`, `--page-all`) |
| `+search`       | Search by name or email (`--query`)           |
| `+get`          | Get full details of a single contact          |
| `+add`          | Add new contact (`--name`, `--email`)         |
| `+update`       | Update contact fields                         |
| `+delete`       | Delete a contact                              |
| `+addressbooks` | List address books                            |

## Usage Examples

### List contacts

    ${CLAUDE_PLUGIN_DATA}/omail contacts +list
    ${CLAUDE_PLUGIN_DATA}/omail contacts +list --limit 100 --page-all
    ${CLAUDE_PLUGIN_DATA}/omail contacts +list --addressbook Default

### Search contacts

    ${CLAUDE_PLUGIN_DATA}/omail contacts +search --query "alice"
    ${CLAUDE_PLUGIN_DATA}/omail contacts +search --query "example.com" --limit 10

### Get contact details

    ${CLAUDE_PLUGIN_DATA}/omail contacts +get --contact-id <id>

### Add contact

    ${CLAUDE_PLUGIN_DATA}/omail contacts +add --name "Alice Kim" --email alice@example.com
    ${CLAUDE_PLUGIN_DATA}/omail contacts +add --name "Bob Lee" --email bob@example.com --phone "010-1234-5678"
    ${CLAUDE_PLUGIN_DATA}/omail contacts +add --name "Carol" --email carol@example.com --addressbook Default

### Update contact

    ${CLAUDE_PLUGIN_DATA}/omail contacts +update --contact-id <id> --name "New Name"
    ${CLAUDE_PLUGIN_DATA}/omail contacts +update --contact-id <id> --email new@example.com
    ${CLAUDE_PLUGIN_DATA}/omail contacts +update --contact-id <id> --phone "010-0000-0000"

### Delete contact

    ${CLAUDE_PLUGIN_DATA}/omail contacts +delete --contact-id <id>

### Address books

    ${CLAUDE_PLUGIN_DATA}/omail contacts +addressbooks

## Recipes

### Look up a contact's full details

`+list` and `+search` return summary fields (id, fullName, emails,
phones). Use `+get` for the complete ContactCard:

1. `${CLAUDE_PLUGIN_DATA}/omail contacts +search --query "name"` — get
   contact id
2. `${CLAUDE_PLUGIN_DATA}/omail contacts +get --contact-id <id>` — full
   ContactCard (all fields)

### Add a contact from an email

When the user says "save this sender as a contact":

1. Read the email to get sender name and address
2. `${CLAUDE_PLUGIN_DATA}/omail contacts +search --query "sender@email.com"` — check if already exists
3. If not found: `${CLAUDE_PLUGIN_DATA}/omail contacts +add --name "Sender Name" --email sender@email.com --dry-run`
4. Confirm with user, then execute without `--dry-run`

### Cross-service workflow: contacts + mail + calendar

Contacts integrate with mail and calendar for workflows like
"email this person and schedule a meeting":

1. `${CLAUDE_PLUGIN_DATA}/omail contacts +search --query "alice"` — find
   contact
2. `${CLAUDE_PLUGIN_DATA}/omail mail +send --to alice@example.com --subject "Meeting" --body "..."`
3. `${CLAUDE_PLUGIN_DATA}/omail calendar +insert --title "Meeting with Alice" --start "..." --end "..." --invite alice@example.com`

## Raw methods

    ${CLAUDE_PLUGIN_DATA}/omail contacts contactcard get --params '{"ids":["..."]}'
    ${CLAUDE_PLUGIN_DATA}/omail contacts contactcard query --params '{"filter":{"text":"alice"}}'
    ${CLAUDE_PLUGIN_DATA}/omail contacts contactcard set --json '{"create":{"c1":{"fullName":"Test","emails":{"e1":{"address":"test@example.com"}}}}}'
    ${CLAUDE_PLUGIN_DATA}/omail contacts contactcard changes --params '{"sinceState":"<state>"}'
    ${CLAUDE_PLUGIN_DATA}/omail contacts contactcard queryChanges --params '{"sinceQueryState":"<qs>","filter":{}}'
    ${CLAUDE_PLUGIN_DATA}/omail contacts addressbook get --params '{}'
    ${CLAUDE_PLUGIN_DATA}/omail contacts addressbook changes --params '{"sinceState":"<state>"}'

## Notes

- Server must support `urn:ietf:params:jmap:contacts` capability
  (check with `omail doctor`)
- ContactCard follows JSContact format (RFC 9553)
- `+add` requires both `--name` and `--email`; for phone-only
  contacts, use raw `contactcard set`
- `+update --email` appends a new email address to the contact;
  it does not replace existing ones. Use raw `contactcard set`
  to replace.
- `+list` returns summary fields: id, fullName, emails, phones.
  Use `+get` for all fields.
- Always use `--dry-run` first when creating or modifying
  contacts via AI
