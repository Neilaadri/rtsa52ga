# RTSA52GA™ — Backend upgrade

This starter package upgrades the supplied single-file website to use Supabase Auth and a PostgreSQL database.

## Included
- `index.html` — website with account sign-up/sign-in, persisted community registrations, and saved vendor profiles with edit/delete.
- `supabase-schema.sql` — database tables, indexes, grants, and Row Level Security (RLS) policies.

## Setup
1. Create a project at https://supabase.com/.
2. In the Supabase dashboard, open **SQL Editor**, create a query, paste all of `supabase-schema.sql`, and run it.
3. Open **Project Settings → API** (or **Connect**, depending on dashboard layout). Copy the Project URL and the **publishable key** (or legacy `anon` key).
4. Open `index.html` in a code editor. Near the start of the script, replace:
   - `https://YOUR_PROJECT_ID.supabase.co` with your Project URL
   - `YOUR_SUPABASE_PUBLISHABLE_OR_ANON_KEY` with the publishable/anon key
5. In Supabase **Authentication → URL Configuration**, set your Site URL to your eventual website URL. Add local development and deployed URLs to Redirect URLs if needed.
6. Test sign-up, confirm the email if confirmation is enabled, sign in, submit a community registration, and create/edit/delete a vendor profile.
7. Deploy the folder to a static host such as GitHub Pages, Netlify, or Cloudflare Pages. Keep `index.html` and `supabase-schema.sql` as separate files.

## Security notes
- The browser key is designed to be public when Row Level Security is correctly enabled. Never put a Supabase `service_role` or secret key in HTML.
- Do not disable RLS to make errors disappear. Check the policies and authenticated session instead.
- Vendor profiles and registrations are private to the account that created them in this starter version. A future public marketplace should use a separate, reviewed public-read policy for approved profiles.
- Email confirmation settings affect whether a newly registered user can immediately sign in.
- This is a starter implementation, not a full production audit. Before public launch, add privacy/terms pages, abuse protection, backups, monitoring, and a reviewed account recovery flow.
