class Admin::BaseController < ActionController::Base
  layout 'admin'

  protect_from_forgery with: :exception

  before_action :authenticate_admin!

  helper_method :current_admin

  private

  def authenticate_admin!
    redirect_to admin_login_path unless current_admin
  end

  def current_admin
    @_current_admin ||= session[:current_admin_id] && Administrator.find_by(id: session[:current_admin_id])
  end

  def admin_sign_in(admin)
    session[:current_admin_id] = admin.id
  end

  def admin_sign_out
    session[:current_admin_id] = nil
    @_current_admin = nil
  end
end
