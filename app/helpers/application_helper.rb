# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def button_link_to(text, url, options = {})
    options[:class] ||= ''
    options[:class] << ' button'
    link_to("<span>#{text}</span>", url, options)
  end
  
  def icon(name, options = {})
    if name.nil?
      ''
    else
      options[:class] ||= ''
      options[:class] << ' icon'
      image_tag("icons/#{name}.png", options)
    end
  end
  
  def invoice_status(invoice)
    if invoice.paid?
      icon(:tick) + " <b style='color:green'>Paid</b>"
    elsif invoice.overdue?
      icon(:error) + " <b style='color:orange'>OVERDUE</b>"
    else
      icon(:cross) + " <b style='color:red'>Unpaid</b>"
    end
  end
  
  def autolink_log_item(item)
    msg = item.message
    msg.gsub!(/agreement \#(\d+)/i) { |m| link_to(m, agreement_path($1.to_i))}
    msg
  end
end
