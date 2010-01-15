class Client < ActiveRecord::Base
  default_scope :order => 'active DESC, name ASC'
  named_scope :active, :conditions => {:active => true}
  
  validates_presence_of :remote_id
  validates_uniqueness_of :remote_id
  
  validates_presence_of :name
  
  has_many :agreements
  before_destroy :ensure_no_agreements
  
  def to_s
    name
  end
  
private

  def ensure_no_agreements
    agreements.empty?
  end
end
