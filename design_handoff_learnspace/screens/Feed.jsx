// LearnSpace — Feed / Home tab
const { useState: useStateFeed } = React;

function TeacherCard({ id }) {
  const u = DATA.USERS[id];
  const [following, setFollowing] = useStateFeed(false);
  return (
    <div className="tcard">
      <Avatar user={u} size={56} ring />
      <div className="tcard__name">{u.name}{u.verified && <Verified size={13} />}</div>
      <div className="tcard__role">{u.role}</div>
      <div className="tcard__followers">{u.followers} người theo dõi</div>
      <button className={'followbtn' + (following ? ' following' : '')} onClick={() => setFollowing(f => !f)}>
        {following ? <><Icon name="check" size={14} sw={2.2} /> Đang theo dõi</> : <><Icon name="plus" size={14} sw={2.2} /> Theo dõi</>}
      </button>
    </div>
  );
}

function Post({ post, onOpenRoadmap }) {
  const u = DATA.USERS[post.user];
  const [liked, setLiked] = useStateFeed(post.liked);
  const [saved, setSaved] = useStateFeed(false);
  const likeCount = post.likes + (liked && !post.liked ? 1 : 0) - (!liked && post.liked ? 1 : 0);

  const imgBg = {
    accent: 'linear-gradient(135deg,#2A6FDB,#1F4FA6)',
    streak: 'linear-gradient(135deg,#E37E36,#EB5146)',
  }[post.image];

  return (
    <article className="card post">
      <header className="post__head">
        <Avatar user={u} size={44} online />
        <div className="post__meta">
          <div className="post__name">{u.name}{u.verified && <Verified size={13} />}</div>
          <div className="post__sub">{u.role} · {post.time}</div>
        </div>
        <button className="iconbtn" style={{ width: 34, height: 34, background: 'transparent' }} aria-label="more">
          <Icon name="chevron" size={18} style={{ transform: 'rotate(90deg)' }} stroke="#9DA4AE" />
        </button>
      </header>

      <p className="post__text">{post.text}</p>

      {post.image && (
        <div className="post__img" style={{ background: imgBg }}>
          {post.image === 'accent' && (
            <div style={{ position: 'absolute', inset: 0, display: 'grid', placeItems: 'center' }}>
              <div style={{ width: 60, height: 60, borderRadius: 99, background: 'rgba(255,255,255,0.22)', display: 'grid', placeItems: 'center', backdropFilter: 'blur(4px)' }}>
                <Icon name="play" size={28} stroke="#fff" />
              </div>
            </div>
          )}
          {post.image === 'streak' && (
            <div style={{ position: 'absolute', inset: 0, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', color: '#fff', gap: 4 }}>
              <Icon name="flame" size={52} fill="rgba(255,255,255,0.95)" stroke="rgba(255,255,255,0.95)" />
              <div style={{ fontFamily: 'var(--font-display)', fontWeight: 800, fontSize: 40, lineHeight: 1 }}>7</div>
              <div style={{ fontSize: 13, fontWeight: 600, opacity: 0.95 }}>ngày streak</div>
            </div>
          )}
        </div>
      )}

      {post.roadmap && <RoadmapCard id={post.roadmap} onOpen={onOpenRoadmap} />}

      <footer className="post__actions">
        <button className={'post__act' + (liked ? ' liked' : '')} onClick={() => setLiked(l => !l)}>
          <Icon name="heart" size={20} fill={liked ? 'currentColor' : 'none'} /> {likeCount}
        </button>
        <button className="post__act"><Icon name="comment" size={20} /> {post.comments}</button>
        <button className="post__act"><Icon name="share" size={19} /></button>
        <button className="post__act" style={{ marginLeft: 'auto', color: saved ? 'var(--color-primary-600)' : undefined }} onClick={() => setSaved(s => !s)}>
          <Icon name="bookmark" size={19} fill={saved ? 'currentColor' : 'none'} />
        </button>
      </footer>
    </article>
  );
}

function FeedScreen({ onOpenRoadmap, showLive = true }) {
  return (
    <div className="screen">
      <header className="appbar">
        <div className="appbar__wordmark">
          <div className="appbar__logo"><Icon name="route" size={18} stroke="#fff" sw={2} /></div>
          <span className="appbar__title">LearnSpace</span>
        </div>
        <div className="appbar__actions">
          <button className="iconbtn" aria-label="tìm kiếm"><Icon name="search" size={20} /></button>
          <button className="iconbtn" aria-label="thông báo"><Icon name="bell" size={20} /><span className="iconbtn__dot" /></button>
        </div>
      </header>

      <div className="screen__scroll">
        {/* Live banner */}
        {showLive && <div className="livecard">
          <Avatar user="linh" size={44} ring />
          <div style={{ flex: 1, minWidth: 0 }}>
            <span className="livecard__badge"><span className="livecard__pulse" /> LIVE</span>
            <div style={{ fontWeight: 600, fontSize: 14, marginTop: 6 }}>Cô Linh Trang đang livestream</div>
            <div style={{ fontSize: 12, opacity: 0.8 }}>Sửa lỗi phát âm cho người đi làm · 312 đang xem</div>
          </div>
          <button className="btn" style={{ background: 'rgba(255,255,255,0.16)', color: '#fff', padding: '9px 16px', fontSize: 13 }}>Vào xem</button>
        </div>}

        {/* Discover teachers */}
        <section className="discover">
          <div className="discover__head">
            <span className="discover__title">Gia sư gợi ý cho bạn</span>
            <span className="discover__link">Bản đồ gia sư</span>
          </div>
          <div className="rail">
            {['maianh', 'david', 'linh', 'hung'].map(id => <TeacherCard key={id} id={id} />)}
          </div>
        </section>

        <div className="seclabel">Bảng tin</div>
        <div className="feed">
          {DATA.FEED.map(p => <Post key={p.id} post={p} onOpenRoadmap={onOpenRoadmap} />)}
        </div>
      </div>
    </div>
  );
}

window.FeedScreen = FeedScreen;
