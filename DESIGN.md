# Handoff: LinguaThread — Mobile App

> **Platform target:** Flutter (iOS + Android)
> **Fidelity:** High-fidelity — pixel-perfect prototype. Recreate UI exactly using Flutter widgets.
> **Design reference:** `LinguaThread.dc.html` — an interactive HTML prototype. Do NOT ship the HTML. Use it as a visual + behavioral reference to build native Flutter screens.

---

## Overview

LinguaThread is a language-learning social platform where users:
- Create and consume **Threads** (structured learning paths built from Nodes)
- Complete **Nodes** (micro learning activities: vocabulary flashcards, quizzes, writing tasks, speaking recordings, fill-in-the-blank, discussions, AI roleplay)
- Earn **Gemma** (reputation points), XP, streaks, and badges
- Follow other learners and post tips/insights in a social feed

---

## Design Philosophy (Notion-Inspired)

- **Ultra-minimalist.** No gradients, no decorative elements, no heavy shadows.
- **Text-first.** Hierarchy via font weight, not color.
- **White space is intentional.** Never fill space for the sake of it.
- **Monochrome accent.** The only "brand color" is `#37352F` (near-black). All other colors are muted pastels for badges/tags only.

---

## Design Tokens

### Colors
```dart
// Core
const Color kInk       = Color(0xFF37352F); // Primary text, buttons, active states
const Color kBg        = Color(0xFFFFFFFF); // Main background
const Color kBgSubtle  = Color(0xFFFBFBFA); // Cards, sidebar sections
const Color kBgMuted   = Color(0xFFF7F6F3); // Input fields, muted surfaces
const Color kDivider   = Color(0xFFEDECE9); // All dividers and borders
const Color kTextMuted = Color(0xFF787774); // Secondary text
const Color kTextLight = Color(0xFF9B9A97); // Tertiary text, placeholders
const Color kTextDim   = Color(0xFFAEACA7); // Disabled, rank numbers

// Gemma (reputation currency)
const Color kGemmaBg   = Color(0xFFFEF9EC); // Gemma chip background
const Color kGemmaText = Color(0xFFA37010); // Gemma value text
const Color kGemmaBord = Color(0xFFF5E0A0); // Gemma chip border

// Streak / Fire
const Color kStreakBg  = Color(0xFFFEF4EF); // Streak badge background
const Color kStreakText = Color(0xFFC2410C); // Streak text color

// Level badges
const Color kA_Bg   = Color(0xFFE8F5E8); const Color kA_Text   = Color(0xFF1E6B1E);
const Color kB_Bg   = Color(0xFFEAF2FB); const Color kB_Text   = Color(0xFF1A4E8F);
const Color kC_Bg   = Color(0xFFF3ECF9); const Color kC_Text   = Color(0xFF5E2F8F);

// Quiz feedback
const Color kCorrectBg   = Color(0xFFE8F5E8); const Color kCorrectText   = Color(0xFF1A5C1A);
const Color kCorrectBord = Color(0xFFA8D8A8);
const Color kWrongBg     = Color(0xFFFDEEEE); const Color kWrongText     = Color(0xFF8B1A1A);
const Color kWrongBord   = Color(0xFFF5B8B8);

// Recording / error
const Color kRecordRed = Color(0xFFE53E3E);
```

### Typography
```dart
// Font: DM Sans (Google Fonts package: google_fonts)
// Fallback: system sans-serif

// Scale
const tPageTitle   = TextStyle(fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: -0.5, color: kInk);
const tTitle       = TextStyle(fontSize: 17, fontWeight: FontWeight.w700, letterSpacing: -0.3, color: kInk);
const tHeading     = TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: kInk);
const tBody        = TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 1.65, color: kInk);
const tBodyMed     = TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: kInk);
const tBodyBold    = TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: kInk);
const tSmall       = TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: kTextMuted);
const tSmallMed    = TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: kTextMuted);
const tSmallBold   = TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: kInk);
const tCaption     = TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: kTextLight);
const tLabel       = TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8, color: kTextLight);
const tMicro       = TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: kTextLight);
```

