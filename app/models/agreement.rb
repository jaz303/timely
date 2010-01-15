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
  
  has_many :log_items, :order => 'id DESC'
  has_many :invoices, :order => 'id DESC', :dependent => :destroy
  
  before_validation_on_create do |me|
    me.next_period_starts_on = me.start_date
  end
  
  after_create do |me|
    me.log_items.create(:action => 'created', :message => "Agreement ##{me.id} created")
  end
  
  after_destroy do |me|
    LogItem.create(:action => 'deleted', :message => "Agreement ##{me.id} deleted")
  end
  
  def invoicable?
    (Date.today + Timely.invoice_days_in_advance.days).to_date >= next_period_starts_on.to_date
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
  
  def create_pending_invoices!
    raise if new_record?
    while invoicable?
      today = Date.today
      payment_days = Timely.invoice_payment_days
      invoices.create!(:client_id     => client_id,
                       :dated_on      => today,
                       :payment_days  => payment_days,
                       :description   => invoice_line_for_next_period,
                       :reference     => "R-#{Sequence.next!}",
                       :amount        => amount,
                       :tax_rate      => tax_rate)
      self.next_period_starts_on += product.interval_duration
      save!
    end
  end
  
  def self.create_pending_invoices!
    invoicable.each(&:create_pending_invoices!)
  end
  
  def self.update_unpaid_status!
    update_all('unpaid = 0')
    Invoice.unpaid.each do |i|
      i.agreement.update_attribute(:unpaid, true)
    end
    nil
  end
end
