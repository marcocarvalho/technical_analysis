set :application, "technical_analysis"
set :repository,  "git@github.com:marcocarvalho/technical_analysis.git"

set :scm, :git
set :copy_exclude, [".git/*", ".svn/*", ".DS_Store"]
ssh_options[:forward_agent] = true

role :app, "digital"                          # This may be the same as your `Web` server

set :deploy_via, :remote_cache
set :user, "ubuntu"

set :branch, 'master'
set :deploy_to, '/var/app/'
after "deploy:update_code", "deploy:migrate"
