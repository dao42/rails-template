class Admin::SessionsController < Admin::BaseController
  skip_before_action :authenticate_admin!, only: [:new, :create]

  before_action do
    @full_render = true
  end

  def new
  end

  def create
    admin = Administrator.find_by(name: params[:name])
    if admin && admin.authenticate(params[:password])
      admin_sign_in(admin)
      redirect_to admin_root_path
    else
      flash.now[:alert] = 'Username or password is wrong'
      render 'new'
    end
  end

  def destroy
    admin_sign_out
    redirect_to admin_login_path
  end
end
