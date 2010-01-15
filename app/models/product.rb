class Product < ActiveRecord::Base
  INTERVALS = %w(month year).freeze
  
  validates_presence_of :code
  validates_uniqueness_of :code
  
  validates_presence_of :name
  
  validates_presence_of :amount
  validates_numericality_of :amount
  
  validates_presence_of :tax_rate
  validates_format_of :tax_rate, :with => /^\d+(\.\d+)?$/
  
  validates_inclusion_of :interval, :in => INTERVALS
  
  has_many :agreements
  before_destroy :ensure_no_agreements
  
  def to_s
    name
  end
  
  def interval_duration
    case interval
    when 'month' then 1.month
    when 'year' then 1.year
    else raise
    end
  end
  
  def summary
    "#{code} - #{name}"
  end
  
private

  def ensure_no_agreements
    agreements.empty?
  end
end
