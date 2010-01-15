# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def button_link_to(text, url, options = {})
    options[:class] ||= ''
    options[:class] << ' button'
    link_to("<span>#{text}</span>", url, options)
  end
  
  def icon(name)
    if name.nil?
      ''
    else
      image_tag("icons/#{name}.png", :class => "icon")
    end
  end
  
  def autolink_log_item(item)
    msg = item.message
    msg.gsub!(/agreement \#(\d+)/i) { |m| link_to(m, agreement_path($1.to_i))}
    msg
  end
end