### Spacing & Shape
```dart
const double kRadius    = 4.0;   // Default border radius (very minimal — Notion style)
const double kRadiusMd  = 6.0;   // Cards, inputs
const double kRadiusLg  = 8.0;   // Thread hero card, emoji box
const double kRadiusXL  = 12.0;  // Bottom sheets, chat bubbles

const double kPadPage   = 16.0;  // Horizontal page padding
const double kPadCard   = 14.0;  // Inside cards
const double kGapSm     = 6.0;
const double kGapMd     = 10.0;
const double kGapLg     = 14.0;
```

---

## App Structure

```
LinguaThread
├── Bottom Nav (5 tabs)
│   ├── Home (Feed)
│   ├── Explore
│   ├── Create (+)      ← center FAB-style tab
│   ├── Notifications
│   └── Profile (Me)
│
├── Pushed Screens (Navigator.push)
│   ├── Thread Detail
│   ├── Leaderboard
│   └── Node Screens (7 types)
│       ├── Vocabulary Flashcard
│       ├── Multiple Choice Quiz
│       ├── Writing Task
│       ├── Speaking Task
│       ├── Discussion
│       ├── Fill in the Blank
│       └── AI Roleplay Chat
│
└── Modals (showModalBottomSheet)
    └── Enroll / Join Thread
```

---

## Bottom Navigation Bar

```
Height: 83px total (includes iOS home indicator safe area)
Active tab: kInk (#37352F), weight 700 stroke
Inactive tab: kTextDim (#AEACA7), weight 1.8 stroke
Border top: 1px solid kDivider
Background: white

Tabs (left → right):
1. Home    — house icon
2. Explore — search/magnifier icon
3. Create  — center button: 44×44px, background kInk, rounded 10px, white + icon
4. Inbox   — bell icon, red dot badge (8px) when unread notifications exist
5. Me      — person icon

Labels: 10px, weight 500 inactive / 700 active, below each icon
```

---

## Screen 1: Feed (Home)

**Purpose:** Main social feed mixing Threads and Posts, with an enrolled-thread resume banner.

### Layout
```
- Top bar (fixed): 
    - Left: "LinguaThread" (18px bold) + 🔥 streak chip (amber bg)
    - Right: search icon (24px)
    - Below: horizontal scrollable filter pills: "for-you" | "following" | "🧵 Threads" | "📝 Posts"
    
- Resume Banner (sticky below top bar):
    - Background: #FBFBFA, border 1px kDivider, radius 6px, margin 12px 16px
    - Left: thread emoji (22px)
    - Center: "Continue learning" label (12px muted) + node title (14px bold) + progress bar (3px height)
    - Right: ▶ button (kInk bg, white text, 6px 12px padding, radius 4px)

- Feed list (scrollable):
    - Mix of ThreadCards and PostCards
    - Separated by 1px kDivider lines
```

### ThreadCard
```
Padding: 16px
Layout:
  Row:
    - Emoji box: 44×44px, bg #F7F6F3, radius 6px, border 1px kDivider
    - Column:
        - Row: LevelBadge + language text (11px muted)
        - Title: 15px bold, 1.3 line-height
        - Row: Avatar (16px) + creator name (12px) + GemmaChip
  Description: 13px muted, 1.55 line-height, margin-left 56px
  Meta row (ml 56): 👥 enrolled · ⬡ nodeCount · ⏱ duration (12px muted)
  Progress bar (if enrolled + progress > 0): 3px height, kInk fill, ml 56
  Tag chips: #tagname chips (ml 56)
  CTA button:
    - Enrolled: "▶ Continue" — bg #F7F6F3, color kInk, border kDivider
    - Not enrolled: "+ Join Thread" — bg kInk, color white
    - 8px 16px padding, radius 4px, 13px bold
```

### PostCard
```
Padding: 16px
Layout:
  Row: Avatar (36px) + Column (name row + handle)
    Name row: username (14px bold) + GemmaChip + time (12px muted, right-aligned)
  Body text: 14px, 1.65 line-height
  Tags row: chip array
  Actions row: 
    - ♥ Like (count) — fills kInk on tap
    - 💬 Comments (count)
    - ◆ Gift Gemma (right-aligned, amber text)
```

### LevelBadge Component
```dart
// CEFR level → color mapping
A1/A2: bg #E8F5E8, text #1E6B1E
B1/B2: bg #EAF2FB, text #1A4E8F
C1/C2: bg #F3ECF9, text #5E2F8F
// Style: 2px 7px padding, radius 3px, 11px bold
```

