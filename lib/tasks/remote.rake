namespace :timely do
  task :daily do
    Timely.sync_clients
    Agreement.create_pending_invoices!
    Invoice.create_pending_remote_invoices!
    Timely.sync_paid_invoices
    Agrement.update_unpaid_status!
  end
end