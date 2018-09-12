require 'rake'
require 'ig_api'
require 'rest-client'
require_relative 'app/endpoints/user_info'
require_relative 'app/endpoints/media_info'
require_relative 'app/endpoints/instagram'




task :test do
  RestClient.proxy ='http://127.0.0.1:8888'
  insta = Instagram.new('slk_ubozhenko','8mbnDo42')
  user_info = MediaInfo.new.media_comments('1865952326990492905_55224114')
  user
end




