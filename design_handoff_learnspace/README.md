# Handoff: LearnSpace — Mobile English-Learning Social App (Flutter)

## Overview
LearnSpace là app học tiếng Anh kết hợp mạng xã hội. Người dùng đăng bài, theo dõi giáo viên/gia sư, follow **lộ trình học** (roadmap) theo kiểu Duolingo với streak, làm nhiệm vụ mỗi ngày, và chat 1-1 / nhóm có gắn deep-link tới lộ trình.

Phạm vi bản design này: **Login + 4 tab chính** (Trang chủ/Feed, Lộ trình, Tin nhắn, Cá nhân) + 2 overlay (Chat thread, Roadmap detail).

## About the Design Files
Các file trong bundle này là **design reference viết bằng HTML/React** — prototype thể hiện look & behavior mong muốn, **KHÔNG phải code production để copy thẳng**.

Stack đích là **Flutter (mobile)**. Vì vậy nhiệm vụ là **tái dựng các màn này thành Flutter Widgets** theo pattern/thư viện sẵn có của project, KHÔNG bê nguyên JSX. Coi HTML/CSS là spec hình ảnh + reference logic. Mọi giá trị màu/spacing/typography ở phần Design Tokens là chuẩn để map sang `ThemeData`.

## Fidelity
**High-fidelity (hifi).** Màu, typography, spacing, radius, shadow, và tương tác đều là bản cuối. Hãy tái dựng pixel-perfect bằng widget Flutter. Layout, copy (tiếng Việt) lấy đúng như mô tả.

## Tech mapping: Web → Flutter (đọc trước khi code)

| Trong prototype (web) | Tương đương Flutter |
|---|---|
| Phone shell 402×874, bo góc 48 | Không cần — đó chỉ là khung mô phỏng iPhone. Dựng nội dung bên trong là đủ. |
| `div` + flexbox (`gap`) | `Column`/`Row` + `SizedBox`/`Gap`, hoặc `Wrap` |
| `.appbar` sticky + blur | `SliverAppBar` (pinned) hoặc `AppBar` có `flexibleSpace` + `BackdropFilter` |
| `.screen__scroll` (overflow auto) | `ListView` / `CustomScrollView` / `SingleChildScrollView` |
| `.tabbar` bottom nav 4 tab | `BottomNavigationBar` hoặc `NavigationBar` (Material 3) |
| `position: sticky` header chat | `SliverPersistentHeader` hoặc header cố định ngoài `Expanded(ListView)` |
| Roadmap detail (`.detail` slide-up overlay) | `showModalBottomSheet(isScrollControlled: true)` hoặc full-screen route với transition slide-up |
| CSS variables (`tokens.css`) | `ThemeData` + một class `AppColors`/`AppText`/`AppSpacing` (xem Design Tokens) |
| Avatar chữ cái + màu | `CircleAvatar(backgroundColor: …, child: Text(initials))` |
| Inline SVG icons | `flutter_lucide` hoặc `Icon` Material; custom (route/flame) dùng SVG asset |
| Drag-to-reorder queue | `ReorderableListView` |
| Streak fire, banner gradient | `LinearGradient` trong `BoxDecoration` |
| `useState` (like/follow/done) | `setState` trong `StatefulWidget`, hoặc Riverpod/Bloc nếu project đã có |
| Mock `window.DATA` | Model + repository gọi API thật; tạm thời hardcode để dựng UI |

Gợi ý package: `flutter_lucide` (icon stroke), `google_fonts` (Noto Sans), `flutter_svg` (logo/route/flame nếu cần). Dùng Material 3 (`useMaterial3: true`).

---

## Screens / Views

### 0. Phone shell (bỏ qua khi dựng Flutter)
Status bar 9:41, dynamic island, home indicator — chỉ là khung mô phỏng. Flutter dùng `SafeAreaView` thật của thiết bị.

### 1. Login
- **Purpose**: đăng nhập / vào app.
- **Layout** (Column, full height, nền trắng):
  - **Hero** (gradient mint, bo góc dưới 32px, padding 92px top): logo bo 16px (nền trắng 20% + border) chứa icon `route`; tên "LearnSpace" (font display, 700, 30px, màu trắng); tagline 14px opacity 92% "Học tiếng Anh cùng cộng đồng — theo lộ trình, giữ streak, kết nối gia sư."
  - **Form** (padding ngang 28): field Email (label 13px/600 + TextField), field Mật khẩu (có nút con mắt toggle hiện/ẩn), link "Quên mật khẩu?" (phải, primary-600).
  - **Nút "Đăng nhập"** (primary, full-width, 15px padding dọc, radius 14, shadow mint).
  - **Divider** "hoặc tiếp tục với".
  - **2 nút social** Google / Apple (outline, flex đều, icon + chữ).
  - Footer "Chưa có tài khoản? **Đăng ký ngay**" (đậm phần link, primary-600).
