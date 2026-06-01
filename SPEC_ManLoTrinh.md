# Đặc tả thiết kế — Màn Lộ trình học (Roadmap Screen)

> LearnSpace · tab "Lộ trình". Màn hình học viên theo dõi hành trình học đang diễn ra: streak, nhiệm vụ hôm nay, lộ trình kiểu Duolingo, và hàng đợi lộ trình.
> Mọi giá trị màu/spacing/type bám **EasyCRM Design System** (mint `#5CC691`, Noto Sans). Token `var(--*)` trong tài liệu này đều có thật trong `colors_and_type.css`.

---

## 1. Mục tiêu & ngữ cảnh

| | |
|---|---|
| **Người dùng** | Học viên đang theo 1 lộ trình. |
| **Mục tiêu màn** | (1) Tạo động lực qua streak + tiến độ; (2) Dẫn học viên tới nhiệm vụ hôm nay; (3) Cho thấy hành trình tổng thể; (4) Quản lý các lộ trình xếp hàng. |
| **Nền tảng** | Mobile, dọc. Khung thiết kế 402 × 874 (iPhone). |
| **Tần suất** | Màn vào hằng ngày — ưu tiên "nhiệm vụ hôm nay" nằm trên màn đầu (above the fold). |

### Nguyên tắc nghiệp vụ (ràng buộc thiết kế)
- Học viên chỉ **theo dõi 1 lộ trình** tại một thời điểm. Lộ trình khác nằm trong **hàng đợi** có thứ tự ưu tiên.
- Hoàn thành / hủy lộ trình hiện tại → lộ trình **đầu hàng đợi tự kích hoạt**.
- **Streak** +1 khi hoàn thành toàn bộ nhiệm vụ trong ngày; về 0 nếu lỡ một ngày.

---

## 2. Bố cục tổng thể (anatomy)

Màn là một vùng cuộn dọc duy nhất trên nền `var(--color-bg-page)` (`#F7F7F7`), không có app-bar trắng (Hero tự làm nền đầu màn). Thứ tự khối từ trên xuống:

```
┌─────────────────────────────┐
│  [A] HERO (gradient mint)    │  ← streak + lộ trình đang học + progress
├─────────────────────────────┤
│  [B] NHIỆM VỤ HÔM NAY        │  ← checklist 3 task
│  [C] HÀNH TRÌNH (path dọc)   │  ← node done / today / locked
│  [D] HÀNG ĐỢI LỘ TRÌNH       │  ← list kéo-thả + nút hủy
└─────────────────────────────┘
   (Bottom tab bar — ngoài phạm vi màn này)
   (FAB "+" tạo lộ trình — góc phải dưới)
```

Khoảng cách giữa các section: `var(--space-9)` (24px) hoặc section tự có padding dọc 16–18px.

---

## 3. Chi tiết từng khối

### [A] HERO — Streak + Lộ trình đang học

**Nền**: gradient mint dọc `linear-gradient(150deg, var(--color-primary-500), var(--color-primary-700))` (`#5CC691 → #356F52`). Đây là gradient *chỉ dùng cho hero* — phần còn lại của app theo quy tắc EasyCRM "no gradient". Padding: `58px 20px 22px` (top chừa status bar).

**Hàng 1 — Streak + nút quản lý** (`space-between`):
- *Streak cluster*: icon ngọn lửa 30px màu `#FFD89E` (amber sáng trên nền mint) + số streak (font display, 700, 34px, line-height 1, màu trắng) + nhãn "ngày streak" (12px, opacity 0.9).
- *Nút "⚙ Quản lý"*: nền `rgba(255,255,255,0.18)`, chữ trắng 13px, padding `9px 14px`, radius `var(--radius-lg)`.

**Hàng 2 — Nhãn lộ trình** (margin-top 18):
- Chip "ĐANG HỌC" — nền `rgba(255,255,255,0.2)`, chữ trắng 700, 11px, padding `3px 9px`, radius pill.
- Theo sau: "{chủ đề} · {tên giáo viên}" (12px, opacity 0.9).

**Hàng 3 — Tiêu đề lộ trình**: font display, 700, 21px, line-height 1.25, trắng.

**Hàng 4 — Tiến độ**:
- Dòng meta (`space-between`, 12.5px, opacity 0.95): trái "Ngày X / Y", phải "Z% hoàn thành".
- Thanh progress: cao 8px, radius pill, track `rgba(255,255,255,0.28)`, fill trắng đặc, width = Z%.

