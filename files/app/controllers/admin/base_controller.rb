class Admin::BaseController < ActionController::Base
  layout 'admin'

  protect_from_forgery with: :exception

  before_action :authenticate_admin!

  helper_method :current_admin

  private

  def authenticate_admin!
    if current_admin.blank?
      redirect_to admin_login_path
      return
    end

    if current_admin.password_digest != session[:current_admin_token]
      redirect_to admin_login_path, alert: 'Password was changed, please log in again'
      return
    end
  end

  def current_admin
    @_current_admin ||= session[:current_admin_id] && Administrator.find_by(id: session[:current_admin_id])
  end

  def admin_sign_in(admin)
    session[:current_admin_id] = admin.id
    session[:current_admin_token] = admin.password_digest
  end

  def admin_sign_out
    session[:current_admin_id] = nil
    session[:current_admin_token] = nil
    @_current_admin = nil
  end
end
