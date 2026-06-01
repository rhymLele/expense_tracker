// LearnSpace — shared components & icons (stroke style, 1.75px round caps)
const { useState } = React;

function Icon({ name, size = 22, stroke = 'currentColor', sw = 1.75, fill = 'none', style }) {
  const p = {
    fill, stroke, strokeWidth: sw, strokeLinecap: 'round', strokeLinejoin: 'round',
  };
  const paths = {
    home: <><path {...p} d="M3 10.5 12 3l9 7.5"/><path {...p} d="M5 9.5V20a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V9.5"/><path {...p} d="M9.5 21v-6h5v6"/></>,
    route: <><circle {...p} cx="6" cy="6" r="2.5"/><circle {...p} cx="18" cy="18" r="2.5"/><path {...p} d="M8.5 6H14a3.5 3.5 0 0 1 0 7H10a3.5 3.5 0 0 0 0 7h5"/></>,
    chat: <><path {...p} d="M21 11.5a8.5 8.5 0 0 1-12.4 7.6L3 21l1.9-5.6A8.5 8.5 0 1 1 21 11.5Z"/></>,
    user: <><circle {...p} cx="12" cy="8" r="4"/><path {...p} d="M4 20c0-3.3 3.6-6 8-6s8 2.7 8 6"/></>,
    bell: <><path {...p} d="M18 8a6 6 0 1 0-12 0c0 7-3 9-3 9h18s-3-2-3-9"/><path {...p} d="M13.7 21a2 2 0 0 1-3.4 0"/></>,
    search: <><circle {...p} cx="11" cy="11" r="7"/><path {...p} d="m21 21-4-4"/></>,
    heart: <><path {...p} d="M12 20s-7-4.3-9.3-9.2C1.1 7.5 3 4.5 6.2 4.5c2 0 3.2 1.1 3.8 2.2.6-1.1 1.8-2.2 3.8-2.2 3.2 0 5.1 3 3.5 6.3C19 15.7 12 20 12 20Z"/></>,
    comment: <><path {...p} d="M21 11.5a8.5 8.5 0 0 1-12.4 7.6L3 21l1.9-5.6A8.5 8.5 0 1 1 21 11.5Z"/></>,
    share: <><path {...p} d="M4 12v7a1 1 0 0 0 1 1h14a1 1 0 0 0 1-1v-7"/><path {...p} d="M16 6l-4-4-4 4"/><path {...p} d="M12 2v13"/></>,
    bookmark: <><path {...p} d="M6 3h12a1 1 0 0 1 1 1v17l-7-4-7 4V4a1 1 0 0 1 1-1Z"/></>,
    plus: <><path {...p} d="M12 5v14M5 12h14"/></>,
    check: <><path {...p} d="m5 12 5 5L19 7"/></>,
    star: <><path {...p} fill={fill === 'none' ? 'currentColor' : fill} stroke="none" d="m12 3 2.6 5.3 5.9.9-4.3 4.1 1 5.8L12 16.5 6.8 19.2l1-5.8L3.5 9.2l5.9-.9L12 3Z"/></>,
    users: <><circle {...p} cx="9" cy="8" r="3.5"/><path {...p} d="M3 20c0-3 2.7-5 6-5s6 2 6 5"/><path {...p} d="M16 5a3.5 3.5 0 0 1 0 6.5"/><path {...p} d="M17.5 15c2.3.5 3.5 2.2 3.5 5"/></>,
    flame: <><path {...p} d="M12 3c.5 3-1.5 4.5-3 6.5-1.2 1.6-2 3.2-2 5a5 5 0 0 0 10 0c0-1.5-.6-2.8-1.4-3.8-.4 1-.9 1.5-1.6 1.8.6-2.5-.5-5.4-2-9.5Z"/></>,
    chevron: <><path {...p} d="m9 6 6 6-6 6"/></>,
    back: <><path {...p} d="m15 6-6 6 6 6"/></>,
    send: <><path {...p} d="M22 2 11 13"/><path {...p} d="M22 2 15 22l-4-9-9-4 20-7Z"/></>,
    grip: <><circle cx="9" cy="6" r="1.5" fill="currentColor" stroke="none"/><circle cx="9" cy="12" r="1.5" fill="currentColor" stroke="none"/><circle cx="9" cy="18" r="1.5" fill="currentColor" stroke="none"/><circle cx="15" cy="6" r="1.5" fill="currentColor" stroke="none"/><circle cx="15" cy="12" r="1.5" fill="currentColor" stroke="none"/><circle cx="15" cy="18" r="1.5" fill="currentColor" stroke="none"/></>,
    play: <><path {...p} fill="currentColor" stroke="none" d="M7 4.5v15l13-7.5z"/></>,
    map: <><path {...p} d="M9 4 3 6v14l6-2 6 2 6-2V4l-6 2-6-2Z"/><path {...p} d="M9 4v14M15 6v14"/></>,
    settings: <><circle {...p} cx="12" cy="12" r="3"/><path {...p} d="M19.4 15a1.6 1.6 0 0 0 .3 1.8l.1.1a2 2 0 1 1-2.8 2.8l-.1-.1a1.6 1.6 0 0 0-2.7 1.1V21a2 2 0 1 1-4 0v-.1A1.6 1.6 0 0 0 7 19.4a1.6 1.6 0 0 0-1.8.3l-.1.1a2 2 0 1 1-2.8-2.8l.1-.1a1.6 1.6 0 0 0-1.1-2.7H1a2 2 0 1 1 0-4h.1A1.6 1.6 0 0 0 2.6 7a1.6 1.6 0 0 0-.3-1.8l-.1-.1a2 2 0 1 1 2.8-2.8l.1.1a1.6 1.6 0 0 0 1.8.3H7a1.6 1.6 0 0 0 1-1.5V1a2 2 0 1 1 4 0v.1a1.6 1.6 0 0 0 2.7 1.1 1.6 1.6 0 0 0 1.8-.3l.1-.1a2 2 0 1 1 2.8 2.8l-.1.1a1.6 1.6 0 0 0-.3 1.8V7a1.6 1.6 0 0 0 1.5 1H23a2 2 0 1 1 0 4h-.1a1.6 1.6 0 0 0-1.5 1Z"/></>,
    eye: <><path {...p} d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7-10-7-10-7Z"/><circle {...p} cx="12" cy="12" r="3"/></>,
    edit: <><path {...p} d="M12 20h9"/><path {...p} d="M16.5 3.5a2.1 2.1 0 0 1 3 3L7 19l-4 1 1-4 12.5-12.5Z"/></>,
    google: <g><path d="M21.6 12.2c0-.6-.1-1.3-.2-1.9H12v3.6h5.4a4.6 4.6 0 0 1-2 3v2.5h3.2c1.9-1.7 3-4.3 3-7.2Z" fill="#4285F4"/><path d="M12 22c2.7 0 5-.9 6.6-2.4l-3.2-2.5c-.9.6-2 1-3.4 1-2.6 0-4.8-1.7-5.6-4.1H3.1v2.6A10 10 0 0 0 12 22Z" fill="#34A853"/><path d="M6.4 14c-.2-.6-.3-1.3-.3-2s.1-1.4.3-2V7.4H3.1A10 10 0 0 0 2 12c0 1.6.4 3.2 1.1 4.6L6.4 14Z" fill="#FBBC05"/><path d="M12 5.9c1.5 0 2.8.5 3.8 1.5l2.8-2.8A10 10 0 0 0 12 2a10 10 0 0 0-8.9 5.4L6.4 10c.8-2.4 3-4.1 5.6-4.1Z" fill="#EA4335"/></g>,
    apple: <><path fill="currentColor" stroke="none" d="M16 13c0-2.3 1.9-3.4 2-3.5-1.1-1.6-2.8-1.8-3.4-1.9-1.4-.1-2.8.9-3.5.9-.7 0-1.8-.8-3-.8-1.5 0-3 .9-3.7 2.3-1.6 2.8-.4 6.9 1.1 9.2.8 1.1 1.6 2.3 2.8 2.3 1.1 0 1.5-.7 2.9-.7 1.3 0 1.7.7 2.9.7 1.2 0 2-1.1 2.7-2.2.9-1.3 1.2-2.5 1.3-2.6-.1 0-2.4-.9-2.4-3.7ZM13.8 6.1c.6-.8 1-1.8.9-2.9-.9 0-2 .6-2.6 1.4-.6.7-1.1 1.7-.9 2.7 1 .1 2-.5 2.6-1.2Z"/></>,
  };
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" style={style} aria-hidden="true">
      {paths[name]}
    </svg>
  );
}

