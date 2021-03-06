class ApplicationController < ActionController::Base

  before_action :set_locale
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def default_url_options
    { lang: (I18n.locale if I18n.locale != I18n.default_locale) }
  end

  protected

  def set_locale
    I18n.locale_available?(params[:lang]) ? params[:lang] : I18n.default_locale
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
  end

  def after_sign_in_path_for(user)
    flash[:notice] = t('devise.sessions.signed_in_welcome_message',
                       user_full_name: current_user.full_name.html_safe)
    if user.admin?
      admin_tests_path
    else
      flash[:notice] = "Hello, #{current_user.full_name.html_safe}!"
      tests_path
    end
  end



end
