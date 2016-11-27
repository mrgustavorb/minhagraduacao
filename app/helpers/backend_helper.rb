module BackendHelper

  # ===========================================
  def get_current_user
    if employee_signed_in?
      current_employee 
    elsif customer_signed_in?
      current_customer   
    end
  end

  # ===========================================
  def resource_name
    get_current_user.class.to_s.downcase
  end

  # ===========================================
  def build_path_to_user(action)
    case resource_name.to_s
      when 'employee' then 
        case action
          when 'edit' then edit_employee_registration_path
          when 'destroy_session' then destroy_employee_session_path
        end 
    end
  end

  # ===========================================
  def nav_link(link_text, link_path, link_controller, class_icon, link_groups = nil)

    class_current = current_page?(link_path) || compare_links_to_active(link_controller) ? 'active' : ''

    unless link_groups.is_a?(Array)

      html = <<-HTML

        <li>
          <a href="#{link_path}" class="#{class_current}">
            <i class="#{class_icon}"></i>
            <span>#{link_text}</span>
          </a>
        </li>

      HTML

    else

      class_current_parent = ""
      dropdown = ""
      link_groups.each do |item|

        if current_page?(item[1]) || compare_links_to_active(item[2])
          class_current_parent = 'active dcjq-parent'
        end

        class_current_sub_link = current_page?(item[1]) || compare_links_to_active(item[2]) ? 'active' : ''
        dropdown += "<li class='#{class_current_sub_link}'><a href='" + item[1] + "'>" + item[0] + "</a></li>"
      end

      html = <<-HTML
        <li class="sub-menu dcjq-parent-li">
          <a href="javascript:;" class="#{class_current_parent}">
            <i class="#{class_icon}"></i>
            <span>#{link_text}</span>
          </a>          
          <ul class="sub">
            #{dropdown}
          </ul>
        </li>
      HTML
    end

    html.html_safe
  end 
  
  # ===========================================
  def compare_links_to_active(link_controller)
    params[:controller] == link_controller
  end

  # ===========================================
  def list_error_model(model)
    
    html = ""
    if model.errors.any?

      list_erro = ""
      model.errors.full_messages.each do |msg|
        list_erro += "<li>#{msg}</li>"
      end

      html = <<-HTML
        <div class="alert alert-danger">
          <h4><strong>#{pluralize(model.errors.count, "error")}:</strong></h4>
          <ul>#{list_erro}</ul>
        </div>  
      HTML
    end

    html.html_safe
  end  

end
