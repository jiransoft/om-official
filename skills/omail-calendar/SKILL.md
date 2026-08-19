---
name: omail-calendar
description:
  "Calendar management via omail CLI — view agenda, create/update/delete
  events, recurring events, free/busy, RSVP, calendar CRUD, sharing, and raw JMAP
  calendar methods. Use when the user asks about calendar, scheduling, agenda, or
  events."
argument-hint: "[agenda | insert | update | delete | freebusy | rsvp | copy | parse | share]"
---

# omail calendar — OfficeMail Calendar Management

> Works only with the OfficeMail service. Not compatible with other calendar providers.

## Argument routing

- `$ARGUMENTS` = `agenda` → skip to **Agenda** section
- `$ARGUMENTS` = `insert` → skip to **Create events** section
- `$ARGUMENTS` = `freebusy` → skip to **Freebusy** section
- `$ARGUMENTS` = `update` → skip to **Recurrence** section
- `$ARGUMENTS` = `delete` → skip to **Recurrence** section
- `$ARGUMENTS` = `rsvp` → skip to **RSVP** section
- `$ARGUMENTS` = `copy` → skip to **Copy and parse** section
- `$ARGUMENTS` = `parse` → skip to **Copy and parse** section
- `$ARGUMENTS` = `share` → skip to **Calendar sharing** section
- Empty or anything else → use full skill reference

## Binary path

    ${CLAUDE_PLUGIN_DATA}/omail

## Safety

- Always use --dry-run first when creating or modifying events via AI
- See omail skill for global flags, exit codes, and full security rules

## Browse methods

    ${CLAUDE_PLUGIN_DATA}/omail calendar --help
    ${CLAUDE_PLUGIN_DATA}/omail calendar calendarevent get --params '{...}'
    ${CLAUDE_PLUGIN_DATA}/omail calendar calendar get --params '{...}'

## Event Helpers

| Command     | Description                                                                     |
| ----------- | ------------------------------------------------------------------------------- |
| `+agenda`   | Upcoming events (default: 7 days, `--page-all`)                                 |
| `+insert`   | Create event (`--rrule`, `--alert`, `--online`, `--all-day`, `--invite`)        |
| `+update`   | Update event (`--series`, `--recurrence-id`, `--add-invite`, `--remove-invite`) |
| `+delete`   | Delete event (`--series`, `--recurrence-id`)                                    |
| `+freebusy` | Check free/busy status for a time range                                         |
| `+rsvp`     | Accept, decline, or tentative an invitation                                     |
| `+copy`     | Copy event to another account (CalendarEvent/copy)                              |
| `+parse`    | Parse iCalendar data into JSCalendar (CalendarEvent/parse)                      |

## Calendar Management (no `+` prefix)

| Command   | Description                                              |
| --------- | -------------------------------------------------------- |
| `create`  | Create a new calendar (`--name`, `--color`, `--visible`) |
| `update`  | Update a calendar (`--calendar-id`, `--name`, `--color`) |
| `delete`  | Delete a calendar (`--calendar-id`)                      |
| `share`   | Share calendar (`--calendar-id`, `--with`, `--role`)     |
| `unshare` | Remove sharing (`--calendar-id`, `--with`)               |

## Usage Examples

### Agenda

    ${CLAUDE_PLUGIN_DATA}/omail calendar +agenda
    ${CLAUDE_PLUGIN_DATA}/omail calendar +agenda --days 14 --timezone Asia/Seoul
    ${CLAUDE_PLUGIN_DATA}/omail calendar +agenda --page-all --limit 100

### Create events

    ${CLAUDE_PLUGIN_DATA}/omail calendar +insert --title "Meeting" --start "2026-03-25T10:00:00" --end "2026-03-25T11:00:00"
    ${CLAUDE_PLUGIN_DATA}/omail calendar +insert --title "Lunch" --start "2026-03-25T12:00:00" --end "2026-03-25T13:00:00" --location "Cafe"
    ${CLAUDE_PLUGIN_DATA}/omail calendar +insert --title "Review" --start "2026-03-25T14:00:00" --end "2026-03-25T15:00:00" --invite alice@example.com

### Recurrence

    ${CLAUDE_PLUGIN_DATA}/omail calendar +insert --title "Standup" --start "2026-03-23T09:00:00" --end "2026-03-23T09:30:00" --rrule '{"frequency":"weekly","byDay":[{"day":"mo"},{"day":"we"},{"day":"fr"}]}'
    ${CLAUDE_PLUGIN_DATA}/omail calendar +insert --title "Sprint" --start "2026-03-23T10:00:00" --end "2026-03-23T10:30:00" --rrule '{"frequency":"daily","count":10}'
    ${CLAUDE_PLUGIN_DATA}/omail calendar +update --event-id <id> --series --title "New Series Title"
    ${CLAUDE_PLUGIN_DATA}/omail calendar +update --event-id <id> --recurrence-id "2026-04-07T09:00:00" --title "Special"
    ${CLAUDE_PLUGIN_DATA}/omail calendar +delete --event-id <id> --recurrence-id "2026-04-07T09:00:00"
    ${CLAUDE_PLUGIN_DATA}/omail calendar +delete --event-id <id> --series

### Alerts and online meetings

    ${CLAUDE_PLUGIN_DATA}/omail calendar +insert --title "Meeting" --start "2026-03-25T10:00:00" --end "2026-03-25T11:00:00" --alert 15 --alert 60
    ${CLAUDE_PLUGIN_DATA}/omail calendar +insert --title "Sync" --start "2026-03-25T10:00:00" --end "2026-03-25T11:00:00" --online "https://zoom.us/j/123"
    ${CLAUDE_PLUGIN_DATA}/omail calendar +insert --title "Meeting" --start "2026-03-25T10:00:00" --end "2026-03-25T11:00:00" --use-default-alerts

