drop policy "Users can manage own work history" on "public"."work_history";

alter table "public"."work_history" drop constraint "work_history_user_id_fkey";

alter table "public"."work_history" add constraint "work_history_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE not valid;

alter table "public"."work_history" validate constraint "work_history_user_id_fkey";


  create policy "Users can manage their own work history"
  on "public"."work_history"
  as permissive
  for all
  to public
using ((auth.uid() = user_id))
with check ((auth.uid() = user_id));