- **Behavior**: nhấn bất kỳ nút nào (Đăng nhập / Google / Apple) → vào app (tab Feed).

### 2. Trang chủ / Feed Tab
- **AppBar** (sticky, nền trắng 86% + blur): wordmark trái = logo mint bo 9px (icon route) + "LearnSpace" (display 700, 26px); phải = 2 icon tròn 40px nền `--color-bg-muted` (search, bell có chấm đỏ thông báo).
- **Body (ListView)**:
  1. **Live banner** (`.livecard`): card gradient tím đậm (#2A1B3D→#4F2EA3), radius 16, padding 14. Trái: avatar gia sư có ring. Giữa: badge "● LIVE" (nền đỏ, chấm trắng nhấp nháy), tên "Cô Linh Trang đang livestream", subtext "… · 312 đang xem". Phải: nút "Vào xem" (nền trắng 16%). *Toggle được qua tweak `showLive`.*
  2. **Discover gia sư** (`.discover`): header "Gia sư gợi ý cho bạn" + link "Bản đồ gia sư" (primary). Rail cuộn ngang các **teacher card** (rộng 168, radius 16, border): avatar 56 có ring, tên + tick verified, role 2 dòng, "x người theo dõi", nút **Theo dõi** (outline → đổi sang nền mint + "Đang theo dõi" khi bấm).
  3. **Section label** "BẢNG TIN" (uppercase, muted).
  4. **Feed posts** (card radius 16, border, gap 14): header avatar 44 (chấm online) + tên/tick + "role · time" + nút more; nội dung text 14.5px line-height 1.55; ảnh tùy chọn (190px, gradient, có nút play hoặc khối streak); **roadmap preview card** đính kèm (xem component bên dưới); footer action: tim (like, đỏ khi active, đếm số), comment, share, bookmark (đẩy phải, primary khi saved). Border-top mảnh phân cách footer.

### 3. Lộ trình / Roadmap Tab
- **Hero** (gradient mint dọc, padding-top 58): 
  - Hàng trên: **streak** = icon flame (#FFD89E) + số 23 (display 700, 34px) + "ngày streak"; phải nút "⚙ Quản lý" (nền trắng 18%).
  - Badge "ĐANG HỌC" + "IELTS · Cô Mai Anh".
  - Tiêu đề lộ trình (display 700, 21px, trắng).
  - Progress: "Ngày 12 / 30" ↔ "37% hoàn thành" + thanh bar (nền trắng 28%, fill trắng).
- **Nhiệm vụ hôm nay** (`.today`): header "Nhiệm vụ hôm nay" + "1/3 hoàn thành". Mỗi **task** (card radius 12, border): vòng tròn check 26px (tô mint + tick trắng khi done; gạch ngang label khi done) + label 14px + chip type ("Phát âm"/"Speaking"/"Writing", nền primary-50, chữ primary-600) + chevron. Bấm để toggle done.
- **Hành trình của bạn** (`.path`): các node dọc canh giữa, nối bằng đường 3px. Node:
  - `done`: tròn 58px nền mint, tick trắng, shadow đáy mint-700 (hiệu ứng nổi 3D `box-shadow: 0 5px 0`).
  - `today`: nền trắng, border mint 3px, shadow mint; có pill "BẮT ĐẦU" phía trên (mũi tên xuống).
  - `locked`: nền muted, border, icon route mờ.
  - Caption "Ngày N" + subtitle tên bài.
- **Hàng đợi lộ trình** (`.queue`): header "Hàng đợi lộ trình" + "+ Thêm" + hint "Kéo để sắp xếp…". Mỗi item (`.qitem`): số thứ tự tròn, thumbnail màu 46px, tiêu đề + meta "tác giả · N ngày · ★ rating", icon grip (kéo). **Reorderable** (dùng `ReorderableListView`). Cuối: nút "Hủy lộ trình hiện tại" (ghost, chữ đỏ danger-700).

### 4. Tin nhắn / Chat Tab (list)
- **AppBar**: "Tin nhắn" (display 700, 26px) + icon search + icon edit (soạn).
- **Chat rows**: avatar 52 (chấm online) hoặc icon nhóm (nền purple) cho group; tên + tick; thời gian (phải); dòng last message (đậm + đen khi có unread); badge số unread (nền mint, tròn). Border-bottom mảnh giữa các row. Bấm row → mở thread.

### 5. Chat thread (overlay khi mở 1 hội thoại)
- **Header** (sticky, blur): nút back, avatar 40, tên + tick, status "Đang hoạt động" (primary-600), nút more.
- **Body** (scroll): daystamp "Hôm nay" (pill giữa); **bubble**: `them` = nền trắng + border, bo góc trái dưới nhọn, canh trái; `me` = nền mint, chữ trắng, bo góc phải dưới nhọn, canh phải; có giờ nhỏ. Bubble có thể kèm **roadmap card** (variant chat, max 78% width, canh phải) → bấm mở Roadmap detail.
- **Composer** (cố định đáy): nút + (đính kèm), TextField bo tròn nền muted, nút gửi tròn mint (icon send). Enter để gửi → thêm bubble `me`.

### 6. Cá nhân / Profile Tab
- **Cover** gradient mint 110px (có hoa văn line chéo mờ).
- **Main** (margin-top -42 đè lên cover): avatar 84 viền trắng 4px; tên (display 700, 21px); "@handle · Tham gia tháng 9, 2024".
- **Stats** (3 cột): streak (số + icon flame cam) / người theo dõi / đang theo dõi.
- **Buttons**: "✎ Chỉnh sửa" (primary, flex) + nút settings (ghost vuông).
- **Segmented tabs**: "Lộ trình (2)" / "Bài đăng" / "Đã lưu" (active = chữ primary + gạch chân mint).
- **Grid nội dung**: tab Lộ trình & Đã lưu = list **roadmap card**; tab Bài đăng = card ngang (thumbnail màu 52 + chip tag + tiêu đề + "♥ likes · time").

### Component: Roadmap preview card (`RoadmapCard`)
Dùng lại ở Feed, Chat, Profile, Queue.
- **Banner** 92px: nền màu lộ trình + hoa văn line chéo trắng mờ; góc trái tag (pill nền trắng 92%), góc phải "N ngày" (pill nền đen 32% + blur).
- **Body**: tiêu đề (700, 14.5px) + blurb (12.5px muted) + foot "★ rating · N đánh giá · learners đang học" + hàng tác giả (avatar 22 + tên + tick, border-top mảnh).
- Bấm → mở **Roadmap detail**.

### Overlay: Roadmap detail
Slide-up từ dưới. Banner màu 168px (nút close tròn nền đen 28%, tag). Head trắng: tiêu đề (display 700, 22px), hàng tác giả + nút Theo dõi, **3 ô stat** (★rating/đánh giá, N ngày, learners). Blurb. Section "NỘI DUNG TỪNG NGÀY": list ngày (ô số vuông + tiêu đề + tasks) + "+ N ngày nữa". Ô đánh giá sao (5 sao, 4 sao vàng). 
- **CTA cố định đáy**: nếu đang follow lộ trình khác → hiện **note cảnh báo** (nền warning-50): "Bạn chỉ theo dõi 1 lộ trình tại một thời điểm. Lộ trình này sẽ vào hàng đợi." + nút "Thêm vào hàng đợi" (outline). Nếu chưa follow gì → nút "Theo dõi lộ trình" (primary).

---

## Interactions & Behavior
- **Login** → bất kỳ nút nào → set `loggedIn = true`, hiện app ở tab Feed.
- **Bottom nav**: chuyển 4 tab. Khi mở chat thread thì ẩn bottom nav.
- **Follow gia sư**: toggle local (outline ↔ filled).
- **Like / Save post**: toggle local, đổi màu + đếm.
- **Task hôm nay**: toggle done (vòng tròn tô mint, gạch label).
- **Queue**: kéo-thả đổi thứ tự (`ReorderableListView`).
- **Roadmap card** (bất kỳ đâu) → mở Roadmap detail (slide-up).
- **Roadmap tag trong chat** → cùng mở Roadmap detail (deep-link).
- **Chat**: gõ + Enter/nút gửi → thêm bubble của mình.
- **Strict rule (NGHIỆP VỤ QUAN TRỌNG)**: user chỉ follow **1 lộ trình** tại một thời điểm; lộ trình mới vào **hàng đợi** có sắp thứ tự ưu tiên; xong/hủy lộ trình hiện tại → confirm → lộ trình đầu hàng đợi tự kích hoạt. Streak +1 khi hoàn thành toàn bộ task ngày, đứt về 0 nếu lỡ.
- **Animation**: transition ~120–180ms ease-out (`cubic-bezier(0.2,0.7,0.3,1)`); detail overlay slide-up + fade; live badge pulse 1.4s; nút `active: scale(0.98)`. Tránh bounce.

## State Management
- `loggedIn: bool`
- `currentTab: enum {feed, roadmap, chat, profile}`
- `openChat: Chat?` (đang mở thread nào)
- `detailRoadmap: String?` (id lộ trình đang xem detail)
- Per-component: `following`, `liked`, `saved`, `taskDone`, `queueOrder`, `composerText`, `messages`.
- Data thật: cần API cho feed, roadmaps + syllabus theo ngày (quan hệ 1-N), users/follow, chats/messages, streak/grading, votes. Dựng UI trước với mock trong `lib/data/mock_data.dart`.

## Design Tokens
Map sang `AppColors` / `AppText` / `AppSpacing` / `AppRadius`. (Token gốc đầy đủ trong `tokens.css`.)

**Colors**
- Primary (mint): 50 `#EFF9F4`, 100 `#DDF3E5`, 200 `#CCEDDD`, 300 `#7DD1A7`, 400 `#6FCC9C`, **500 `#5CC691` (MAIN)**, 600 `#418D67` (hover), 700 `#356F52` (pressed), 800 `#255053`
- Purple (tag/nhóm): 50 `#F4EFFE`, 500 `#764FDB`, 700 `#4F2EA3`
- Accent khác: teal `#449297`, orange `#E37E36`, info `#2A6FDB`, danger `#EB5146`/700 `#B83A30`, warning 500 `#E37E36`/700 `#B0860B`/50 `#FFFAE7`
- Neutral: white `#FFFFFF`, bg-page `#F7F7F7`, bg-muted `#F5F5F5`, stroke-soft `#EEEEEE`, stroke `#EAEAEA`, stroke-strong `#E3E8EF`
- Text: fg `#101828`, secondary `#364152`, muted `#697586`, placeholder `#9DA4AE`, disabled `#B0B0B0`

**Typography** — font **Noto Sans** (UI), Inter cho heading nếu cần tương phản (dùng `google_fonts`).
- Display/heading: 700, line-height 1.2–1.5. App title 26px, login brand 30px, roadmap title 21–22px.
- Body: xl 18 / lg 16 / md 14 / sm 12 (line-height 1.5). **Không nhỏ hơn 12px.**
- Label/chip: 14/12/10px, 600–700.

**Spacing** — base 4px: 2,4,6,8,10,12,16,20,24,28,32,40,48,64…

**Radius** — xs 4, sm 6, md 8, lg **12 (button)**, xl **16 (card/modal)**, 2xl 24, pill 999.

**Shadow**
- sm `0 1px 1px rgba(16,24,40,.15)`
- md `0 2px 4px rgba(16,24,40,.08), 0 1px 2px rgba(16,24,40,.06)`
- lg `0 8px 16px rgba(16,24,40,.08), 0 2px 4px rgba(16,24,40,.06)`
- button mint glow: `0 4px 12px rgba(92,198,145,.35)`

## Assets
- Icons: stroke style 1.5–1.75px round-cap (tương đương Vuesax Linear / Lucide). Dùng `flutter_lucide`. Các icon custom: `route` (logo lộ trình), `flame` (streak) — nếu Lucide không khớp, export SVG và dùng `flutter_svg`.
- Avatar: chữ cái viết tắt trên nền màu (không cần ảnh thật).
- **Không emoji** trong UI hệ thống (trừ vài chỗ trong nội dung post mẫu); **không ảnh stock**. Hoa văn banner = line chéo trắng mờ (`repeating-linear-gradient`, trong Flutter dùng `CustomPainter` vẽ line hoặc bỏ qua, nền màu phẳng vẫn ổn).
- Logo gốc: `assets/logo-easycrm.svg` (tham khảo, đây là brand cha EasyCRM — LearnSpace tự xây wordmark bằng icon route + chữ).

## Files (design reference)
- `LearnSpace.html` — entry, ráp toàn bộ
- `app.jsx` — routing tab + state gốc + tweaks
- `data.js` — mock data (users, roadmaps, syllabus, feed, chats…)
- `components/common.jsx` — Icon, Avatar, Verified, RoadmapCard, StatusBar
- `screens/Login.jsx`, `Feed.jsx`, `Roadmap.jsx`, `Chat.jsx`, `Profile.jsx`, `RoadmapDetail.jsx`
- `styles/tokens.css` — **design tokens (nguồn chuẩn)**
- `styles/app.css` — class styling từng component

Mở `LearnSpace.html` trên trình duyệt để xem chính xác look & behavior trước khi dựng Flutter.
