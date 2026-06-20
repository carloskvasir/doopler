import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["display"]
  static values = { expiresAt: String }

  connect() {
    this.tick()
    this.interval = setInterval(() => this.tick(), 1000)
  }

  disconnect() {
    clearInterval(this.interval)
  }

  tick() {
    if (!this.hasDisplayTarget) return

    const remaining = new Date(this.expiresAtValue) - Date.now()

    if (remaining <= 0) {
      this.displayTarget.textContent = "00:00:00"
      clearInterval(this.interval)
      return
    }

    const h = Math.floor(remaining / 3_600_000)
    const m = Math.floor((remaining % 3_600_000) / 60_000)
    const s = Math.floor((remaining % 60_000) / 1_000)

    this.displayTarget.textContent = [h, m, s]
      .map(n => String(n).padStart(2, "0"))
      .join(":")
  }
}
