# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

desc "Pings PING_URL to keep a dyno alive"
task :dyno_ping do
  require "net/http"

  if ENV['PING_URL']
	uri = URI(ENV['PING_URL'])
	Net::HTTP.get_response(uri)
  end
end