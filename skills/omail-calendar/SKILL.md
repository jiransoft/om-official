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

| Command     | Description                                                                              |
| ----------- | ---------------------------------------------------------------------------------------- |
| `+agenda`   | Upcoming events (default: 7 days, `--page-all`)                                          |
| `+insert`   | Create event (`--tz`, `--rrule`, `--alert`, `--online`, `--all-day`, `--invite`)         |
| `+update`   | Update event (`--series`, `--recurrence-id`, `--add-occurrence`, `--tz`, `--add-invite`) |
| `+delete`   | Delete event (`--series`, `--recurrence-id`)                                             |
| `+freebusy` | Check free/busy status for a time range                                                  |
| `+rsvp`     | Accept, decline, or tentative an invitation                                              |
| `+copy`     | Copy event to another account (CalendarEvent/copy)                                       |
| `+parse`    | Parse iCalendar data into JSCalendar (CalendarEvent/parse)                               |

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
- Dates use ISO 8601: `2026-03-25T10:00:00`. A value without an offset is
  wall time in the event's zone; a value with `Z` or an offset
  (`2026-03-25T10:00:00+09:00`) is converted to that zone
- `+insert` pins every timed event to a `timeZone`: `--tz <IANA zone>`, or
  the system zone (e.g. `Asia/Seoul`) when omitted. `--floating` creates an
  event with no zone and accepts local times only
- `+update --start` keeps the event's zone unless `--tz` changes it; a
  floating event given a `Z`/offset time is pinned to the system zone
- Durations are elapsed time between the start and end instants, so an
  event across a DST change keeps its real length
- An offset start that falls in the second pass of a DST fall-back hour
  (e.g. `2026-11-01T01:30:00-05:00` in `America/New_York`) cannot be stored
  as local time in that zone and is rejected — use `--tz UTC` or the
  earlier offset
- `--rrule` takes JSCalendar RecurrenceRule JSON;
  `frequency` is required (weekly, daily, monthly, etc.)
- `--series` updates/deletes the entire recurring series;
  `--recurrence-id <datetime>` targets a single instance by its original
  start, local to the event's zone (`Z`/offset input is converted; for a
  floating event the wall time is used as given). A `Z`/offset value that
  also names a time skipped by a DST change, or the repeated hour, is
  refused — pass the local time then
- `--recurrence-id` must name an occurrence of the series (checked against
  the server's expansion, or omail's own when the server cannot expand);
  otherwise the command fails, naming the nearest occurrences. An override
  for a time the series does not produce would add an instance, so adding
  a date is explicit: `+update --recurrence-id <new date> --add-occurrence`.
  When the server cannot expand the series and its rule uses parts omail's
  own expansion does not handle (by-month-day, by-month, by-hour, set
  positions, nth weekdays, excluded rules, a monthly/yearly start after day
  28, a weekly by-day list without the start's weekday, an until with
  fractional seconds on the start or the until, …), the check refuses
  instead of guessing
- For an occurrence in a spring-forward gap the server expands it at the
  shifted time (02:30 → 03:30 in New York) on the gap day and, for a series
  that had that occurrence, the day after, then returns to 02:30; `+agenda` reports the RFC 5545 time (02:30) until
  an override exists under the server's id. Either id works: omail writes
  under the server's id and says so on stderr. If the server cannot expand
  the series, such an id is refused (omail cannot know the server's key);
  pass the server's id with `--add-occurrence` instead. Server errors other
  than "cannot expand" fail the command rather than skip the check
- Updating/deleting a recurring event without `--series` or
  `--recurrence-id` returns an error prompting the user to specify
- `--alert <minutes>` is repeatable; `--use-default-alerts` overrides custom alerts
- `--online` only accepts https/http URLs (blocks javascript:/data:)
- `--all-day` requires date-only `--start` (YYYY-MM-DD); duration in days.
  On the wire the start is sent as a LocalDateTime at midnight
  (`YYYY-MM-DDT00:00:00`) with `showWithoutTime: true` — a bare date is
  rejected by the server
- `--add-invite` auto-creates organizer from session when event has no participants
- The organizer participant is created with `participationStatus: accepted`
- `+agenda` and `+freebusy` (without `--email`) apply each occurrence's
  override (changed title, time, status), including one moved into the
  window from another day, and compare times in each event's own zone
- `+agenda` lists events that start in the window; `+freebusy` (without
  `--email`) reports every event that overlaps it, skipping cancelled
  events and `freeBusyStatus: free`. Each slot's `start` is local to its
  `timeZone` field (absent or null means floating)
- Occurrences of a recurring event in `+agenda` / `+freebusy` output carry
  `recurrenceId`, the occurrence's original start. Pass that (not `start`,
  which an override may have moved) to `--recurrence-id`
- `+update --recurrence-id` keeps the occurrence's existing changes (a
  moved start, its own attendees and RSVPs) and applies only the fields
  given; `--start` is read in the occurrence's own zone
- `+update --series --start/--tz` is refused while the series has
  per-occurrence changes (exclusions or edits): those are keyed to the
  current start times and would be detached. Change single occurrences
  with `--recurrence-id`, or remove the changes first
- `+copy` requires target account to have calendar capability
- `+copy` to the same account returns `invalidArguments`. Copy only to
  another account in the session where you have write rights
- `+parse` checks capability + catches unknownMethod (belt+suspenders)
- Calendar sharing is the `shareWith` property of `Calendar/set` under
  `urn:ietf:params:jmap:calendars` — no separate sharing capability exists.
  Roles: reader, writer, admin. `unshare` fails if the calendar is not
  currently shared with that user
- `--recurrence-id` works on a recurring event that has no overrides yet:
  the CLI reads `recurrenceOverrides` first and seeds the map when it is
  null (a pointer patch into a null map is `invalidPatch` per RFC 8620)
- Multi-user freebusy (`--email`) requires
  `urn:ietf:params:jmap:principals` capability. It covers principals on
  the same server only; an address on another server returns `notFound`
- Always use `--dry-run` first when creating or modifying events via AI
