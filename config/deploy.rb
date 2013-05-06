# require "bundler/capistrano"

set :application, "technical_analysis"
set :repository,  "git@github.com:marcocarvalho/technical_analysis.git"

set :scm, :git
set :copy_exclude, [".git/*", ".svn/*", ".DS_Store"]
ssh_options[:forward_agent] = true

role :app, "digital"
role :db, "digital"

# set :deploy_via, :remote_cache
set :normalize_asset_timestamps, false
set :user, "ubuntu"
set :use_sudo, false

set :branch, 'master'
set :deploy_to, '/var/app/technical_analysis'
# after "deploy:update_code", "deploy:migrate"
