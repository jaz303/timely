class DashboardController < ApplicationController
  def index
    @activity = LogItem.find(:all, :limit => 30)
  end
end
