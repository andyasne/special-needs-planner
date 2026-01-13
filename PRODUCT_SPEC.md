# Product Spec - Special Needs Care Planner

## Vision
Create a calm, trustworthy planning and tracking system for special needs care routines, usable by caregivers and clinicians, without referencing any specific diagnosis. The product focuses on two advanced areas: supplements and guided home therapy coaching, delivered across mobile and web.

## Positioning
A caregiver-first planner that reduces decision fatigue and improves consistency through gentle scheduling, simple tracking, and clear summaries for follow-up care.

## Target users
- Caregivers managing daily care routines.
- Clinicians reviewing shared summaries.
- Secondary caregivers (future) supporting shared routines.

## Guiding principles
- Calm and non-judgmental tone.
- Minimal cognitive load.
- Privacy-first; caregiver controls sharing.
- Clear disclosures: informational only, not medical advice.

## Product goals
- Increase daily plan adherence for supplements and therapy sessions.
- Reduce missed tasks through gentle alarms and smart rescheduling.
- Make care history easy to understand and share.
- Support consistent routines across time.

## Personas
1) Primary caregiver
- Needs: a reliable daily plan, gentle reminders, and quick logging.
- Pain: juggling routines, missed tasks, unclear patterns.

2) Clinician
- Needs: concise summaries, clear logs, and trend signals.
- Pain: fragmented or missing data.

3) Secondary caregiver (later)
- Needs: shared plan, clear responsibilities, and updates.

## Feature scope
### Core modules
1) Accounts and profiles
- Caregiver account with optional cloud sync.
- Child profile: name, DOB, weight, notes.
- Multiple profiles (future phase).

2) Supplements
- Curated list + custom entry.
- Dosing rules: per kg, fixed, or ramp-up schedule.
- Schedule generation based on availability.
- Missed-dose logic: gentle prompt, optional reschedule or skip.
- Adverse reaction logging + optional plan change.

3) Home therapy coaching
- Therapy catalog with categories, instructions, and media.
- Step-by-step guided sessions with cues and calming audio.
- Add to plan with timing, duration, and alerts.
- Session notes + rating/checklist.

4) Plans and schedules
- Daily and weekly views.
- Timeline view for today with alerts.
- Edit, pause, or remove items.
- Plan history with versions.

5) Notes and journals
- Daily notes, free-form or tagged.
- Attach to supplements/therapy events.

6) Reports and sharing
- Weekly and monthly summaries.
- Export as PDF.
- Shareable link with access control.

7) Calming media
- Built-in library for audio/video.
- Offline caching for a small set.
- Use during therapy sessions or bedtime.

8) Settings
- Language preferences (future).
- Notification settings with calming alarm sounds.
- Account management and data export.

### Clinician follow-up (phase 2)
- Clinician view of shared reports.
- Secure access without requiring a full account.

### Out of scope (near term)
- Diet planning.
- Clinical decision-making or diagnosis.
- Insurance or medical system integrations.
- AI-driven recommendations.

## User journeys
1) First-time caregiver
- Create account -> add child profile -> set availability -> start supplement plan -> see today timeline.

2) Daily routine
- Notifications arrive -> mark taken/skipped/reschedule -> quick notes -> view progress.

3) Therapy session
- Select therapy -> start guided session -> play calming audio -> add notes and rating/checklist.

4) Sharing with clinician
- Generate weekly report -> share link/PDF -> clinician reviews summary.

## Experience requirements
- Large text options and readable typography.
- Clear status colors, avoid red/green-only encoding.
- Soft tones; avoid harsh alerts.
- Calm animations; no aggressive flashing.

## Platform
- Flutter single codebase for mobile (iOS/Android) and web.
- Local-first with optional sync.

## Data model (extended)
- User (id, email, preferences)
- ChildProfile (id, name, DOB, weightKg, notes)
- Supplement (id, name, category, doseRule, frequency, rampUp, scheduleTimes)
- SupplementLog (id, supplementId, dateTime, status, note, dose)
- Therapy (id, name, category, instructions, media)
- TherapySession (id, therapyId, dateTime, duration, rating, notes, checklist)
- DailyPlan (id, date, items[], status)
- PlanVersion (id, createdAt, planData)
- Report (id, range, summary, exportLink, createdAt)
- ShareLink (id, reportId, expiresAt, accessLevel)

## Information architecture
- Home (Today timeline)
- Plan (Supplements, Therapy, Diet)
- Notes
- Reports
- Settings

## Metrics
- Daily plan completion rate.
- Weekly active caregivers.
- Session adherence by category.
- Report share rate.

## Risks and mitigations
- Overwhelming onboarding -> use progressive setup with save-and-continue.
- Data sensitivity -> local-first, encrypted storage, explicit sharing.
- Alarm fatigue -> calm schedules and gentle rescheduling.

## Compliance and safety
- Medical disclaimer on plans and reports.
- Clear data ownership and export options.

## Roadmap (suggested)
Phase 1 (MVP)
- Core modules: supplements, therapies, diets, notes, reports.

Phase 2
- Multi-caregiver support.
- Clinician portal.
- Multi-language.

Phase 3
- Integrations and expanded content library.
