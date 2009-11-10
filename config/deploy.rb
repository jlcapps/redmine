set :application, "redmine"
set :user, "git"
set :repository, "git://github.com/jlcapps/redmine.git"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/home/git/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
set :scm, :git

role :app, "git.cteresource.org"
role :web, "git.cteresource.org"
role :db,  "git.cteresource.org", :primary => true

set :use_sudo, false
default_run_options[:pty] = true

# task which causes Passenger to initiate a restart 
namespace :deploy do 
  task :restart do 
    run "touch #{current_path}/tmp/restart.txt" 
  end 
end 

# reconfigure databases 
after "deploy:update_code", :configure_database 
desc "copy database.yml into the current release path" 
task :configure_database, :roles => :app do 
  db_config = "#{current_path}/config/database.yml" 
  run "cp #{db_config} #{release_path}/config/database.yml" 
end 

# reconfigure email 
after "deploy:update_code", :configure_email 
desc "copy email.yml into the current release path" 
task :configure_email, :roles => :app do 
  email_config = "#{current_path}/config/email.yml" 
  run "cp #{email_config} #{release_path}/config/email.yml" 
end 

# reconfigure session secret 
after "deploy:update_code", :configure_secret 
desc "copy secret into the current release path" 
task :configure_secret, :roles => :app do 
  secret = "#{current_path}/config/secret" 
  run "cp #{secret} #{release_path}/config/secret" 
end 