> **Lý do màu**: hero là điểm cảm xúc duy nhất của màn → dùng brand green đậm. Tất cả khối dưới quay về nền trung tính để giữ tinh thần "calm, dense" của EasyCRM.

---

### [B] NHIỆM VỤ HÔM NAY

Khối trên nền page, padding `18px 16px 8px`.

**Header** (`space-between`):
- Tiêu đề "Nhiệm vụ hôm nay" — 16px, 700, `var(--color-fg)`.
- Đếm "1/3 hoàn thành" — 12.5px, 600, `var(--color-fg-muted)`.

**Task item** (card):
- Surface: nền trắng, `1px solid var(--color-stroke)`, radius `var(--radius-lg)` (12px), padding 14px, gap 12px, margin-bottom 10px. **Không shadow** (theo EasyCRM — card dựa vào stroke).
- *Checkbox tròn*: 26px, `2px solid var(--color-stroke-strong)`. Khi xong → nền `var(--color-primary-500)`, border mint, tick trắng 2.5px.
- *Nội dung*: label 14px, 500. Khi xong → `var(--color-fg-muted)` + gạch ngang.
- *Chip loại*: 11px, 700, chữ `var(--color-primary-600)`, nền `var(--color-primary-50)`, padding `2px 8px`, radius pill. Giá trị: "Phát âm" / "Speaking" / "Writing" / "Nghe" / "Từ vựng" / "Ngữ pháp".
- *Chevron* phải: 16px, `var(--color-fg-placeholder)`.

**Hành vi**: tap toàn item → toggle hoàn thành (lạc quan, cập nhật ngay). Khi đủ 3/3 → cập nhật progress hero + sẵn sàng +1 streak.

---

### [C] HÀNH TRÌNH (path dọc kiểu Duolingo)

Khối căn giữa, padding `10px 16px 6px`. Tiêu đề khối "Hành trình của bạn" canh trái (16px, 700).

Các **node** xếp dọc, nối bằng đường thẳng đứng giữa các node.

**Node — 3 trạng thái:**

| Trạng thái | Vòng tròn 58px | Đặc điểm |
|---|---|---|
| **done** | nền `var(--color-primary-500)`, tick trắng | shadow đáy đặc `0 5px 0 var(--color-primary-700)` (hiệu ứng "nút nổi" 3D) |
| **today** | nền trắng, `3px solid var(--color-primary-500)`, số ngày màu `primary-600` | shadow mint mềm `0 5px 14px rgba(92,198,145,0.4)`; có pill **"BẮT ĐẦU"** phía trên (nền `primary-600`, chữ trắng 10px 700, mũi tên tam giác chỉ xuống) |
| **locked** | nền `var(--color-bg-muted)`, icon route mờ | `2px solid var(--color-stroke)`, chữ `var(--color-fg-placeholder)` |

- **Caption** dưới node: "Ngày N" (12px, 600) + subtitle tên bài (11px, `var(--color-fg-muted)`).
- **Đường nối**: rộng 3px, cao 26px. Đoạn đã qua (giữa 2 node done) màu `var(--color-primary-300)`; đoạn chưa tới màu `var(--color-stroke)`.

**Hành vi**: tap node `today` → mở nhiệm vụ ngày đó. Node `locked` không bấm được (hoặc hiện tooltip "Hoàn thành ngày trước để mở khoá").

---

### [D] HÀNG ĐỢI LỘ TRÌNH

Khối trên nền page, padding `14px 16px 24px`.

**Header** (`space-between`):
- "Hàng đợi lộ trình" — 16px, 700.
- Link "+ Tạo lộ trình" — 13px, 600, `var(--color-primary-600)` → mở màn Tạo lộ trình.

**Hint** (11.5px, `var(--color-fg-muted)`): "Kéo để sắp xếp thứ tự — lộ trình kế tiếp sẽ tự kích hoạt khi bạn hoàn thành."

**Queue item** (card, kéo-thả được):
- Surface: nền trắng, `1px solid var(--color-stroke)`, radius `var(--radius-lg)`, padding 12px, gap 12px.
- *Số thứ tự*: tròn 24px, nền `var(--color-bg-muted)`, chữ `var(--color-fg-muted)` 700 12px.
- *Thumbnail*: 46px, radius 10px, nền màu lộ trình + hoa văn line chéo mờ (theo "cover wave linework" của EasyCRM).
- *Nội dung*: tiêu đề 13.5px 600; meta "tác giả · N ngày · ★ rating" 11.5px `var(--color-fg-muted)`.
- *Tay cầm kéo* (grip 6 chấm): `var(--color-fg-placeholder)`, cursor grab.
- *State khi kéo*: item đang kéo `opacity 0.5`; item bị kéo qua → border `dashed var(--color-primary-500)`.

