// LearnSpace — Roadmap detail overlay (deep-link target from feed/chat)
const { useState: useStateDetail } = React;

function RoadmapDetail({ id, onClose }) {
  const r = DATA.ROADMAPS[id];
  const a = DATA.USERS[r.author];
  const [following, setFollowing] = useStateDetail(id === 'r1');

  const syllabus = [
    { day: 1, title: 'Làm quen & đánh giá đầu vào', tasks: 'Test trình độ · Đặt mục tiêu' },
    { day: 2, title: 'Part 1 — Câu hỏi thường gặp', tasks: 'Phát âm 8 từ · Ghi âm 60s' },
    { day: 3, title: 'Mở rộng câu trả lời', tasks: 'Học 5 cấu trúc · Viết 120 từ' },
    { day: 4, title: 'Part 2 — Cue card cơ bản', tasks: 'Ghi âm 90s · Tự chấm' },
    { day: 5, title: 'Nối âm & ngữ điệu', tasks: 'Nhại 10 cụm · Shadowing' },
  ];

  return (
    <div className="detail">
      <div className="detail__banner" style={rmBanner(r.color)}>
        <button className="detail__close" onClick={onClose} aria-label="đóng"><Icon name="back" size={22} stroke="#fff" /></button>
        <span className="rmcard__tag" style={{ position: 'static', alignSelf: 'flex-start' }}>{r.tag}</span>
      </div>
      <div className="screen__scroll" style={{ background: 'var(--color-bg-page)' }}>
        <div className="detail__head">
          <h2 className="detail__title">{r.title}</h2>
          <div className="detail__author">
            <Avatar user={a} size={36} />
            <div>
              <div style={{ fontWeight: 600, fontSize: 14, display: 'flex', alignItems: 'center', gap: 4 }}>{a.name}{a.verified && <Verified size={13} />}</div>
              <div style={{ fontSize: 12, color: 'var(--color-fg-muted)' }}>{a.role}</div>
            </div>
            <button className="followbtn" style={{ width: 'auto', padding: '8px 16px', marginLeft: 'auto' }}>Theo dõi</button>
          </div>

          <div className="detail__stats">
            <div className="detail__stat"><span className="rmcard__star" style={{ fontSize: 16 }}><Icon name="star" size={16} /> {r.rating}</span><span>{r.votes} đánh giá</span></div>
            <div className="detail__stat"><b>{r.days}</b><span>ngày</span></div>
            <div className="detail__stat"><b>{r.learners}</b><span>đang học</span></div>
          </div>

          <p className="post__text" style={{ margin: '16px 0 0' }}>{r.blurb} Lộ trình được phân rã chi tiết theo từng ngày, có chấm điểm và phản hồi chuyên môn cho từng bài nộp.</p>
        </div>

        <div className="seclabel">Nội dung từng ngày</div>
        <div style={{ padding: '0 16px 8px' }}>
          {syllabus.map(d => (
            <div key={d.day} className="task" style={{ cursor: 'default' }}>
              <div className="task__check" style={{ borderRadius: 10, borderColor: 'var(--color-stroke)', fontWeight: 700, color: 'var(--color-fg-muted)', fontSize: 12 }}>{d.day}</div>
              <div className="task__body">
                <div className="task__label" style={{ fontWeight: 600 }}>{d.title}</div>
                <div style={{ fontSize: 12, color: 'var(--color-fg-muted)', marginTop: 3 }}>{d.tasks}</div>
              </div>
            </div>
          ))}
          <div style={{ textAlign: 'center', fontSize: 13, color: 'var(--color-fg-muted)', padding: '6px 0 16px' }}>+ {r.days - 5} ngày nữa</div>
        </div>

        <div className="detail__rate">
          <span style={{ fontSize: 13, fontWeight: 600 }}>Đánh giá lộ trình</span>
          <div style={{ display: 'flex', gap: 6, marginTop: 8 }}>
            {[1,2,3,4,5].map(s => <Icon key={s} name="star" size={26} stroke="var(--color-warning-500)" style={{ color: s <= 4 ? 'var(--color-warning-500)' : 'var(--color-stroke-strong)' }} />)}
          </div>
        </div>
      </div>

      <div className="detail__cta">
        {following && <div className="detail__note"><Icon name="route" size={14} stroke="var(--color-warning-700)" /> Bạn chỉ theo dõi 1 lộ trình tại một thời điểm. Lộ trình này sẽ vào hàng đợi.</div>}
        <button className={'btn btn--lg btn--block ' + (following ? 'btn--outline' : 'btn--primary')} onClick={() => setFollowing(f => !f)}>
          {following ? 'Thêm vào hàng đợi' : 'Theo dõi lộ trình'}
        </button>
      </div>
    </div>
  );
}

window.RoadmapDetail = RoadmapDetail;
