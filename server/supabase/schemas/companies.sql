create table public.companies (
  "id" uuid primary key default gen_random_uuid(),
  "name" text not null unique,
  "website" text,
  "logo_url" text,
  "created_at" timestamptz default now(),
  "updated_at" timestamptz default now()
);