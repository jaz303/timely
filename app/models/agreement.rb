class Agreement < ActiveRecord::Base
  named_scope :invoicable do
    cutoff = (Date.today + Timely.invoice_days_in_advance.days).to_date
    { :conditions => ['next_period_starts_on <= ?', cutoff] }
  end
  
  named_scope :by_next_period, :order => 'next_period_starts_on ASC',
                               :include => [:client, :product]
  named_scope :by_client, :order => 'clients.name ASC, description ASC',
                          :include => [:client, :product]
    
  belongs_to :client
  validates_presence_of :client_id
  
  belongs_to :product
  validates_presence_of :product_id
  
  validates_presence_of :description
  
  validates_presence_of :start_date
  
  validates_presence_of :next_period_starts_on
  attr_protected :next_period_starts_on
  
  has_many :log_items, :dependent => :destroy, :order => 'created_at DESC'
  
  before_validation_on_create do |me|
    me.next_period_starts_on = me.start_date
  end
  
  after_create do |me|
    me.log_items.create(:action => 'created', :message => "Agreement ##{me.id} created")
  end
  
  def invoicable?
    (Date.today + Timely.invoice_days_in_advance.days).to_date >= next_period_starts_on.to_date
  end
  
  def invoiced!(invoice_id)
    raise if new_record?
    self.next_period_starts_on += product.interval_duration
    save!
    log_items.create(:action => 'invoiced',
                     :message => "Invoice #{invoice_id} created for Agreement ##{id}")
  end
  
  def invoice_failed!
    log_items.create(:action => 'error', :message => "Failed to create invoice for Agreement ##{id}")
  end
  
  def amount
    product.amount
  end
  
  def tax_rate
    product.tax_rate
  end
  
  def invoice_line_for_next_period
    start_date = next_period_starts_on
    end_date   = start_date + product.interval_duration - 1.day
    "#{product.code} - #{description} (#{start_date.to_s(:short)} - #{end_date.to_s(:short)})"
  end
end
