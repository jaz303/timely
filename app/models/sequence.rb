class Sequence < ActiveRecord::Base
  def self.next!
    create!().id
  end
end
