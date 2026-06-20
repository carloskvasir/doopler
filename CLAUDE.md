# CLAUDE.md — Doopler

Context guide for Claude Code working in this project.

## What this project is

Doopler is a gamified microblog where posts have a time-to-live. It is a monetization experiment for Carlos Kvasir's 2026 capstone thesis. The stack is Rails 8.1.3 with Hotwire — no React, no separate API.

## Essential commands

```sh
bin/dev                       # server + Tailwind watch (always use in dev)
mise exec -- rails console    # REPL with the correct Ruby context
mise exec -- rails db:migrate # run migrations
mise exec -- rails routes     # inspect routes
mise exec -- rails test       # run test suite
```

> Always prefix Rails commands with `mise exec --` to ensure Ruby 4.0.5 is used.

## Stack and fixed versions

| | |
|---|---|
| Ruby | 4.0.5 (mise) |
| Rails | 8.1.3 |
| Database | SQLite3 at `/dev/shm/doopler_development.sqlite3` |
| Assets | Propshaft + Importmap (no Webpack, no npm) |
| CSS | Tailwind via `tailwindcss-rails` |
| JS | Hotwire: Turbo + Stimulus |
| Auth | Devise 5 |
| Admin | RailsAdmin 3 (importmap, pins in `config/importmap.rails_admin.rb`) |

Do not add Webpack, esbuild, jsbundling, or any JS bundler without explicit discussion. The project is deliberately importmap-only.

## Critical business rules

1. **Time-to-live**: `Post#before_create` sets `expires_at = 2.hours.from_now`. Do not change this value without a CHANGELOG entry.
2. **Amplification**: `Like#after_create_commit` → `post.expires_at += 1.hour` + Turbo Stream broadcast. The `+1h` is the product contract.
3. **Visibility**: a post is visible if `post.active? || current_user&.premium? || current_user == post.user`. This logic lives in `_post.html.erb` — any change affects the paywall.
4. **Manual premium**: there is no Stripe. The admin grants `premium: true` via `/admin`. Do not add automated payments without explicit agreement.
5. **Unique like**: unique index `[:post_id, :user_id]` on the `likes` table. `LikesController` silently rescues `ActiveRecord::RecordNotUnique`.

## Where things live

```
app/models/post.rb                    callbacks + active?
app/models/like.rb                    extend_post_lifetime + broadcast
app/models/user.rb                    Devise + has_many
app/controllers/posts_controller.rb   index / new / create
app/controllers/likes_controller.rb   create + turbo_stream
app/views/posts/_post.html.erb        paywall UI (blur + overlay)
app/views/posts/_post_clock.html.erb  timer — Turbo Stream broadcast TARGET
app/views/likes/create.turbo_stream.erb  HTTP response to a like
app/javascript/controllers/countdown_controller.js  Stimulus timer
config/initializers/rails_admin.rb    admin auth + asset_source
config/importmap.rails_admin.rb       jspm.io pins for RailsAdmin JS
config/routes.rb                      all routes
db/seeds.rb                           creates admin@doopler.local
```

## Code conventions

- **No obvious comments** — descriptive names are enough
- **No premature abstractions** — this is an MVP thesis project
- **Turbo Stream, not manual JS** — reactive updates via broadcast or `.turbo_stream.erb` response
- **Tailwind inline** — no custom CSS classes unless Tailwind can't reach it
- Color palette: dark theme `gray-950 / gray-900 / gray-800`, accent `indigo-600`

## CHANGELOG

Every meaningful change must be recorded in `CHANGELOG.md` before committing, following the Keep a Changelog format. Sections used: `Added`, `Changed`, `Fixed`, `Removed`.

Current version: **0.1.0** (MVP).

## Development access

| | |
|---|---|
| App | http://localhost:3000 |
| Admin | http://localhost:3000/admin |
| Admin login | admin@doopler.local / doopler123 |

## Known pitfalls

- The `rails generate rails_admin:install` generator hangs on importmap without network access to jspm.io. The pins are already in `config/importmap.rails_admin.rb` — **do not re-run the generator**.
- The dev database lives at `/dev/shm` and is lost on reboot. `rails db:setup` recreates everything.
- The Like Turbo broadcast uses Action Cable via `solid_cable` (SQLite). Do not swap to Redis without updating `config/cable.yml`.
