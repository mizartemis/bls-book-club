-- ============================================================
-- 블스 독서 모임 · Supabase 초기 설정 SQL
-- 사용법: Supabase Dashboard → SQL Editor → New query → 전체 붙여넣기 → Run
-- ============================================================

-- 1) 테이블 생성 -----------------------------------------------
create table if not exists reviews (
  id           text primary key,
  name         text not null,
  date         date,
  book         text not null,
  author       text,
  content      text not null,
  tag          text,
  created_at   timestamptz default now()
);

create table if not exists books (
  id           text primary key,
  title        text not null,
  author       text,
  recommender  text,
  color        text,
  comment      text,
  created_at   timestamptz default now()
);

create table if not exists daily (
  id           text primary key,
  name         text not null,
  date         date,
  emoji        text,
  content      text,
  created_at   timestamptz default now()
);

create table if not exists fees (
  id           text primary key,
  date         date,
  name         text,
  description  text,
  amount       integer,
  created_at   timestamptz default now()
);

-- 2) RLS (Row Level Security) 정책 ----------------------------
-- 회원 인증 없이 누구나 읽기/쓰기 가능한 단순 모드.
-- (소규모 비공개 모임 사이트 가정. 더 엄격한 권한이 필요하면
--  Supabase Auth + 사용자별 정책으로 교체하세요.)
alter table reviews enable row level security;
alter table books   enable row level security;
alter table daily   enable row level security;
alter table fees    enable row level security;

create policy "anon all on reviews" on reviews for all using (true) with check (true);
create policy "anon all on books"   on books   for all using (true) with check (true);
create policy "anon all on daily"   on daily   for all using (true) with check (true);
create policy "anon all on fees"    on fees    for all using (true) with check (true);

-- 3) 샘플 데이터 (선택) ---------------------------------------
insert into reviews (id, name, date, book, author, content, tag) values
  ('seed-r1', '지영', '2026-04-15', '여름은 오래 그곳에 남아', '마쓰이에 마사시 / 비채',
   '건축가의 산장에서 보낸 한 여름. 천천히 흘러가는 시간 속에서 진짜 중요한 것이 무엇인지 다시 생각하게 되었습니다. 페이지마다 햇살과 바람이 느껴지는 책이었어요.', '4월 정기'),
  ('seed-r2', '민호', '2026-04-08', '달러구트 꿈 백화점', '이미예 / 팩토리나인',
   '잠든 사이 우리가 사는 꿈을 파는 백화점이라니. 따뜻하고 동화같은 상상력에 마음이 말랑해졌어요.', '자유 독서'),
  ('seed-r3', '수진', '2026-04-01', '꽃을 보듯 너를 본다', '나태주 / 지혜',
   '"자세히 보아야 예쁘다, 오래 보아야 사랑스럽다." 한 줄 한 줄 음미하며 봄을 닮은 시를 읽었습니다.', '시 모음')
on conflict (id) do nothing;

insert into books (id, title, author, recommender, color, comment) values
  ('seed-b1', '불편한 편의점',     '김호연',    '지영', '135deg,#a87b3e,#5a3e22', '따뜻한 사람들이 있는 편의점, 마음이 환해져요.'),
  ('seed-b2', '미드나잇 라이브러리','매트 헤이그','민호', '135deg,#7a8c5f,#3e5a3a', '인생의 후회를 다시 살아볼 수 있다면?'),
  ('seed-b3', '아몬드',             '손원평',    '수진', '135deg,#b04a3a,#6a2a1e', '감정을 모르는 소년이 배워가는 사랑.')
on conflict (id) do nothing;

insert into daily (id, name, date, emoji, content) values
  ('seed-d1', '지영', '2026-04-28', '☕',
   '오랜만에 들른 동네 카페에서 햇살 좋은 자리에 앉아 책을 읽었어요. 이런 평범한 오후가 제일 행복한 것 같아요.'),
  ('seed-d2', '수진', '2026-04-27', '🌷',
   '출근길에 핀 튤립을 보고 봄이 다 가기 전에 한 번 더 꽃놀이 가야겠다고 다짐했답니다.')
on conflict (id) do nothing;

insert into fees (id, date, description, name, amount) values
  ('seed-f1', '2026-04-15', '4월 회비',          '지영', 50000),
  ('seed-f2', '2026-04-15', '4월 회비',          '민호', 50000),
  ('seed-f3', '2026-04-15', '4월 회비',          '수진', 50000),
  ('seed-f4', '2026-04-15', '4월 회비',          '현우', 50000),
  ('seed-f5', '2026-04-15', '모임 카페 (정기)',  '공동', -42000),
  ('seed-f6', '2026-04-20', '다과 구입',         '지영', -18000)
on conflict (id) do nothing;
