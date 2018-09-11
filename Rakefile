require 'rake'
require 'ig_api'
require_relative 'app/endpoints/base_service'


task :test do
  BaseService.new.login('slk_ubozhenko','8mbnDo42')
  user = IgApi::Account.new.login('slk_ubozhenko','8mbnDo42')
  user
end