### GemmaChip Component
```dart
// bg: #FEF9EC, text: #A37010, border: none
// Content: "◆ " + number (formatted with commas)
// Padding: 2px 7px, radius 3px, 11px bold
// Large variant (lg): 13px, 3px 8px padding
```

---

## Screen 2: Explore

**Purpose:** Search + discover trending threads and top creators.

### Layout
```
- Search bar (fixed):
    - bg #F7F6F3, border 1px transparent → kInk on focus, radius 6px, padding 10px 12px
    - Search icon + text input + clear ✕ button
    - Below: horizontal scrollable language filter pills (All Languages, English, Japanese, etc.)

- Empty state (no search):
    Row 1: "🔥 Trending Threads" heading + "See all" link
    Thread list rows: emoji box + title + LevelBadge + enrolled count

    Row 2: Leaderboard teaser card
    - bg #FBFBFA, border kDivider, radius 6px, padding 14px
    - "🏆 Weekly Leaderboard" + rank info text
    - Chevron right icon

    Row 3: "⭐ Top Creators" heading
    - Horizontal scroll of avatar + first name + GemmaChip (68px wide each, 44px avatars)

- Search results state:
    Result count label (11px muted caps)
    List rows: emoji box + title + LevelBadge + enrolled count (same as trending)

- No results state: centered message, 40px padding
```

---

## Screen 3: Thread Detail

**Purpose:** Full thread info page with learning path node list.

### Layout
```
- Back bar: ← arrow (32×32 tap target) + Share icon (right)

- Hero section (padding 20px 16px):
    - Emoji box: 56×56px, bg #F7F6F3, radius 8px, border kDivider
    - Title: 20px bold, 1.3 line-height
    - Description: 14px muted, 1.6 line-height
    - Creator row: Avatar (28px) + name (13px bold) + handle (12px muted) + GemmaChip + "◆ Tip" button
    - Metadata chips: LevelBadge + 🌐 lang + ⬡ nodes + ⏱ duration + 👥 enrolled
    - Progress bar (if enrolled): 5px height, labeled with %

- Learning Path section:
    - Header: "Learning Path" (14px bold) + node count (12px muted)
    - Node list rows (padding 12px 16px, border-bottom kDivider):
        Left: circle indicator
          - Done: 28px filled kInk, white checkmark
          - Current: 28px transparent, 2px kInk border, number inside (bold)
          - Locked: 28px #F7F6F3, 1px kDivider border, number (muted)
        Center: node title (14px, bold if current) + NodeBadge chip
        Right: 7px filled dot if current node
        Background: #FAFAFA if current node

- Sticky bottom bar: primary CTA button full width
    - "▶ Continue Learning" / "▶ Start Learning" / "+ Join Thread — Free"
```

### NodeBadge Component
```dart
// bg: #F7F6F3, border: 1px kDivider, radius: 3px, text: 10px muted
// Labels: "Vocabulary" | "Quiz" | "Writing Task" | "Speaking Task" | 
//         "Discussion" | "Fill in Blank" | "Roleplay" | "Reading"
```

---

## Screen 4: Node — Vocabulary Flashcard

**Purpose:** Flip-card vocabulary drill.

### Layout
```
- Back bar: title + "N/total" counter (right)
- Progress bar: 3px, kInk fill, animated width transition

- Card area (flex:1, centered, bg #FBFBFA, padding 24px 20px):
    - "Tap card to flip" hint (11px muted caps)
    
    - Flip card (full width, 270px height, 3D flip animation):
        Front face (white bg, border kDivider, radius 8px):
          - LevelBadge (top left)
          - Word: 30px bold, kInk, letter-spacing -1px
          - Part of speech: 15px italic muted
          - Thin divider
          - "🔊 Tap to hear · Tap card to flip" (12px muted)
        
        Back face (bg kInk = #37352F, radius 8px):
          - "DEFINITION" label (11px, rgba white 40%, caps, letter-spacing 0.8px)
          - Definition text: 17px bold white, 1.5 line-height
          - Divider: 1px rgba white 12%
          - "EXAMPLE SENTENCE" label
          - Example: 14px italic rgba white 80%, 1.65 line-height, in quotes
    
    - Flip animation: CSS perspective rotateY 0→180deg, 0.5s cubic-bezier(0.4,0,0.2,1)
    
    - Bottom buttons row:
        "← Prev" (flex:1, bg #F7F6F3, border kDivider, disabled if index=0)
        "Next →"  (flex:2, bg kInk, white)
        Last card: "✓ Finish"
```

