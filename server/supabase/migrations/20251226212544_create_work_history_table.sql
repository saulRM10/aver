
  create table "public"."work_history" (
    "work_history_id" uuid not null default gen_random_uuid(),
    "user_id" uuid not null,
    "company_id" uuid not null,
    "overall_start_date" date not null,
    "overall_end_date" date,
    "employment_type" text,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );


alter table "public"."work_history" enable row level security;

CREATE UNIQUE INDEX work_history_pkey ON public.work_history USING btree (work_history_id);

alter table "public"."work_history" add constraint "work_history_pkey" PRIMARY KEY using index "work_history_pkey";

alter table "public"."work_history" add constraint "work_history_company_id_fkey" FOREIGN KEY (company_id) REFERENCES public.companies(id) not valid;

alter table "public"."work_history" validate constraint "work_history_company_id_fkey";

alter table "public"."work_history" add constraint "work_history_employment_type_check" CHECK ((employment_type = ANY (ARRAY['full-time'::text, 'part-time'::text, 'contract'::text, 'freelance'::text, 'volunteer'::text]))) not valid;

alter table "public"."work_history" validate constraint "work_history_employment_type_check";

alter table "public"."work_history" add constraint "work_history_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."work_history" validate constraint "work_history_user_id_fkey";


grant delete on table "public"."work_history" to "authenticated";

grant insert on table "public"."work_history" to "authenticated";

grant references on table "public"."work_history" to "authenticated";

grant select on table "public"."work_history" to "authenticated";

grant trigger on table "public"."work_history" to "authenticated";

grant truncate on table "public"."work_history" to "authenticated";

grant update on table "public"."work_history" to "authenticated";

grant delete on table "public"."work_history" to "service_role";

grant insert on table "public"."work_history" to "service_role";

grant references on table "public"."work_history" to "service_role";

grant select on table "public"."work_history" to "service_role";

grant trigger on table "public"."work_history" to "service_role";

grant truncate on table "public"."work_history" to "service_role";

grant update on table "public"."work_history" to "service_role";


  create policy "Users can manage own work history"
  on "public"."work_history"
  as permissive
  for all
  to public
using ((auth.uid() = user_id))
with check ((auth.uid() = user_id));



