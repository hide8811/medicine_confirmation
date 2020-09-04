class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[employee_id last_name first_name last_name_kana first_name_kana status])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:employee_id])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[employee_id last_name first_name last_name_kana first_name_kana status])
  end
end
