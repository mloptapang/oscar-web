set :stage, 'production'
set :rails_env, :production
set :appsignal_env, :production
set :branch, proc { `git rev-parse --abbrev-ref stable-after-caching`.chomp }
# TODO: Deploy one after another by commentting out one

# OSCaR
server '52.221.46.112', user: 'deployer', roles: %w{app web db}
