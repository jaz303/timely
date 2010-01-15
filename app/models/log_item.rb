class LogItem < ActiveRecord::Base
  ACTIONS = {
    'created'       => 'add',
    'deleted'       => 'delete',
    'error'         => 'error',
    'invoiced'      => 'table_add'
  }.freeze
  
  default_scope :order => 'id DESC'
  
  belongs_to :agreement

  validates_inclusion_of :action, :in => ACTIONS.keys, :allow_nil => true
  validates_presence_of :message
  
  def action_icon
    action ? ACTIONS[action] : nil
  end
end
