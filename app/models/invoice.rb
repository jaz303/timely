class Invoice < ActiveRecord::Base
  STATUSES = %w(unpaid paid).freeze
  
  named_scope :without_remote_invoices, :conditions => 'remote_id IS NULL'
  named_scope :unpaid, :conditions => {:status => 'unpaid'}
  named_scope :overdue do
    { :conditions => ["status = 'unpaid' AND ? > due_on", Date.today] }
  end
  
  belongs_to :client
  validates_presence_of :client_id
  
  belongs_to :agreement
  validates_presence_of :agreement_id
  
  validates_presence_of :reference
  validates_uniqueness_of :reference
  
  validates_presence_of :description
  
  validates_presence_of :amount, :tax_rate
  
  validates_presence_of :dated_on, :due_on, :payment_days
  
  validates_inclusion_of :status, :in => STATUSES
  
  def paid?
    status == 'paid'
  end
  
  def unpaid?
    status == 'unpaid'
  end
  
  def overdue?
    unpaid? && Date.today > due_on
  end
  
  before_validation do |me|
    unless me.dated_on.nil?
      me.due_on = me.dated_on + me.payment_days.days
    end
  end
  
  after_create do |me|
    me.agreement.log_items.create(:action => 'invoiced',
                                  :message => "Invoice #{me.reference} created for Agreement ##{me.agreement.id}")
  end
  
  def remote_invoice_created?
    !remote_id.nil?
  end
  
  def create_remote_invoice!
    raise if new_record?
    unless remote_invoice_created?
      if remote_id = Timely.create_invoice(self)
        update_attribute(:remote_id, remote_id)
      else
        agreement.log_items.create(:action => "error",
                                   :message => "Failed to create remote invoice for Agreement ##{agreement.id}")
      end
    end
    remote_invoice_created?
  end
  
  def self.create_pending_remote_invoices!
    without_remote_invoices.each(&:create_remote_invoice!)
    nil
  end
end