---

## Screen 5: Node — Multiple Choice Quiz

**Purpose:** Single-question quiz with A/B/C/D options.

### Layout
```
- Back bar: title + "Q1 / 5" counter
- Progress bar: 20% per question

- Scroll area (padding 24px 16px):
    - "MULTIPLE CHOICE" label (11px caps muted)
    - Question text: 16px bold, 1.6 line-height
    
    - Option cards (padding 13px 14px, radius 6px, margin-bottom 8px):
        Default:    bg white, border 1px kDivider
        Selected:   bg kInk, text white, border none
        After submit:
          Correct:  bg #E8F5E8, border #A8D8A8, text #1A5C1A, ✓ icon
          Wrong:    bg #FDEEEE, border #F5B8B8, text #8B1A1A, ✗ icon
          Others:   bg white, text muted
        
        Layout: Row (circle letter A/B/C/D) + option text + result icon
        Circle: 22px, bg #F1F0EF (or rgba white if selected)
    
    - Explanation card (shows after submit):
        bg #F7F6F3, border kDivider, radius 6px
        "💡 Explanation" label + explanation text (14px)

- Sticky bottom button:
    Before submit: "Check Answer" — disabled (bg #F1F0EF) until selection; active: kInk bg
    After submit:  "Next Question →" — always kInk bg
```

---

## Screen 6: Node — Writing Task

**Purpose:** Prompted writing with optional AI feedback scoring.

### Layout
```
- Back bar: title + "Node 3/8"

- Scroll area (padding 20px 16px):
    - Prompt card (bg #F7F6F3, border kDivider, radius 6px, padding 14px):
        "✍️ WRITING PROMPT" label
        Prompt text (14px, 1.65 line-height)
        "Write an introduction paragraph · Target: 80–120 words" (12px muted)
    
    - Textarea: min-height 160px, border kDivider, radius 6px, 14px, 1.7 line-height
    
    - Word count row: left "N words" (green if 80-120, red if >120, muted otherwise)
                      right "80–120 target" (muted)
    
    - AI Feedback panel (appears after "AI Check" tap):
        Header row: "🤖 AI Feedback" + score "6.5 / 9.0" (24px bold score)
        4 criteria rows (Task Response, Coherence, Vocabulary, Grammar):
          - Row: criterion name (13px bold) + score (13px bold right)
          - 3px progress bar (score/9 × 100%)
          - Feedback note (12px muted)

- Sticky bottom bar (row):
    "🤖 AI Check" button — amber style (bg #FEF9EC, text #A37010, border #F5E0A0)
                           disabled if <8 words
    "Submit" / "Submit ✓" — kInk bg
```

---

## Screen 7: Node — Speaking Task

**Purpose:** Voice recording with AI pronunciation scoring.

### Layout
```
- Back bar: title + "Node 5/8"

- Content area (flex:1, bg #FBFBFA, padding 20px 16px):
    - Prompt card (same style as writing prompt)

    State: IDLE
        - 80×80px circular record button (bg kInk, mic icon white, shadow)
        - "Tap to start recording" label (14px muted)

    State: RECORDING
        - Waveform visualizer: 22 vertical bars, 3px wide, kInk color, staggered pulse animation
        - Timer: 32px bold, tabular-nums (MM:SS)
        - "Recording…" label (13px muted)
        - Stop button: 56px circle, bg #E53E3E, white square icon inside
          → pulsing ring animation (recordPulse keyframe: box-shadow expanding/fading)

    State: DONE
        - Playback card (bg white, border kDivider, radius 8px, padding 16px):
            "🎵 Your Recording" + duration (13px muted, right)
            Playback bar: 40px tall, bg #F7F6F3, radius 6px
              → ▶ circle button (26px, kInk) + progress track
        - "Record again" link (13px muted, underlined)

- Sticky bottom bar (only in DONE state):
    "Submit Recording ✓" full-width kInk button
```