**Nút "Hủy lộ trình hiện tại"**: ghost full-width, nền `var(--color-bg-muted)`, chữ `var(--color-danger-700)`. Tap → mở confirm dialog (vì kích hoạt lộ trình đầu hàng đợi).

---

## 4. Bảng token áp dụng

| Vai trò | Token | Giá trị |
|---|---|---|
| Brand / progress fill / check | `--color-primary-500` | `#5CC691` |
| Hero gradient cuối | `--color-primary-700` | `#356F52` |
| Shadow nút node done | `--color-primary-700` | `#356F52` |
| Chip loại nền | `--color-primary-50` | `#EFF9F4` |
| Chip loại chữ | `--color-primary-600` | `#418D67` |
| Đường nối đã qua | `--color-primary-300` | `#7DD1A7` |
| Nền màn | `--color-bg-page` | `#F7F7F7` |
| Nền chip STT / thumbnail nền phụ | `--color-bg-muted` | `#F5F5F5` |
| Stroke card | `--color-stroke` | `#EAEAEA` |
| Stroke checkbox | `--color-stroke-strong` | `#E3E8EF` |
| Text chính | `--color-fg` | `#101828` |
| Text phụ | `--color-fg-muted` | `#697586` |
| Placeholder / grip | `--color-fg-placeholder` | `#9DA4AE` |
| Nút hủy (nguy hiểm) | `--color-danger-700` | `#B83A30` |
| Radius card / nút node | `--radius-lg` | 12px |
| Radius chip/pill | `--radius-pill` | 999px |
| Font số streak / tiêu đề | `--font-display` | Noto Sans / Inter |
| Font UI | `--font-sans` | Noto Sans |

**Type ramp dùng trong màn**: số streak 34px/700; tiêu đề lộ trình 21px/700; tiêu đề khối 16px/700; label task 14px/500; meta & chip 11–12.5px. **Không nhỏ hơn 12px** cho nội dung (theo EasyCRM).

---

## 5. Trạng thái & tương tác

| Sự kiện | Phản hồi |
|---|---|
| Tap task hôm nay | Toggle done (lạc quan); checkbox tô mint + gạch label; cập nhật đếm "x/3" + progress hero. |
| Hoàn thành đủ task ngày | +1 streak; node `today` chuyển `done`; node kế mở khoá thành `today`. |
| Tap node `today` | Mở chi tiết/nhiệm vụ ngày. |
| Tap node `locked` | Không hành động (hoặc tooltip khoá). |
| Kéo item hàng đợi | Đổi thứ tự ưu tiên; lưu lại. |
| "Hủy lộ trình hiện tại" | Confirm dialog → lộ trình đầu hàng đợi tự kích hoạt. |
| "+ Tạo lộ trình" / FAB | Mở màn Tạo lộ trình. |

**Animation** (theo EasyCRM — dè dặt, không bounce):
- Micro-fade hover/press ~120ms (`var(--dur-fast)` + `var(--ease-out)`).
- Checkbox tô màu: transition `all 120ms ease-out`.
- Tuyệt đối **không** dùng card-lift, scale lớn, hay bounce. Chỉ `active: scale(0.98)` nhẹ cho nút bấm.

**Empty state** (chưa theo lộ trình nào): ẩn Hero progress; hiện minh hoạ + CTA "Khám phá lộ trình" dẫn về tab Trang chủ.

---

## 6. Accessibility & chất lượng
- Vùng chạm tối thiểu **44×44px** (checkbox 26px nhưng vùng tap là cả card).
- Tương phản: chữ trắng trên mint `#5CC691` đạt AA cho text ≥ 14px/600; nhãn nhỏ trên hero dùng opacity ≥ 0.9.
- Mọi icon là SVG stroke 1.5–1.75px (Vuesax Linear / Lucide), monochrome, kế thừa màu chữ.
- **Không emoji, không exclamation** (trừ ngọn lửa streak là icon SVG, không phải emoji).
- Ngôn ngữ Việt, giọng vận hành, sentence-case.

---

## 7. Tham chiếu
- Prototype tương tác: `LearnSpace.html` → tab "Lộ trình".
- Token gốc: `styles/tokens.css` (copy từ EasyCRM `colors_and_type.css`).
- Màn liên quan: **Tạo lộ trình** (`ROADMAP_SCREENS.md` mục 2) — mở từ link "+ Tạo lộ trình" và FAB.
