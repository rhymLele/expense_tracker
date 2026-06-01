// LearnSpace — Roadmap tab (active path, streak, today's tasks, queue)
const { useState: useStateRm } = React;

function TodayTask({ item }) {
  const [done, setDone] = useStateRm(item.done);
  return (
    <div className={'task' + (done ? ' done' : '')} onClick={() => setDone(d => !d)}>
      <div className="task__check">{done && <Icon name="check" size={15} stroke="#fff" sw={2.5} />}</div>
      <div className="task__body">
        <div className="task__label">{item.label}</div>
        <span className="task__type">{item.type}</span>
      </div>
      <Icon name="chevron" size={16} stroke="#9DA4AE" />
    </div>
  );
}

function PathNode({ node }) {
  const cap = { done: 'Hoàn thành', today: 'Hôm nay', locked: `${node.tasks} bài tập` };
  return (
    <div className="node">
      {node.status === 'today' && <div className="node__pulse">BẮT ĐẦU</div>}
      <div className={'node__circle ' + node.status}>
        {node.status === 'done' ? <Icon name="check" size={24} stroke="#fff" sw={2.5} />
          : node.status === 'locked' ? <Icon name="route" size={22} />
          : <span>N{node.day}</span>}
      </div>
      <div className="node__caption">Ngày {node.day}</div>
      <div className="node__sub">{node.title}</div>
    </div>
  );
}

function QueueItem({ id, index, onReorder, dragIdx, setDragIdx }) {
  const r = DATA.ROADMAPS[id];
  const a = DATA.USERS[r.author];
  const [over, setOver] = useStateRm(false);
  return (
    <div
      className={'qitem' + (dragIdx === index ? ' dragging' : '') + (over ? ' dragover' : '')}
      draggable
      onDragStart={() => setDragIdx(index)}
      onDragOver={e => { e.preventDefault(); setOver(true); }}
      onDragLeave={() => setOver(false)}
      onDrop={e => { e.preventDefault(); setOver(false); onReorder(dragIdx, index); setDragIdx(null); }}
      onDragEnd={() => setDragIdx(null)}
    >
      <span className="qitem__num">{index + 1}</span>
      <div className="rmcard__banner" style={{ ...rmBanner(r.color), width: 46, height: 46, borderRadius: 10, flexShrink: 0, padding: 0 }} />
      <div className="qitem__body">
        <div className="qitem__title">{r.title}</div>
        <div className="qitem__meta">{a.name} · {r.days} ngày · ★ {r.rating}</div>
      </div>
      <span className="qitem__grip"><Icon name="grip" size={20} /></span>
    </div>
  );
}

function RoadmapScreen({ onOpenRoadmap }) {
  const active = DATA.ROADMAPS.r1;
  const today = DATA.SYLLABUS.find(d => d.status === 'today');
  const [queue, setQueue] = useStateRm(DATA.QUEUE);
  const [dragIdx, setDragIdx] = useStateRm(null);
  const doneCount = today.items.filter(i => i.done).length;
  const progress = Math.round((11 / active.days) * 100);

  const reorder = (from, to) => {
    if (from == null || from === to) return;
    setQueue(q => {
      const next = [...q];
      const [m] = next.splice(from, 1);
      next.splice(to, 0, m);
      return next;
    });
  };

  return (
    <div className="screen">
      <div className="screen__scroll">
        {/* Hero — streak + active roadmap progress */}
        <div className="rm__hero">
          <div className="rm__herostat">
            <div className="streak">
              <Icon name="flame" size={30} fill="#FFD89E" stroke="#FFD89E" />
              <div>
                <div className="streak__num">{DATA.ME.streak}</div>
                <div className="streak__lbl">ngày streak</div>
              </div>
            </div>
            <button className="btn" style={{ background: 'rgba(255,255,255,0.18)', color: '#fff', padding: '9px 14px', fontSize: 13 }}>
              <Icon name="settings" size={16} stroke="#fff" /> Quản lý
            </button>
          </div>

          <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginTop: 18, fontSize: 12, opacity: 0.9 }}>
            <span style={{ background: 'rgba(255,255,255,0.2)', padding: '3px 9px', borderRadius: 99, fontWeight: 700 }}>ĐANG HỌC</span>
            <span>{active.tag} · {DATA.USERS[active.author].name}</span>
          </div>
          <div className="rm__title">{active.title}</div>
          <div className="rm__progmeta">
            <span>Ngày 12 / {active.days}</span>
            <span>{progress}% hoàn thành</span>
          </div>
          <div className="rm__bar"><div className="rm__barfill" style={{ width: progress + '%' }} /></div>
        </div>

        {/* Today's tasks */}
        <section className="today">
          <div className="today__head">
            <span className="today__h">Nhiệm vụ hôm nay</span>
            <span className="today__count">{doneCount}/{today.items.length} hoàn thành</span>
          </div>
          {today.items.map(it => <TodayTask key={it.id} item={it} />)}
        </section>

        {/* Linear path */}
        <section className="path">
          <span className="path__h">Hành trình của bạn</span>
          {DATA.SYLLABUS.map((node, i) => (
            <React.Fragment key={node.day}>
              {i > 0 && <div className={'node__line' + (DATA.SYLLABUS[i - 1].status === 'done' ? ' done' : '')} />}
              <PathNode node={node} />
            </React.Fragment>
          ))}
        </section>

        {/* Queue */}
        <section className="queue">
          <div className="queue__head">
            <span className="queue__h">Hàng đợi lộ trình</span>
            <span className="discover__link">+ Thêm</span>
          </div>
          <div className="queue__hint">Kéo để sắp xếp thứ tự — lộ trình kế tiếp sẽ tự kích hoạt khi bạn hoàn thành.</div>
          {queue.map((id, i) => (
            <QueueItem key={id} id={id} index={i} onReorder={reorder} dragIdx={dragIdx} setDragIdx={setDragIdx} />
          ))}
          <button className="btn btn--ghost btn--block" style={{ marginTop: 4, color: 'var(--color-danger-700)' }}>
            Hủy lộ trình hiện tại
          </button>
        </section>
      </div>
    </div>
  );
}

window.RoadmapScreen = RoadmapScreen;