function Avatar({ user, size = 40, online = false, ring = false }) {
  const u = typeof user === 'string' ? (DATA.USERS[user] || DATA.ME) : user;
  return (
    <div className="avatar" style={{
      width: size, height: size, fontSize: size * 0.38, background: u.color,
      boxShadow: ring ? `0 0 0 2.5px #fff, 0 0 0 4.5px ${u.color}` : 'none',
    }}>
      {u.avatar}
      {online && <span className="avatar__online" />}
    </div>
  );
}

function Verified({ size = 14 }) {
  return (
    <svg className="verified" width={size} height={size} viewBox="0 0 24 24" aria-label="verified">
      <path fill="currentColor" d="m12 1.5 2.5 1.9 3.1-.2 1 3 2.6 1.7-1 3 1 3-2.6 1.7-1 3-3.1-.2L12 22.5 9.5 20.6l-3.1.2-1-3L2.8 16l1-3-1-3 2.6-1.7 1-3 3.1.2L12 1.5Z"/>
      <path fill="#fff" d="m8 12 2.8 2.8L16 9.5" stroke="#fff" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round"/>
    </svg>
  );
}

// Banner background for roadmap cards — flat color + faint wave linework
function rmBanner(color) {
  return {
    background: color,
    backgroundImage: `repeating-linear-gradient(60deg, rgba(255,255,255,0.10) 0 1.5px, transparent 1.5px 26px)`,
  };
}

