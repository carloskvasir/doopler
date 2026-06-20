# Doopler — Doopler Effect

Gamified microblogging with a time-decay mechanic. Built as a monetization experiment for a capstone thesis (2026).

Every post starts with **2 hours of life**. Each `Like` (called an _amplification_) extends it by **+1 hour**. When the timer hits zero, the content disappears for free users — visible only to **premium** members, who get access by contacting the author on LinkedIn.

```
Post created   →  expires_at = now + 2h
Like received  →  expires_at += 1h  (real-time Turbo Stream broadcast)
Expired + free →  content blurred + LinkedIn CTA overlay
```

## Stack

| Layer | Technology |
|---|---|
| Runtime | Ruby 4.0.5 (via mise) |
| Framework | Rails 8.1.3 |
| Database | SQLite3 at `/dev/shm` (RAM, dev) |
| Frontend | Tailwind CSS + Hotwire (Turbo + Stimulus) |
| Auth | Devise 5 |
| Admin | RailsAdmin 3 |
| Assets | Propshaft + Importmap |

## Setup

```sh
# 1. Install the correct Ruby version
mise install

# 2. Install dependencies
bundle install

# 3. Create and migrate the database
rails db:setup       # creates + migrates + seeds (admin user)

# 4. Start the server with CSS watch
bin/dev
```

Open **http://localhost:3000**.

## Development credentials

| Role | Email | Password |
|---|---|---|
| Admin | `admin@doopler.local` | `doopler123` |

Admin panel: **http://localhost:3000/admin**

To grant premium access to a user: `/admin` → Users → Edit → check ✅ Premium.

## Useful commands

```sh
bin/dev                          # server + CSS watch
rails db:migrate                 # run new migrations
rails db:reset                   # recreate database from scratch
rails console                    # REPL with app context

# Simulate an expired post in the console
Post.last.update!(expires_at: 1.second.ago)
```

## Relevant folder structure

```
app/
  models/
    post.rb           # before_create sets expires_at; active?
    like.rb           # after_create_commit → +1h + Turbo broadcast
    user.rb           # Devise + admin/premium flags
  controllers/
    posts_controller.rb
    likes_controller.rb
  views/
    posts/
      _post.html.erb       # paywall logic (blur + overlay)
      _post_clock.html.erb # timer — Turbo Stream broadcast target
  javascript/
    controllers/
      countdown_controller.js  # Stimulus: live countdown
config/
  importmap.rails_admin.rb  # jspm.io pins for RailsAdmin
```

## Main routes

```
GET  /                      posts#index   (public)
GET  /posts/new             posts#new     (requires login)
POST /posts                 posts#create
POST /posts/:id/likes       likes#create  (requires login)
GET  /users/sign_in         devise
GET  /users/sign_up         devise
GET  /admin                 RailsAdmin (requires admin: true)
```

## Author

**Carlos Kvasir**

- LinkedIn: [linkedin.com/in/carloskvasir](https://linkedin.com/in/carloskvasir)
- Website: [kvasir.dev](https://kvasir.dev)

> To request **premium** access to Doopler, reach out on LinkedIn.
