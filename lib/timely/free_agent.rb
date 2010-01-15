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
    
    class ContactResource < ActiveResource::Base
      self.element_name = 'contact'
    end
    
    class InvoiceResource < ActiveResource::Base
      self.element_name = 'invoice'
      
      def paid?
        status.downcase == 'paid'
      end
    end
    
    class InvoiceItemResource < ActiveResource::Base
      self.element_name = 'invoice_item'
    end
    
    def self.init!
      raise unless account && username && password
      
      [ContactResource, InvoiceResource, InvoiceItemResource].each do |klass|
        klass.site = base_url
        klass.user = username
        klass.password = password
      end
      
      InvoiceItemResource.site += '/invoices/:invoice_id'
    end
    
    def self.base_url
      "https://#{@@account}.freeagentcentral.com"
    end
    
    def self.sync_clients
      
      clients = Client.find(:all).inject({}) { |m,c| m.update(c.remote_id.to_s => c) }
      
      ContactResource.find(:all).each do |contact|
        id, name = contact.id.to_s, contact.organisation_name
        if clients[id]
          clients[id].update_attributes(:name => name)
        else
          Client.create!(:name => name, :remote_id => id)
        end
      end
      
    end
    
    def self.create_invoice(invoice)
      ir = nil
      
      begin
        ir = InvoiceResource.create(:contact_id            => invoice.client.remote_id,
                                    :reference             => invoice.reference,
                                    :dated_on              => invoice.dated_on,
                                    :status                => 'Draft',
                                    :payment_terms_in_days => invoice.payment_days)

        if ir
          ilr = InvoiceItemResource.create(:invoice_id             => ir.id,
                                           :item_type              => 'Products',
                                           :quantity               => 1,
                                           :price                  => invoice.amount,
                                           :sales_tax_rate         => invoice.tax_rate,
                                           :description            => invoice.description)

          if ilr
            return ir.id.to_s
          else
            ir.destroy
            ir = nil
          end
        end
                                        
      rescue => e
        ir.destroy if ir
      end
      
      false
    end
    
    def self.sync_paid_invoices
      Invoice.unpaid.each do |invoice|
        begin
          if InvoiceResource.find(invoice.remote_id.to_i).paid?
            invoice.status = 'paid'
            invoice.save
          end
        rescue => e
        end
      end
      nil
    end
    
  end
end