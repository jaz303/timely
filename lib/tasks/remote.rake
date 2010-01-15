namespace :timely do
  task :sync_clients => :environment do
    Timely.sync_clients
  end
  
  task :create_invoices => :environment do
    Timely.create_invoices
  end
end