module Timely
  mattr_accessor :invoice_days_in_advance
  @@invoice_days_in_advance = 30
  
  mattr_accessor :adapter
  @@adapter = nil
  
  def self.init_adapter!
    @@adapter = @@adapter.constantize if @@adapter.is_a?(String)
    @@adapter.init!
  end
  
  def self.method_missing(method, *args, &block)
    adapter.send(method, *args, &block)
  end
  
  def self.create_invoices
    Agreement.invoicable.each do |agreement|
      while agreement.invoicable?
        if invoice_id = adapter.create_invoice(Date.today, agreement)
          agreement.invoiced!(invoice_id)
        else
          agreement.invoice_failed!
          break
        end
      end
    end
  end
end