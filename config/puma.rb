# /var/www/backend/config/puma.rb

threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }.to_i
threads threads_count, threads_count

port ENV.fetch("PORT") { 3000 }

environment ENV.fetch("RAILS_ENV") { "production" }

app_dir = File.expand_path("../..", __FILE__)
directory app_dir

# Socket folder
socket_dir = "#{app_dir}/tmp/sockets"
pidfile "#{app_dir}/tmp/pids/puma.pid"
state_path "#{app_dir}/tmp/pids/puma.state"

bind "unix://#{socket_dir}/puma.sock"

workers ENV.fetch("WEB_CONCURRENCY") { 2 }

preload_app!

plugin :tmp_restart
