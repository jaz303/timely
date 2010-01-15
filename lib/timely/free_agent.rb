module Timely
  module FreeAgent
    
    mattr_accessor :account
    @@account = nil
    
    mattr_accessor :username
    @@username = nil
    
    mattr_accessor :password
    @@password = nil
    
    mattr_accessor :payment_terms_in_days
    @@payment_terms_in_days = 30
    
    class Contact < ActiveResource::Base
      self.element_name = 'contact'
    end
    
    class Invoice < ActiveResource::Base
      self.element_name = 'invoice'
    end
    
    class InvoiceItem < ActiveResource::Base
      self.element_name = 'invoice_item'
    end
    
    def self.init!
      raise unless account && username && password
      
      [Contact, Invoice, InvoiceItem].each do |klass|
        klass.site = base_url
        klass.user = username
        klass.password = password
      end
      
      InvoiceItem.site += '/invoices/:invoice_id'
    end
    
    def self.base_url
      "https://#{@@account}.freeagentcentral.com"
    end
    
    def self.sync_clients
      
      clients = Client.find(:all).inject({}) { |m,c| m.update(c.remote_id.to_s => c) }
      
      Contact.find(:all).each do |contact|
        id, name = contact.id.to_s, contact.organisation_name
        if clients[id]
          clients[id].update_attributes(:name => name)
        else
          Client.create!(:name => name, :remote_id => id)
        end
      end
      
    end
    
    def self.create_invoice(invoice_date, agreement)
      
      if rand > 0.5
        return "R-#{rand(100)}"
      else
        return false
      end
      
      invoice = Invoice.create(:contact_id              => agreement.client.remote_id,
                               :reference               => "R-#{Sequence.next!}",
                               :dated_on                => invoice_date,
                               :status                  => 'Draft',
                               :payment_terms_in_days   => payment_terms_in_days)
      
      if invoice
        line = InvoiceItem.create(:invoice_id       => invoice.id,
                                  :item_type        => 'Products',
                                  :quantity         => 1,
                                  :price            => agreement.amount,
                                  :sales_tax_rate   => agreement.tax_rate,
                                  :description      => agreement.invoice_line_for_next_period)
        
        if line
          return invoice.id.to_s if line
        else
          invoice.destroy
        end
      end
      
      false
    end
    
  end
end