app_name = "ninjachoice"
app_path = "/var/www/rails/#{app_name}"
working_directory "#{app_path}/current"
pid "#{app_path}/shared/pids/unicorn-#{app_name}.pid"
stderr_path "#{app_path}/shared/log/unicorn-#{app_name}.log"
stdout_path "#{app_path}/shared/log/unicorn-#{app_name}.log"
 
preload_app true
 
listen "/tmp/unicorn.#{app_name}.sock"
worker_processes 4
timeout 30
 
before_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!
end
 
after_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end