function RoadmapCard({ id, onOpen, variant }) {
  const r = DATA.ROADMAPS[id];
  const a = DATA.USERS[r.author];
  return (
    <div className={'rmcard' + (variant === 'chat' ? ' rmcard--chat' : '')} onClick={() => onOpen && onOpen(id)}>
      <div className="rmcard__banner" style={rmBanner(r.color)}>
        <span className="rmcard__tag">{r.tag}</span>
        <span className="rmcard__days">{r.days} ngày</span>
      </div>
      <div className="rmcard__body">
        <div className="rmcard__title">{r.title}</div>
        <div className="rmcard__blurb">{r.blurb}</div>
        <div className="rmcard__foot">
          <span className="rmcard__star"><Icon name="star" size={13} /> {r.rating}</span>
          <span>{r.votes} đánh giá</span>
          <span>· {r.learners} đang học</span>
        </div>
        <div className="rmcard__author">
          <Avatar user={a} size={22} />
          <span style={{ fontWeight: 600 }}>{a.name}</span>
          {a.verified && <Verified size={12} />}
        </div>
      </div>
    </div>
  );
}

function StatusBar({ dark }) {
  const c = dark ? '#fff' : '#000';
  return (
    <div className={'statusbar' + (dark ? ' dark' : '')}>
      <span className="statusbar__time" style={{ color: c }}>9:41</span>
      <div style={{ display: 'flex', alignItems: 'center', gap: 7 }}>
        <svg width="18" height="12" viewBox="0 0 18 12"><rect x="0" y="7" width="3" height="5" rx="0.6" fill={c}/><rect x="4.6" y="4.5" width="3" height="7.5" rx="0.6" fill={c}/><rect x="9.2" y="2" width="3" height="10" rx="0.6" fill={c}/><rect x="13.8" y="0" width="3" height="12" rx="0.6" fill={c}/></svg>
        <svg width="16" height="12" viewBox="0 0 17 12"><path d="M8.5 3.2C10.8 3.2 12.9 4.1 14.4 5.6L15.5 4.5C13.7 2.7 11.2 1.5 8.5 1.5C5.8 1.5 3.3 2.7 1.5 4.5L2.6 5.6C4.1 4.1 6.2 3.2 8.5 3.2Z" fill={c}/><path d="M8.5 6.8C9.9 6.8 11.1 7.3 12 8.2L13.1 7.1C11.8 5.9 10.2 5.1 8.5 5.1C6.8 5.1 5.2 5.9 3.9 7.1L5 8.2C5.9 7.3 7.1 6.8 8.5 6.8Z" fill={c}/><circle cx="8.5" cy="10.5" r="1.5" fill={c}/></svg>
        <svg width="25" height="12" viewBox="0 0 27 13"><rect x="0.5" y="0.5" width="23" height="12" rx="3.5" stroke={c} strokeOpacity="0.35" fill="none"/><rect x="2" y="2" width="19" height="9" rx="2" fill={c}/><path d="M25 4.5V8.5C25.8 8.2 26.5 7.2 26.5 6.5C26.5 5.8 25.8 4.8 25 4.5Z" fill={c} fillOpacity="0.4"/></svg>
      </div>
    </div>
  );
}

Object.assign(window, { Icon, Avatar, Verified, RoadmapCard, StatusBar, rmBanner });
