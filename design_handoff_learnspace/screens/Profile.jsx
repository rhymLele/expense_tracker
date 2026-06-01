// LearnSpace — Profile tab
const { useState: useStateProf } = React;

function ProfileScreen({ onOpenRoadmap }) {
  const me = DATA.ME;
  const [tab, setTab] = useStateProf('roadmaps');

  const myPosts = [
    { tag: 'IELTS', color: '#5CC691', title: 'Chia sẻ: cách mình tăng 1.0 band Speaking', time: '3 ngày', likes: 64 },
    { tag: 'Vocab', color: '#2A6FDB', title: '20 collocation chủ đề Environment cực hay', time: '1 tuần', likes: 128 },
  ];

  return (
    <div className="screen">
      <div className="screen__scroll">
        <div className="prof__cover" style={{ backgroundImage: 'linear-gradient(135deg,var(--color-primary-400),var(--color-primary-700)), repeating-linear-gradient(60deg, rgba(255,255,255,0.08) 0 1.5px, transparent 1.5px 26px)' }} />
        <div className="prof__main">
          <Avatar user={me} size={84} />
          <div className="prof__name">{me.name}</div>
          <div className="prof__handle">{me.handle} · Tham gia tháng 9, 2024</div>

          <div className="prof__stats">
            <div className="prof__stat"><span className="prof__statnum" style={{ color: 'var(--color-warning-500)', display: 'flex', alignItems: 'center', gap: 4 }}><Icon name="flame" size={18} fill="var(--color-warning-500)" stroke="var(--color-warning-500)" />{me.streak}</span><span className="prof__statlbl">streak</span></div>
            <div className="prof__stat"><span className="prof__statnum">{me.followers}</span><span className="prof__statlbl">người theo dõi</span></div>
            <div className="prof__stat"><span className="prof__statnum">{me.following}</span><span className="prof__statlbl">đang theo dõi</span></div>
          </div>

          <div className="prof__btns">
            <button className="btn btn--primary" style={{ flex: 1 }}><Icon name="edit" size={16} stroke="#fff" /> Chỉnh sửa</button>
            <button className="btn btn--ghost"><Icon name="settings" size={18} /></button>
          </div>
        </div>

        <div className="segtabs">
          <div className={'segtab' + (tab === 'roadmaps' ? ' active' : '')} onClick={() => setTab('roadmaps')}>Lộ trình ({2})</div>
          <div className={'segtab' + (tab === 'posts' ? ' active' : '')} onClick={() => setTab('posts')}>Bài đăng</div>
          <div className={'segtab' + (tab === 'saved' ? ' active' : '')} onClick={() => setTab('saved')}>Đã lưu</div>
        </div>

        <div className="mygrid">
          {tab === 'roadmaps' && (
            <>
              <RoadmapCard id="r3" onOpen={onOpenRoadmap} />
              <RoadmapCard id="r4" onOpen={onOpenRoadmap} />
            </>
          )}
          {tab === 'posts' && myPosts.map((p, i) => (
            <article key={i} className="card" style={{ padding: 14, display: 'flex', gap: 12, alignItems: 'center' }}>
              <div className="rmcard__banner" style={{ ...rmBanner(p.color), width: 52, height: 52, borderRadius: 10, flexShrink: 0, padding: 0 }} />
              <div style={{ flex: 1, minWidth: 0 }}>
                <span className="task__type" style={{ marginTop: 0 }}>{p.tag}</span>
                <div style={{ fontWeight: 600, fontSize: 14, marginTop: 6, lineHeight: 1.35 }}>{p.title}</div>
                <div style={{ fontSize: 12, color: 'var(--color-fg-muted)', marginTop: 4, display: 'flex', alignItems: 'center', gap: 6 }}>
                  <Icon name="heart" size={13} /> {p.likes} · {p.time}
                </div>
              </div>
            </article>
          ))}
          {tab === 'saved' && (
            <>
              <RoadmapCard id="r2" onOpen={onOpenRoadmap} />
              <RoadmapCard id="r1" onOpen={onOpenRoadmap} />
            </>
          )}
        </div>
      </div>
    </div>
  );
}

window.ProfileScreen = ProfileScreen;