### Animations
```
waveform bars:  animation: pulse Xs ease-in-out infinite (where X varies 0.5–0.9s per bar)
                animationDelay: index × 0.06s
                keyframes: 0%,100%{opacity:1;scaleY(1)} 50%{opacity:0.6;scaleY(0.5)}
recordPulse:    keyframes: 0%,100%{boxShadow: 0 0 0 0 rgba(229,62,62,0.4)}
                           70%{boxShadow: 0 0 0 14px rgba(229,62,62,0)}
```

---

## Screen 8: Node — Discussion

**Purpose:** Community threaded discussion around a prompt.

### Layout
```
- Back bar: title

- Prompt bar (fixed, bg #FBFBFA, border-bottom kDivider, padding 14px 16px):
    "💬 DISCUSSION PROMPT" label
    Prompt text: 15px bold, 1.5 line-height

- Response count label: "N responses" (11px muted caps, padding 12px 16px 4px)

- Discussion post rows (scroll, border-bottom kDivider, padding 14px 16px):
    Row: Avatar (32px) + Column (name 13px bold + "2h ago" 11px muted)
    Body: 14px, 1.65 line-height
    Actions: ♥ Like (count) + Reply (text button)
    → Like toggles filled/outline heart

- Input bar (fixed bottom):
    Textarea: flex:1, border kDivider, radius 6px, 14px, max-height 80px
    Send button: 38×38px, bg kInk, radius 6px, send/arrow icon (white)
    → Enter key also sends (Shift+Enter for newline)
```

---

## Screen 9: Node — Fill in the Blank

**Purpose:** Three fill-in-the-blank sentences with inline text inputs.

### Layout
```
- Back bar: title + "Node 7/8"
- Progress bar: 87.5% (7/8)

- Scroll area (padding 20px 16px):
    "FILL IN THE BLANK" label + "Type the correct…" subtitle (13px muted)
    
    - Sentence cards (bg white, border 1px → green/red after check, radius 6px, padding 14px, mb 12px):
        Sentence text with inline TextInput replacing the blank:
          - Runs inline with text (no block break)
          - Border-bottom only: 2px kInk → green correct / red wrong after check
          - Min-width: 100px
        Hint text: 12px muted italic below
        After check: "✓ Correct!" (green bold) or "✗ Answer: [word]" (red bold)

- Sticky bottom:
    Before check: "Check Answers" — kInk
    After check: "Next Node →" — kInk
```

---

## Screen 10: Node — AI Roleplay Chat

**Purpose:** Conversational IELTS speaking practice with AI examiner.

### Layout
```
- Back bar: "Examiner Roleplay"

- Scene bar (bg #F7F6F3, border-bottom kDivider, padding 10px 16px):
    "🎭 Scene: IELTS Speaking Part 1 — Respond naturally in English to the AI examiner."
    12px muted, 1.5 line-height

- Message scroll area (padding 16px, flex-column, gap 12px):
    AI messages (left-aligned):
      Row: 🤖 avatar (28px circle kInk bg) + bubble
      Bubble: bg #F7F6F3, border kDivider, radius 12px 12px 12px 4px, padding 10px 13px, 14px text, max-width 80%

    User messages (right-aligned):
      Row: bubble + AT avatar (28px)
      Bubble: bg kInk, white text, radius 12px 12px 4px 12px, padding 10px 13px, 14px text, max-width 80%

- Input bar (fixed bottom):
    Textarea + Send button (same as Discussion screen)
    Enter to send, Shift+Enter for newline
```

---

## Screen 11: Create Post

**Purpose:** Compose a Post or Thread.

