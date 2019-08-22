module ApplicationHelper
  # Generate `{controller}-{action}-page` class for body element
  def body_class
    path = controller_path.tr('/_', '-')
    action_name_map = {
      index: 'index',
      new: 'edit',
      edit: 'edit',
      update: 'edit',
      patch: 'edit',
      create: 'edit',
      destory: 'index'
    }
    mapped_action_name = action_name_map[action_name.to_sym] || action_name
    body_class_page =
      if controller.is_a?(HighVoltage::StaticPage) && params.key?(:id) && params[:id] !~ /\A[-+]?[0-9]*\.?[0-9]+\Z/
        id_name = params[:id].tr('_', '-') + '-page'
        format('%s-%s-%s', path, action_name, id_name)
      else
        format('%s-%s-page', path, mapped_action_name)
      end

    body_class_page
  end

  # Admin active for helper
  def admin_active_for(controller_name, navbar_name)
    if controller_name.to_s == admin_root_path
      return controller_name.to_s == navbar_name.to_s ? "active" : ""
    end
    navbar_name.to_s.include?(controller_name.to_s) ? 'active' : ''
  end

  def current_path
    request.env['PATH_INFO']
  end

  def flash_class(level)
    case level
    when 'notice', 'success' then 'alert alert-success alert-dismissible'
    when 'info' then 'alert alert-info alert-dismissible'
    when 'warning' then 'alert alert-warning alert-dismissible'
    when 'alert', 'error' then 'alert alert-danger alert-dismissible'
    end
  end
end