### All-day events

    ${CLAUDE_PLUGIN_DATA}/omail calendar +insert --title "Holiday" --start "2026-03-25" --all-day
    ${CLAUDE_PLUGIN_DATA}/omail calendar +insert --title "Conference" --start "2026-03-25" --end "2026-03-27" --all-day

### Event properties

    ${CLAUDE_PLUGIN_DATA}/omail calendar +insert --title "Tentative" --start "2026-03-25T10:00:00" --end "2026-03-25T11:00:00" --status tentative --privacy private --priority 5

### RSVP

    ${CLAUDE_PLUGIN_DATA}/omail calendar +rsvp --event-id <id> --status accepted
    ${CLAUDE_PLUGIN_DATA}/omail calendar +rsvp --event-id <id> --status declined

### Participant management

    ${CLAUDE_PLUGIN_DATA}/omail calendar +update --event-id <id> --add-invite bob@example.com
    ${CLAUDE_PLUGIN_DATA}/omail calendar +update --event-id <id> --remove-invite bob@example.com

### Copy and parse

    ${CLAUDE_PLUGIN_DATA}/omail calendar +copy --event-id <id> --to-account <accountId>
    ${CLAUDE_PLUGIN_DATA}/omail calendar +parse --ical "BEGIN:VCALENDAR..."
    cat invite.ics | ${CLAUDE_PLUGIN_DATA}/omail calendar +parse

### Calendar CRUD

    ${CLAUDE_PLUGIN_DATA}/omail calendar create --name "Work" --color "#0000ff"
    ${CLAUDE_PLUGIN_DATA}/omail calendar update --calendar-id <id> --name "Personal" --color "#ff0000"
    ${CLAUDE_PLUGIN_DATA}/omail calendar delete --calendar-id <id>

### Calendar sharing

    ${CLAUDE_PLUGIN_DATA}/omail calendar share --calendar-id <id> --with user@example.com --role reader
    ${CLAUDE_PLUGIN_DATA}/omail calendar unshare --calendar-id <id> --with user@example.com

### Freebusy

    ${CLAUDE_PLUGIN_DATA}/omail calendar +freebusy --start "2026-03-25T00:00:00" --end "2026-03-26T00:00:00"

## Recipes

### RSVP to an invitation

`+agenda` includes `participants` with each attendee's `participationStatus`.
Look for events where the user's status is `needs-action`:

1. `${CLAUDE_PLUGIN_DATA}/omail calendar +agenda` — list upcoming events
2. Find the event where participants show `"participationStatus": "needs-action"`
   for the user's email
3. `${CLAUDE_PLUGIN_DATA}/omail calendar +rsvp --event-id <id> --status accepted`

### Update or delete a recurring event

When the user says "change the recurring meeting" without specifying which one:

1. `${CLAUDE_PLUGIN_DATA}/omail calendar +agenda` — find the event and its id
2. Ask: update the entire series (`--series`) or a single instance
   (`--recurrence-id <datetime>`)?
3. `${CLAUDE_PLUGIN_DATA}/omail calendar +update --event-id <id> --series --dry-run ...`
4. Confirm with user, then execute without `--dry-run`

## Raw methods

    ${CLAUDE_PLUGIN_DATA}/omail calendar calendarevent get --params '{...}'
    ${CLAUDE_PLUGIN_DATA}/omail calendar calendarevent query --params '{"filter":{}}'
    ${CLAUDE_PLUGIN_DATA}/omail calendar calendarevent set --json '{"create":{"e1":{...}}}'
    ${CLAUDE_PLUGIN_DATA}/omail calendar calendarevent changes --params '{"sinceState":"<state>"}'
    ${CLAUDE_PLUGIN_DATA}/omail calendar calendarevent queryChanges --params '{"sinceQueryState":"<qs>","filter":{}}'
    ${CLAUDE_PLUGIN_DATA}/omail calendar calendar get --params '{}'
    ${CLAUDE_PLUGIN_DATA}/omail calendar calendar set --json '{"create":{"c1":{"name":"Work"}}}'
    ${CLAUDE_PLUGIN_DATA}/omail calendar calendar changes --params '{"sinceState":"<state>"}'

## Notes

- Server must support `urn:ietf:params:jmap:calendars` capability
  (check with `omail doctor`)
- Dates use ISO 8601 local time, no milliseconds: `2026-03-25T10:00:00`
- `--rrule` takes JSCalendar RecurrenceRule JSON;
  `frequency` is required (weekly, daily, monthly, etc.)
- `--series` updates/deletes the entire recurring series;
  `--recurrence-id <UTC-datetime>` targets a single instance
- Updating/deleting a recurring event without `--series` or
  `--recurrence-id` returns an error prompting the user to specify
- `--alert <minutes>` is repeatable; `--use-default-alerts` overrides custom alerts
- `--online` only accepts https/http URLs (blocks javascript:/data:)
- `--all-day` requires date-only `--start` (YYYY-MM-DD); duration in days
- `--add-invite` auto-creates organizer from session when event has no participants
- `+copy` requires target account to have calendar capability
- `+parse` checks capability + catches unknownMethod (belt+suspenders)
- Calendar sharing requires `urn:ietf:params:jmap:sharing` capability;
  roles: reader, writer, admin
- Multi-user freebusy (`--email`) requires
  `urn:ietf:params:jmap:principals` capability
- Always use `--dry-run` first when creating or modifying events via AI