### Layout
```
- Top bar: "New Post" (16px bold) + Draft button + Publish button (kInk, changes to "Publish Thread" when thread mode on)

- Scroll area (padding 16px):
    "LANGUAGE TAG *" section label + pill selector (English/Japanese/Korean/French/Spanish)
    
    Main textarea: min-height 180px, border kDivider, radius 6px, 15px, 1.7 line-height
    Placeholder: "What's on your mind?…"
    
    "SKILL TAGS (optional)" + tag chips (#writing, #grammar, etc.) — toggle on/off
    
    Divider line
    
    "Add Learning Path" toggle row:
      Left: title (14px bold) + subtitle "Turn this post into a Thread" (12px muted)
      Right: custom toggle switch 44×24px
        → bg kInk when ON, bg kDivider when OFF
        → white knob 18×18px slides left/right with animation

    Thread Settings panel (shows when toggle ON):
      bg #FBFBFA, border kDivider, radius 6px, padding 14px
      - "🧵 THREAD SETTINGS" label
      - Thread Title input
      - CEFR Level selector + Duration selector (side by side)
      - "⬡ Add Nodes (0)" button (bordered, full width)
```

---

## Screen 12: Notifications

**Purpose:** Activity inbox.

### Layout
```
- Top bar: "Notifications (N)" + "Mark all read" link (if unread exist)

- "TODAY" section label (11px muted caps, padding 12px 16px 4px)
- "EARLIER" section label

- Notification rows (padding 12px 16px, border-bottom kDivider):
    Unread: bg #FAFAFA
    Read: bg white
    
    Left: Avatar (36px) + type badge overlay (18px circle, bottom-right of avatar):
          follow: bg #F1F0EF, icon 👤
          gemma:  bg #FEF9EC, icon ◆
          comment: bg #EAF2FB, icon 💬
          streak: bg #FEF4EF — no avatar, just 36px icon circle
          node:   bg #F7F6F3, icon ⬡
          like:   bg #FDEAEA, icon ♥
    
    Center: bold username + message body (14px, 1.5 line-height)
             time "Xh ago" (12px muted)
    
    Right: 7px kInk dot if unread
    
    → Tap row marks as read (removes dot)
```

---

## Screen 13: Profile

**Purpose:** Personal stats, Gemma reputation, XP level, badges, and content tabs.

### Layout
```
- Top bar: handle (16px bold) + hamburger menu icon

- Scroll area:
    Hero section (padding 20px 16px 16px, border-bottom kDivider):
      Row: Avatar (66×66px circle, 3px kDivider border) + Column:
            Name (17px bold) + Level badge "Lv.N" (11px bold, bg #F7F6F3, border kDivider)
            Handle (13px muted)
            Bio text (13px, 1.5 line-height)
      
      Stats row (border-top + border-bottom kDivider, py 12px):
        Posts | Following | Followers — each: number (17px bold) + label (12px muted)
      
      2-column grid (gap 8px, mb 14px):
        Left:  "◆ EARNED GEMMA" — bg #FEF9EC, border #F5E0A0, radius 6px
               value: 24px bold, "Reputation score" caption
        Right: "◆ GIFTED GEMMA" — bg #FFFBF0, border #FFE49A
               value: 24px bold, "Tips received" caption
      
      XP Progress (mb 14px):
        Row: "Level N" (13px bold) + 🔥 streak chip + "XXXX / YYYY XP" (12px muted, right)
        8px progress bar (radius 4px, kInk fill)
        "X XP to Level N+1" (12px muted)
      
      Badges row:
        "BADGES" label + row of 38×38px badge tiles (bg #F7F6F3, border kDivider, radius 6px, emoji 18px)
    
    Tab bar: Created | Enrolled | Posts
      - Active: 2px kInk bottom border, bold kInk text
      - Inactive: muted
    
    Tab content:
      Created: Thread list rows (emoji 36px + title + LevelBadge + enrolled + GemmaChip)
      Enrolled: Thread rows with progress bar
      Posts: Post preview rows (body text + like/comment/time)
```

---

## Screen 14: Leaderboard

**Purpose:** Weekly/all-time XP ranking with podium visualization.

### Layout
```
- Top bar: ← back + "🏆 Leaderboard" + Weekly/All Time filter pills

- Podium section (bg #FBFBFA, border-bottom kDivider):
    3 columns (2nd place | 1st place | 3rd place) arranged podium-style:
    Each: emoji badge + Avatar (46px for 1st, 38px for 2nd/3rd) + first name + "Xk XP"
    Podium platform heights: [76, 96, 62]px
    Platform bg: [#EDECE9, #EDE8D5, #F1F0EF]
    Rank number inside platform: 20-26px bold, opacity 35%

- Rank list (rows 4+):
    Row: rank# (14px muted, 22px width) + Avatar + name + handle (if applicable)
         Right: "Xk XP" (14px bold) + "🔥 Nd" streak (11px muted)
    Current user ("You"): bg #FAFAFA, name "You · Alex Tran" (bold)
```

