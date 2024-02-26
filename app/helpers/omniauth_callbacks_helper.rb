module OmniauthCallbacksHelper
  def omniauth_failure_message
    if request.env["omniauth.error.type"]
      I18n.t("devise.omniauth_callbacks.failure", kind: failed_strategy_name, reason: failure_reason)
    else
      I18n.t("devise.omniauth_callbacks.unknown_error")
    end
  end

  private

    def failed_strategy_name
      request.env["omniauth.error.strategy"].name.to_s.humanize if request.env["omniauth.error.strategy"]
    end

    def failure_reason
      I18n.t("devise.omniauth_callbacks.errors.#{request.env["omniauth.error.type"]}", default: :unknown_error)
    end
end
