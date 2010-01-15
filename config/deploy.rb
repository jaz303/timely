set :application, "timely"

default_run_options[:pty] = true
set :use_sudo, false
ssh_options[:forward_agent] = true
set :deploy_via, :remote_cache
set :keep_releases, 3

set :scm, "git"
set :branch, "master"
set :git_shallow_clone, 1
set :git_enable_submodules, 1
set :repository, "git://github.com/jaz303/timely.git"

set :user, "rails"
role :app, "..."
role :web, "..."
role :db, "...", :primary => true
set :deploy_to, "..."

after "deploy:update_code", :symlink_config
after "deploy:update_code", :link_rdig_index

task :symlink_config do
  %w(database.yml environments/production.rb).each do |file|
    run "ln -nfs #{shared_path}/config/#{file} #{release_path}/config/#{file}"
  end
end

namespace :deploy do

  task :restart, :roles => :app, :except => {:no_release => true} do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start,:stop].each do |t|
    desc "#{t} task does nothing when using mod_rails"
    task t, :roles => :app do; end
  end
  
end