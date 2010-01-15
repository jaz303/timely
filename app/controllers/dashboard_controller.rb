class DashboardController < ApplicationController
  def index
    @overdue = Invoice.overdue
    @activity = LogItem.find(:all, :limit => 30)
  end
end
