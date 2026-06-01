# Màn Lộ trình & Tạo lộ trình — Spec + Flutter

Tài liệu này chỉ tập trung **2 màn**:
1. **Màn Lộ trình** (Roadmap tab) — học viên xem hành trình đang học.
2. **Màn Tạo lộ trình** (Roadmap Creation Studio) — giáo viên/creator dựng lộ trình.

Tham chiếu trực quan: mở `LearnSpace.html` (prototype) — tab "Lộ trình" + nút **+** nổi để vào màn tạo.
Code Flutter: `flutter/lib/roadmap_creation/` (xem `flutter/README.md` cho cấu trúc đầy đủ).

---

## 1. MÀN LỘ TRÌNH (Roadmap Tab)

Màn học viên theo dõi lộ trình đang học. Là một `ListView`/`CustomScrollView` dọc, nền `#F7F7F7`.

### 1.1 Hero — streak + tiến độ
- Nền **gradient mint dọc** (`#5CC691` → `#356F52`), padding-top 58 (chừa status bar).
- Hàng trên: **streak** = icon ngọn lửa (`#FFD89E`) + số ngày (display 700, 34px) + "ngày streak"; bên phải nút "⚙ Quản lý" (nền trắng 18%).
- Badge "ĐANG HỌC" + "{chủ đề} · {tên giáo viên}".
- Tiêu đề lộ trình (display 700, 21px, trắng).
- Tiến độ: "Ngày X / Y" ↔ "Z% hoàn thành" + thanh progress (nền trắng 28%, fill trắng).

### 1.2 Nhiệm vụ hôm nay
- Header "Nhiệm vụ hôm nay" + đếm "1/3 hoàn thành".
- Mỗi **task** (card radius 12, border): vòng tròn check 26px (tô mint + tick trắng khi xong; gạch ngang label khi xong) + label + chip loại (Phát âm / Speaking / Writing — nền `primary-50`, chữ `primary-600`) + chevron.
- Bấm để toggle hoàn thành.

### 1.3 Hành trình (path dọc kiểu Duolingo)
Các node canh giữa, nối bằng đường 3px:
- **done**: tròn 58px nền mint, tick trắng, shadow đáy `primary-700` (hiệu ứng nổi 3D `0 5px 0`).
- **today**: nền trắng, viền mint 3px, shadow mint; có pill "BẮT ĐẦU" phía trên (mũi tên xuống).
- **locked**: nền muted, viền, icon route mờ.
- Caption "Ngày N" + subtitle tên bài.

### 1.4 Hàng đợi lộ trình (Queue)
- Header "Hàng đợi lộ trình" + link "+ Tạo lộ trình" → mở **Màn Tạo lộ trình**.
- Hint: "Kéo để sắp xếp thứ tự — lộ trình kế tiếp tự kích hoạt khi bạn hoàn thành."
- Mỗi item: số thứ tự, thumbnail màu, tiêu đề + meta "tác giả · N ngày · ★ rating", icon kéo → **`ReorderableListView`**.
- Cuối: nút "Hủy lộ trình hiện tại" (ghost, chữ đỏ `danger-700`).

### 1.5 Nghiệp vụ QUAN TRỌNG
- Học viên chỉ **follow 1 lộ trình** tại một thời điểm. Lộ trình mới vào **hàng đợi** có thứ tự ưu tiên.
- Hoàn thành/hủy lộ trình hiện tại → confirm → lộ trình đầu hàng đợi **tự kích hoạt**.
- **Streak** +1 khi hoàn thành toàn bộ task trong ngày; đứt về 0 nếu lỡ ngày.

### 1.6 Map sang Flutter
| Phần | Widget |
|---|---|
| Hero gradient | `Container(decoration: BoxDecoration(gradient: LinearGradient(...)))` |
| Thanh tiến độ | `LinearProgressIndicator` hoặc `FractionallySizedBox` |
| Task hôm nay | `StatefulWidget` toggle, hoặc state qua Bloc |
| Path node | `Column` + `CustomPaint`/`Container` cho đường nối; shadow `0 5px 0` = `BoxShadow(offset: Offset(0,5), blurRadius: 0)` |
| Queue kéo-thả | `ReorderableListView.builder` |

---

## 2. MÀN TẠO LỘ TRÌNH (Roadmap Creation Studio)

Overlay/route full-screen cho creator. Form cuộn dài (3 section), dùng **Slivers** để mượt 60 FPS. Code: `flutter/lib/roadmap_creation/roadmap_creation_page.dart`.

### Header
Nút back · tiêu đề "Tạo lộ trình" (giữa) · nút "Đăng" (phải, disable khi chưa hợp lệ).

