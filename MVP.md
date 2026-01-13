# MVP Spec - Special Needs Care Planner (working title)

## Product intent
A calming, caregiver-first planner for special needs routines. The MVP focuses on two advanced features: supplement scheduling and guided home therapy coaching, without referencing any specific diagnosis.

## Target users
- Primary caregivers managing daily schedules, supplements, therapies, and diets.
- Clinicians who review progress summaries (via shared reports).

## MVP goals
- Help caregivers build and follow a daily plan for supplements and therapy sessions.
- Reduce missed tasks with gentle alarms and rescheduling.
- Capture history and notes for better care continuity.
- Provide a simple report to share with clinicians.

## MVP scope (features)
### 1) Account + profile
- Create a child profile: name, birth date, weight (kg), notes.
- Optional account registration (email + password) for cross-device sync.

### 2) Biomedical supplement scheduler
- Start a supplement plan with a guided wizard:
  - Select from a supplement list or add a custom item.
  - Enter dose rules (per kg or fixed), frequency, and ramp-up schedule.
  - Generate a schedule based on available times.
- Daily schedule view with alarm notifications.
- One-tap actions: Taken, Skipped, Reschedule.
- Missed alerts auto-mark as taken but flagged (per user note).
- History log per supplement and per day.

### 3) Home therapy coaching
- Therapy catalog with category + short instructions + image.
- Step-by-step guided sessions (timer, cues, calming audio).
- Add to plan with time + optional alert.
- Session notes and rating/checklist at completion.

### 4) Notes + report sharing
- Daily notes tied to the plan.
- Weekly report summary (plan adherence, supplements, therapy sessions, diet notes).
- Export/share as PDF or shareable link for clinician follow-up.

### 5) Calming media
- A small built-in library of calming audio/video for session use.
- Offline caching for a handful of items.

## Out of scope for MVP
- Diet planning.
- Multi-child dashboards.
- Advanced clinician portal with accounts and messaging.
- Insurance/clinical integrations.
- Marketplace or paid add-ons.
- Multi-language localization (planned for later).
- Complex AI recommendations.

## Core user flows
1) Onboarding -> Create child profile -> Set schedule availability -> Build supplement plan -> Start daily plan.
2) Daily plan -> alarms fire -> user marks Taken/Skipped/Reschedule -> history captured.
3) Add therapy -> start guided session -> timer + calming audio -> notes + rating/checklist.
4) Weekly report -> generate -> export/share.

## Data model (minimal)
- User
- ChildProfile (name, DOB, weightKg, notes)
- Supplement (name, doseRule, frequency, rampUp, scheduleTimes)
- SupplementLog (dateTime, status, note)
- Therapy (name, category, instructions, image)
- TherapySession (dateTime, duration, rating, notes, checklist)
- DailyPlan (date, items[], status)
- Report (range, summary, exportLink)

## Screens
- Welcome / account
- Child profile
- Plan wizard (supplements, therapies, diet)
- Today (timeline of tasks)
- Supplements detail + history
- Therapy detail + session timer
- Notes
- Reports
- Settings

## Non-functional
- Accessibility: large text, simple language, clear icons.
- Data privacy: local-first with optional cloud sync.
- Medical disclaimer: informational only; not medical advice.
- Calm UX: soft tones, non-jarring alerts, snooze/reschedule.

## Success metrics (MVP)
- Daily plan completion rate.
- Weekly active caregivers.
- # of generated reports shared.

## Decisions (MVP)
- Platforms: Flutter with a single codebase targeting mobile and web.
- Caregivers: single caregiver per child profile.
- Supplement dose rules: support both manual entry and a curated list.
- Scope focus: supplements + home therapy coaching only.
