Rails.application.config.session_store :cookie_store,
  key: '_choi_atsu_session',
  secure: Rails.env.production?,
  same_site: :lax
  domain: :all