### SECTION 1 — Thông tin chung (`metadata_section.dart`)
- **Tên lộ trình** (TextField, đếm ký tự, tối đa 70).
- **Mô tả ngắn** (textarea 3–5 dòng).
- **Tổng số ngày** (number picker 1–90: stepper − / dropdown / +).
- ⚙️ Đổi *Tổng số ngày* → **tự sinh/co Day slots** bên dưới, giữ nguyên nội dung các ngày còn sống.

### SECTION 2 — Cấu trúc từng ngày (`day_expansion_tile.dart`)
- Danh sách **`ExpansionTile`** dọc, mỗi ngày 1 tile (Ngày 1 mở sẵn).
- Trong mỗi ngày: badge "N{số}", field **tiêu đề ngày** (VD "Grammar Masterclass"), danh sách task đã thêm, nút **"+ Thêm bài tập"**.
- Mỗi task hiển thị: tiêu đề + chip loại + **badge cách chấm** + nhãn "Bắt buộc" (nếu có) + nút xoá.
- Mỗi tile bọc `RepaintBoundary`; render qua `SliverList.builder`; mỗi tile là 1 `BlocSelector` → thêm task ngày này **không** rebuild ngày khác.

### SECTION 3 — Task Factory (BottomSheet) (`task_factory_sheet.dart`)
Bấm "+ Thêm bài tập" → mở `showModalBottomSheet(isScrollControlled: true)`:
1. **Loại bài tập** (SegmentedControl): Trắc nghiệm / Viết luận / Ghi âm.
2. **Field động theo loại**:
   - Trắc nghiệm → danh sách đáp án + radio chọn đáp án đúng + thêm/xoá đáp án.
   - Viết luận → ô đề bài.
   - Ghi âm → ô kịch bản/câu mẫu (tuỳ chọn).
3. **Phương thức chấm điểm** (CRITICAL — segmented 3 lựa chọn):
   - 🤖 **AI chấm** — badge **tím/neon** (`#764FDB`), có glow; hiện placeholder **Lottie** khi chọn.
   - 👨‍🏫 **Giáo viên chấm** — badge **cam ấm** (`#E37E36`).
   - ⚙️ **Tự động** — badge slate (cho trắc nghiệm tự chấm).
4. Switch **"Bài tập bắt buộc"**.
5. Nút "Thêm vào ngày" → trả về `TaskModel`.

### Footer — Publish bar (`publish_bar.dart`)
- Chỉ báo auto-save ("Đang lưu…" / "Đã lưu nháp") — **debounce 300ms**.
- Nút **"Đăng lộ trình"**: chỉ bật khi **Ngày 1 có ≥ 1 bài tập bắt buộc** + đã nhập tên.
- Publish khi chưa hợp lệ → hiện **badge lỗi validation** (nền `danger-50`), nút giữ disable.

### State (BLoC — `bloc/`)
| Event | Tác dụng |
|---|---|
| `RoadmapInitialized` | Form rỗng / nạp nháp đã lưu |
| `RoadmapMetadataChanged` | Cập nhật tên/mô tả/tổng ngày → sinh Day slots |
| `DayTitleChanged` | Đổi tiêu đề 1 ngày |
| `TaskAddedToDay(dayIndex, task)` | Thêm task vào 1 ngày (rebuild riêng tile đó) |
| `TaskRemovedFromDay` | Xoá task |
| `_DraftPersistRequested` | (nội bộ, debounce 300ms) lưu nháp local |
| `RoadmapPublishRequested` | Validate → publish; nếu fail bật cờ lỗi |

Rule publish nằm ở `RoadmapDraft.isPublishable` / `validationMessage`.

### Cần nối vào hệ thống thật
1. `RoadmapDraftStore` → cài bản lưu local thật (Hive/Isar/SharedPreferences) thay `InMemoryDraftStore`.
2. `RoadmapBloc._onPublishRequested` → gọi `repository.publish(state.draft)` (hiện để TODO + delay giả).
3. AI-graded → thêm package `lottie` + asset `ai_spark.json` vào chỗ `_LottiePlaceholder`.

---

## Tokens dùng chung (cả 2 màn)
- Mint `#5CC691` (primary), hover `#418D67`, pressed `#356F52`, disabled `#7DD1A7`, tint `#EFF9F4`.
- AI tím `#764FDB` / bg `#F4EFFE`; Teacher cam `#E37E36` / bg `#FFFAE7`; danger `#EB5146` / bg `#FFEBEA`.
- Text `#101828` / secondary `#364152` / muted `#697586`; stroke `#E3E8EF` / soft `#EAEAEA`; nền `#F7F7F7`.
- Font **Noto Sans**. Spacing base 4 (small 8 / medium 16 / large 24). Radius button 12, card/modal 16, pill 999.