---

## Enroll Bottom Sheet (Modal)

**Purpose:** Confirm Thread enrollment.

```
showModalBottomSheet, borderRadius 16px top corners
Drag handle: 40×4px rounded, centered, 16px below top

Content (padding 0 16px 36px):
  Thread hero: emoji box (50px) + title (17px bold) + LevelBadge
  Description: 14px muted, 1.6 line-height
  3-column stat grid: ⬡ nodes | ⏱ duration | 👥 enrolled
  Creator row: Avatar + name + handle + GemmaChip
  "Enroll Now — Free" button (full width, kInk, 14px)
  → On tap: mark as enrolled, navigate to Thread Detail
  "Not now" text button (muted, no border)
```

---

## Shared Components

### Avatar
```dart
// Circular, initials-based colored avatar
// Size: varies (16, 28, 32, 34, 36, 44, 46, 66px)
// Color per initials (deterministic):
SC → #EFE5D5   YT → #D5E5EF   DP → #D5EFDA
MJ → #EFD5E5   LN → #EFEDD5   AR → #D5EFED
AT → #EDE8D5   CR → #E5D5EF   EW → #D5EFDF
// Font: 33% of size, weight 700
```

### Primary Button
```dart
// bg: kInk, text: white, radius: 4px, padding: 13px vertical, full width
// Font: 15px bold
// Disabled: bg #F1F0EF, text kTextLight
```

### Filter Pill
```dart
// Active:   bg kInk, text white, no border
// Inactive: bg transparent, text kTextMuted, border 1px kDivider
// Padding: 6px 14px, radius 20px, 13px medium
```

### Tag Chip
```dart
// "#tag" format, bg #F1F0EF, radius 3px, padding 2px 7px, 11px medium, text kTextMuted
```

### Back Bar
```dart
// Height: ~52px, border-bottom 1px kDivider, padding 12px 16px
// Left: 32×32 tap target, ← icon (strokeWidth 2.5, kInk)
// Center: title 15px bold
// Right: optional action icon
```

### Section Label
```dart
// "SECTION TITLE" style: 11px bold, kTextLight, letterSpacing 0.8, UPPERCASE
```

---

## Navigation Flow

```
Feed ──→ Thread Detail ──→ Node (any type) ──→ back to Thread Detail
Feed ──→ Enroll Sheet ──→ Thread Detail
Explore ──→ Thread Detail
Explore ──→ Leaderboard
Profile tabs navigate in-place (no push)
Bottom nav tabs always pop to root of that tab
```

---

## State Management (Recommended Flutter approach)

```dart
// Use Riverpod or BLoC
// Key state:
- feedFilter: 'for-you' | 'following' | 'threads' | 'posts'
- enrolledThreadIds: Set<String>
- likedPostIds: Set<String>
- unreadNotifIds: Set<String>
- currentNodeIndex: int (per thread)
- vocab: { index: int, flipped: bool }
- quiz: { selected: int?, submitted: bool }
- writing: { text: String, aiChecked: bool }
- speaking: { state: idle|recording|done, seconds: int }
- discussion: { posts: List, inputText: String }
- fill: { answers: List<String>, checked: bool }
- roleplay: { messages: List<{ role, text }>, inputText: String }
```

---

## Files in This Package

| File | Description |
|---|---|
| `README.md` | This document — full design spec |
| `LinguaThread.dc.html` | Interactive HTML prototype — open in any browser to see all screens |

---

## How to Use This Handoff

1. **Open `LinguaThread.dc.html` in Chrome or Safari** to interact with the full prototype.
2. Use the **bottom navigation** to switch between main screens.
3. On the **Feed** screen, tap any Thread card to see Thread Detail.
4. Tap **▶ Continue Learning** to enter Node screens (all 7 types are wired up).
5. Use the `README.md` as your implementation spec — every pixel value, color, and behavior is documented above.

> Build in Flutter using `google_fonts` (DM Sans), `go_router` for navigation, and your state manager of choice. The HTML prototype uses React/JS — treat it purely as a visual/behavioral reference.
