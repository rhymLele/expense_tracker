import 'lt_models.dart';

final kMockThreads = <LtThread>[
  const LtThread(
    id: 't1',
    emoji: '📚',
    title: 'IELTS Writing Task 2 Masterclass',
    description:
        'A complete 8-node path covering essay structure, cohesion, vocabulary range, and timed practice with AI grading.',
    cefrLevel: 'B2',
    language: 'English',
    creatorName: 'Sarah Chen',
    creatorGemma: 4800,
    enrolledCount: 1247,
    nodeCount: 8,
    durationMinutes: 45,
    tags: ['writing', 'IELTS', 'grammar'],
    progressPercent: 0.62,
  ),
  const LtThread(
    id: 't2',
    emoji: '🎌',
    title: 'Japanese Hiragana & Katakana Sprint',
    description:
        'Master both syllabaries in 5 days with spaced-repetition flashcards and writing exercises.',
    cefrLevel: 'A1',
    language: 'Japanese',
    creatorName: 'Yuki Tanaka',
    creatorGemma: 3200,
    enrolledCount: 892,
    nodeCount: 10,
    durationMinutes: 30,
    tags: ['hiragana', 'katakana', 'beginner'],
    progressPercent: null,
  ),
  const LtThread(
    id: 't3',
    emoji: '🗣️',
    title: 'French Conversational Fluency B1',
    description:
        'Roleplay dialogues, pronunciation drills, and speaking assessments designed for intermediate learners.',
    cefrLevel: 'B1',
    language: 'French',
    creatorName: 'Marie Dubois',
    creatorGemma: 5600,
    enrolledCount: 643,
    nodeCount: 6,
    durationMinutes: 35,
    tags: ['speaking', 'conversation', 'roleplay'],
    progressPercent: null,
  ),
];

final kMockPosts = <LtPost>[
  LtPost(
    id: 'p1',
    authorName: 'Alex Tran',
    authorGemma: 1240,
    createdAt: '2h',
    body:
        'Quick tip for IELTS Writing Task 2: always paraphrase the question in your introduction — never copy it word for word. I went from Band 6.0 to 7.5 just by fixing this one habit 🎯',
    tags: ['writing', 'IELTS'],
    likeCount: 84,
    commentCount: 12,
  ),
  LtPost(
    id: 'p2',
    authorName: 'Diana Park',
    authorGemma: 2890,
    createdAt: '5h',
    body:
        '日本語の勉強を始めて3ヶ月。まだまだですが、毎日少しずつ。継続は力なり！\n\n(3 months of Japanese study. Still a long way to go, but a little every day. Consistency is power!)',
    tags: ['japanese', 'motivation'],
    likeCount: 61,
    commentCount: 7,
  ),
  LtPost(
    id: 'p3',
    authorName: 'Carlos Rivera',
    authorGemma: 980,
    createdAt: '1d',
    body:
        'PSA: the AI Roleplay nodes on LinguaThread are genuinely the best speaking practice I\'ve found outside of actual tutoring. The examiner persona is surprisingly realistic.',
    tags: ['speaking', 'AI', 'review'],
    likeCount: 112,
    commentCount: 23,
  ),
];

// Interleaved feed
final kMockFeed = <LtFeedItem>[
  LtFeedThread(kMockThreads[0]),
  LtFeedPost(kMockPosts[0]),
  LtFeedThread(kMockThreads[1]),
  LtFeedPost(kMockPosts[1]),
  LtFeedThread(kMockThreads[2]),
  LtFeedPost(kMockPosts[2]),
];

// The in-progress thread for resume banner
final kResumeThread = kMockThreads[0];
const kResumeNodeTitle = 'Writing Task: Problem-Solution Essay';
