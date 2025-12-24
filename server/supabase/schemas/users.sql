create table "users" (
  "id" uuid default gen_random_uuid() primary key,
  "first_name" text,
  "last_name" text, 
  "email" text,
  "profile_pic" text
);