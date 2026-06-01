// LearnSpace — Chat tab (conversation list + 1-1 thread)
const { useState: useStateChat } = React;

function ChatRow({ chat, onOpen }) {
  const u = DATA.USERS[chat.user];
  const name = chat.group ? chat.groupName : u.name;
  return (
    <div className="chatrow" onClick={() => onOpen(chat)}>
      {chat.group
        ? <div className="avatar" style={{ width: 52, height: 52, background: 'var(--color-purple-500)', fontSize: 20 }}><Icon name="users" size={24} stroke="#fff" /></div>
        : <Avatar user={u} size={52} online={chat.online} />}
      <div className="chatrow__body">
        <div className="chatrow__top">
          <span className="chatrow__name">{name}{!chat.group && u.verified && <Verified size={13} />}</span>
          <span className="chatrow__time">{chat.time}</span>
        </div>
        <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
          <span className={'chatrow__last' + (chat.unread ? ' unread' : '')} style={{ flex: 1 }}>{chat.last}</span>
          {chat.unread > 0 && <span className="chatrow__badge">{chat.unread}</span>}
        </div>
      </div>
    </div>
  );
}

function ChatListScreen({ onOpen }) {
  return (
    <div className="screen">
      <header className="appbar">
        <span className="appbar__title">Tin nhắn</span>
        <div className="appbar__actions">
          <button className="iconbtn" aria-label="tìm"><Icon name="search" size={20} /></button>
          <button className="iconbtn" aria-label="soạn"><Icon name="edit" size={19} /></button>
        </div>
      </header>
      <div className="screen__scroll">
        <div className="chatlist">
          {DATA.CHATS.map(c => <ChatRow key={c.id} chat={c} onOpen={onOpen} />)}
        </div>
      </div>
    </div>
  );
}

function ThreadScreen({ chat, onBack, onOpenRoadmap }) {
  const u = DATA.USERS[chat.user];
  const [text, setText] = useStateChat('');
  const [msgs, setMsgs] = useStateChat(DATA.THREAD);

  const send = () => {
    if (!text.trim()) return;
    setMsgs(m => [...m, { id: 'x' + m.length, from: 'me', text: text.trim(), time: '09:25' }]);
    setText('');
  };

  return (
    <div className="screen thread">
      <header className="thread__header">
        <button className="thread__back" onClick={onBack} aria-label="quay lại"><Icon name="back" size={24} /></button>
        <Avatar user={u} size={40} online={chat.online} />
        <div className="thread__who">
          <div className="thread__name">{u.name}{u.verified && <Verified size={13} />}</div>
          <div className="thread__status">{chat.online ? 'Đang hoạt động' : 'Hoạt động 2 giờ trước'}</div>
        </div>
        <button className="iconbtn" style={{ background: 'transparent' }} aria-label="tùy chọn"><Icon name="chevron" size={20} style={{ transform: 'rotate(90deg)' }} /></button>
      </header>

      <div className="thread__body">
        <div className="daystamp">Hôm nay</div>
        {msgs.map(m => (
          m.roadmap ? (
            <div key={m.id} style={{ alignSelf: 'flex-start', maxWidth: '82%', width: '82%' }}>
              <div className="bubble them" style={{ marginBottom: 6 }}>{m.text}</div>
              <RoadmapCard id={m.roadmap} onOpen={onOpenRoadmap} variant="chat" />
            </div>
          ) : (
            <div key={m.id} className={'bubble ' + (m.from === 'me' ? 'me' : 'them')}>
              {m.text}
              <div className="bubble__time">{m.time}</div>
            </div>
          )
        ))}
      </div>

      <div className="composer">
        <button className="iconbtn" style={{ background: 'var(--color-bg-muted)', flexShrink: 0 }} aria-label="đính kèm"><Icon name="plus" size={20} /></button>
        <input className="composer__input" placeholder="Nhắn tin…" value={text} onChange={e => setText(e.target.value)} onKeyDown={e => e.key === 'Enter' && send()} />
        <button className="composer__send" onClick={send} aria-label="gửi"><Icon name="send" size={18} stroke="#fff" /></button>
      </div>
    </div>
  );
}

Object.assign(window, { ChatListScreen, ThreadScreen });
