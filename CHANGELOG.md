# Changelog

Format based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Versions follow [Semantic Versioning](https://semver.org/).

---

## [Unreleased]

## [0.1.0] — 2026-06-20

### Added

- **Doopler Effect mechanic**: posts start with 2h of life; each Like extends it by +1h
- **Expiry paywall**: expired content is blurred (`blur-md`) for non-premium users, with a LinkedIn CTA overlay
- **Authentication** via Devise (registration, login, logout, password recovery)
- **User flags**: `admin` and `premium` both defaulting to `false`
- **RailsAdmin** protected by `admin: true` at `/admin` — premium access granted manually
- **Real-time Turbo Stream broadcast**: Like updates the post timer for all viewers via Action Cable
- **Stimulus `countdown_controller`**: live `HH:MM:SS` countdown on the client
- **SQLite3 at `/dev/shm`** in development for in-RAM I/O
- Admin user seed (`admin@doopler.local`)
- Responsive dark navbar with contextual actions (signed in / signed out)
- `Doopler::VERSION` constant read from the `VERSION` file

### Technical

- Ruby 4.0.5 via mise; `.ruby-version` aligned
- Rails 8.1.3, Propshaft, Importmap
- `config/importmap.rails_admin.rb` with jspm.io pins for RailsAdmin 3 + Importmap

[Unreleased]: https://github.com/carloskvasir/doopler/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/carloskvasir/doopler/releases/tag/v0.1.0
