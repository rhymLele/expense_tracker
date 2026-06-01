// LearnSpace — app root: phone shell, tab routing, tweaks
const { useState: useStateApp, useEffect: useEffectApp } = React;

const TWEAK_DEFAULTS = /*EDITMODE-BEGIN*/{
  "accent": "#5CC691",
  "cornerStyle": "rounded",
  "showLive": true,
  "startScreen": "feed"
}/*EDITMODE-END*/;

const TABS = [
  { id: 'feed',    label: 'Trang chủ', icon: 'home' },
  { id: 'roadmap', label: 'Lộ trình',  icon: 'route' },
  { id: 'chat',    label: 'Tin nhắn',  icon: 'chat', badge: 2 },
  { id: 'profile', label: 'Cá nhân',   icon: 'user' },
];

function TabBar({ active, onChange }) {
  return (
    <nav className="tabbar">
      {TABS.map(t => (
        <button key={t.id} className={'tab' + (active === t.id ? ' active' : '')} onClick={() => onChange(t.id)}>
          <Icon name={t.icon} size={25} fill={active === t.id ? 'rgba(92,198,145,0.16)' : 'none'} />
          <span className="tab__label">{t.label}</span>
          {t.badge ? <span className="tab__badge">{t.badge}</span> : null}
        </button>
      ))}
    </nav>
  );
}

function App() {
  const [t, setTweak] = useTweaks(TWEAK_DEFAULTS);
  const [loggedIn, setLoggedIn] = useStateApp(false);
  const [tab, setTab] = useStateApp(t.startScreen || 'feed');
  const [openChat, setOpenChat] = useStateApp(null);
  const [detailRoadmap, setDetailRoadmap] = useStateApp(null);

  // live accent + corner overrides
  useEffectApp(() => {
    const root = document.documentElement;
    root.style.setProperty('--color-primary', t.accent);
    root.style.setProperty('--color-primary-500', t.accent);
    const radii = { rounded: { lg: '12px', xl: '16px' }, sharp: { lg: '6px', xl: '8px' }, pill: { lg: '18px', xl: '22px' } }[t.cornerStyle] || { lg: '12px', xl: '16px' };
    root.style.setProperty('--radius-lg', radii.lg);
    root.style.setProperty('--radius-xl', radii.xl);
  }, [t.accent, t.cornerStyle]);

  const openRoadmap = (id) => setDetailRoadmap(id);

  let body;
  if (tab === 'feed') body = <FeedScreen onOpenRoadmap={openRoadmap} showLive={t.showLive} />;
  else if (tab === 'roadmap') body = <RoadmapScreen onOpenRoadmap={openRoadmap} />;
  else if (tab === 'chat') body = openChat
    ? <ThreadScreen chat={openChat} onBack={() => setOpenChat(null)} onOpenRoadmap={openRoadmap} />
    : <ChatListScreen onOpen={setOpenChat} />;
  else if (tab === 'profile') body = <ProfileScreen onOpenRoadmap={openRoadmap} />;

  const inThread = tab === 'chat' && openChat;

  return (
    <>
      <div className="phone">
        <div className="phone__island" />
        <StatusBar dark={!loggedIn || tab === 'roadmap'} />

        {loggedIn ? (
          <>
            {body}
            {!inThread && <TabBar active={tab} onChange={(id) => { setTab(id); }} />}
            {detailRoadmap && <RoadmapDetail id={detailRoadmap} onClose={() => setDetailRoadmap(null)} />}
          </>
        ) : (
          <LoginScreen onLogin={() => setLoggedIn(true)} />
        )}

        <div className={'homebar' + ((!loggedIn || tab === 'roadmap') ? ' dark' : '')}><div className="homebar__pill" /></div>
      </div>

      <TweaksPanel>
        <TweakSection label="Thương hiệu" />
        <TweakColor label="Màu nhấn" value={t.accent}
          options={['#5CC691', '#2A6FDB', '#764FDB', '#E37E36']}
          onChange={v => setTweak('accent', v)} />
        <TweakRadio label="Bo góc" value={t.cornerStyle}
          options={['sharp', 'rounded', 'pill']}
          onChange={v => setTweak('cornerStyle', v)} />
        <TweakSection label="Nội dung" />
        <TweakToggle label="Hiện banner Livestream" value={t.showLive}
          onChange={v => setTweak('showLive', v)} />
        <TweakSelect label="Mở màn hình" value={t.startScreen}
          options={['feed', 'roadmap', 'chat', 'profile']}
          onChange={v => { setTweak('startScreen', v); setTab(v); }} />
        <TweakButton label="Đăng xuất / xem Login" onClick={() => setLoggedIn(false)} />
      </TweaksPanel>
    </>
  );
}

// hide live banner via tweak
function applyLiveTweak() {}

ReactDOM.createRoot(document.getElementById('root')).render(<App />);
