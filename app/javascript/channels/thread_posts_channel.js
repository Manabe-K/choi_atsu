import { createConsumer } from "@rails/actioncable"

const consumer = createConsumer()

document.addEventListener("turbo:load", () => {
  const container = document.getElementById("thread_posts")
  if (!container) return

  const eventId = container.dataset.eventId
  if (!eventId) return

  consumer.subscriptions.create(
    { channel: "ThreadPostsChannel", event_id: eventId },
    {
      connected() {
        console.log("✅ Connected to ThreadPostsChannel")
      },
      disconnected() {
        console.log("🔌 Disconnected from ThreadPostsChannel")
      },
      received(data) {
        console.log("📡 Data received from ActionCable")
      }
    }
  )
})