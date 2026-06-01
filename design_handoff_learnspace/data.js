// LearnSpace — mock data. Vietnamese-first social learning app.
window.DATA = (function () {
  const ME = {
    id: 'me',
    name: 'Nguyễn Quỳnh Anh',
    handle: '@quynhanh',
    avatar: 'QA',
    color: '#5CC691',
    streak: 23,
    followers: 184,
    following: 96,
  };

  const USERS = {
    maianh:  { id: 'maianh',  name: 'Cô Mai Anh',     handle: '@maianh.ielts', avatar: 'MA', color: '#764FDB', role: 'IELTS 8.5 · Speaking', followers: '12.4k', verified: true },
    david:   { id: 'david',   name: 'David Nguyễn',    handle: '@david.accent', avatar: 'DN', color: '#2A6FDB', role: 'Phát âm giọng Mỹ',     followers: '8.9k',  verified: true },
    linh:    { id: 'linh',    name: 'Cô Linh Trang',   handle: '@linh.biz',     avatar: 'LT', color: '#E37E36', role: 'Business English',     followers: '5.1k',  verified: true },
    hung:    { id: 'hung',    name: 'Thầy Hùng',       handle: '@hung.grammar', avatar: 'TH', color: '#449297', role: 'Ngữ pháp & Writing',   followers: '3.7k',  verified: false },
    mira:    { id: 'mira',    name: 'Mira Phạm',       handle: '@mira.learns',  avatar: 'MP', color: '#EB5146', role: 'Đang học IELTS',       followers: '420',   verified: false },
  };

  const ROADMAPS = {
    r1: {
      id: 'r1', title: 'IELTS Speaking 7.0 trong 30 ngày', author: 'maianh',
      days: 30, rating: 4.8, votes: 1240, learners: '3.2k', color: '#5CC691',
      tag: 'IELTS', blurb: 'Luyện phản xạ Part 1–2–3 với feedback chấm điểm mỗi ngày.',
    },
    r2: {
      id: 'r2', title: 'Phát âm chuẩn Mỹ — 14 ngày', author: 'david',
      days: 14, rating: 4.7, votes: 860, learners: '2.1k', color: '#2A6FDB',
      tag: 'Phát âm', blurb: 'Nắm 44 âm IPA, nối âm và ngữ điệu tự nhiên.',
    },
    r3: {
      id: 'r3', title: 'Business English cho người đi làm', author: 'linh',
      days: 21, rating: 4.6, votes: 540, learners: '1.4k', color: '#E37E36',
      tag: 'Business', blurb: 'Email, họp và thuyết trình tự tin trong 3 tuần.',
    },
    r4: {
      id: 'r4', title: 'Travel English — 7 ngày cấp tốc', author: 'hung',
      days: 7, rating: 4.5, votes: 310, learners: '980', color: '#764FDB',
      tag: 'Giao tiếp', blurb: 'Tự tin xoay sở mọi tình huống khi đi du lịch.',
    },
  };

  // Active roadmap day-by-day syllabus (excerpt)
  const SYLLABUS = [
    { day: 11, title: 'Describe a place', status: 'done',    tasks: 3 },
    { day: 12, title: 'Part 2 — Cue card', status: 'today',  tasks: 3,
      items: [
        { id: 't1', label: 'Nghe & nhại 8 cụm từ chủ đề "Travel"', type: 'Phát âm', done: true },
        { id: 't2', label: 'Ghi âm trả lời cue card (90 giây)',       type: 'Speaking', done: false },
        { id: 't3', label: 'Viết đoạn 150 từ mô tả chuyến đi đáng nhớ', type: 'Writing', done: false },
      ],
    },
    { day: 13, title: 'Part 3 — Discussion', status: 'locked', tasks: 4 },
    { day: 14, title: 'Mock test tuần 2',     status: 'locked', tasks: 2 },
  ];

  const FEED = [
    {
      id: 'p1', user: 'maianh', time: '2 giờ', liked: false, likes: 342, comments: 28,
      text: 'Cue card hôm nay: "Describe a memorable trip". Tip vàng — đừng kể tuần tự, hãy bám vào CẢM XÚC tại từng khoảnh khắc. Mình vừa cập nhật bài luyện Ngày 12 của lộ trình bên dưới nhé!',
      roadmap: 'r1', image: null,
    },
    {
      id: 'p2', user: 'david', time: '5 giờ', liked: true, likes: 511, comments: 64,
      text: 'Âm /θ/ và /ð/ là nỗi sợ của người Việt. Bí quyết: đặt lưỡi chạm nhẹ răng cửa rồi đẩy hơi. Xem clip mình hướng dẫn trong lộ trình 14 ngày 👇',
      roadmap: 'r2', image: 'accent',
    },
    {
      id: 'p3', user: 'mira', time: '1 ngày', liked: false, likes: 96, comments: 12,
      text: 'Vừa hoàn thành chuỗi 7 ngày streak đầu tiên của mình! Cảm giác mỗi ngày làm xong list bài tập rồi tích lửa đúng kiểu gây nghiện thật sự 🔥',
      roadmap: null, image: 'streak',
    },
  ];

  const QUEUE = ['r2', 'r3', 'r4']; // saved roadmaps in priority order

  const CHATS = [
    { id: 'c1', user: 'maianh', last: 'Phần ghi âm Part 2 của em ổn rồi nhé, chú ý linking nha', time: '09:24', unread: 2, online: true },
    { id: 'c2', user: 'david', last: 'Bạn: Cảm ơn thầy về lộ trình ạ!', time: 'Hôm qua', unread: 0, online: false },
    { id: 'c3', user: 'linh', last: 'Lớp livestream tối nay lúc 20h nhé cả nhà', time: 'Hôm qua', unread: 0, online: true, group: true, groupName: 'Business English Club' },
    { id: 'c4', user: 'mira', last: 'Mình cùng đua streak nha 🔥', time: 'T3', unread: 0, online: false },
  ];

  const THREAD = [
    { id: 'm1', from: 'maianh', text: 'Chào em, cô vừa nghe bản ghi âm Part 2 của em.', time: '09:20' },
    { id: 'm2', from: 'maianh', text: 'Nội dung tốt, nhưng em nói hơi nhanh ở đoạn mở đầu. Thử chậm lại và nhấn vào từ khoá nhé.', time: '09:21' },
    { id: 'm3', from: 'me',     text: 'Dạ em cảm ơn cô! Em sẽ luyện lại theo lộ trình ạ.', time: '09:23' },
    { id: 'm4', from: 'maianh', text: 'Đây là lộ trình cô muốn em tập trung tuần này:', time: '09:24', roadmap: 'r1' },
  ];

  return { ME, USERS, ROADMAPS, SYLLABUS, FEED, QUEUE, CHATS, THREAD };
})();
