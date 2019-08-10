class Admin::DashboardController < Admin::BaseController
  def index
    @admin_count = Administrator.all.size
  end
end
