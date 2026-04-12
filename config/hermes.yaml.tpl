# Agent config template — values injected from env vars via envsubst
model:
  provider: openrouter
  model: openrouter/z-ai/glm-5.1
  api_key: ${OPENROUTER_API_KEY}
  temperature: 0.7
  max_tokens: 4096

telegram:
  bot_token: ${TELEGRAM_BOT_TOKEN}
  allowed_topics:
    - 13
    - 10

memory:
  type: persistent
  path: /data/memory

identity:
  name: Reeve
  role: Career steward
