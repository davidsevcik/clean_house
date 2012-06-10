module ApplicationHelper

  def flash_message
    out = []
    [:notice, :error, :alert].each do |level|
      unless flash[level].blank?
        flash_class = case level
          when :notice then "info"
          when :error then "error"
          when :alert then "warning"
        end

        out << content_tag(:div, class: "alert alert-#{flash_class}") do
          link_to('x', '#', :class => 'close', :'data-dismiss' => 'alert') + flash[level]
        end
      end
    end
    out.join("\n").html_safe
  end

end
