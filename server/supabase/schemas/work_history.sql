create table public.work_history (
  "work_history_id" uuid primary key default gen_random_uuid(),
  "user_id" uuid not null references auth.users(id) on delete cascade,
  "company_id" uuid not null references public.companies(id),
  "overall_start_date" date not null,
  "overall_end_date" date,
  "employment_type" text check (employment_type in ('full-time', 'part-time', 'contract', 'freelance', 'volunteer')),
  "created_at" timestamptz default now(),
  "updated_at" timestamptz default now()
);

alter table "public"."work_history" enable row level security;

create policy "Users can manage own work history"
  on "public"."work_history"
  for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);