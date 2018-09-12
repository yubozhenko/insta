require_relative 'instagram'

class UserInfo < Instagram

  def search_by_query(query)
    JSON.parse HttpClient.get(Defaults::URL+"users/search/?ig_sig_key_version=
#{Defaults::PRIVATE_KEY[:APP_VERSION]}&is_typeahead=true&query=#{query}&rank_token=#{@@rank_token}",
                   @@headers).body
  end

  def info_by_username(user_name)
    JSON.parse HttpClient.get(Defaults::URL+"users/#{user_name}/usernameinfo/?&rank_token=#{@@rank_token}",@@headers).body
  end

  def user_followers(user_name)
    followers = []
    user_id = info_by_username(user_name)['user']['pk']
    resp = JSON.parse HttpClient.get(Defaults::URL+"friendships/#{user_id}/followers/?rank_token=#{@@rank_token}",
                              @@headers).body
    followers += resp['users']
    while resp['next_max_id']
      resp = JSON.parse HttpClient.get(Defaults::URL+"friendships/#{user_id}/followers/?rank_token=#{@@rank_token}&max_id=#{resp['next_max_id']}",
                                       @@headers).body
      followers += resp['users']
      sleep(1)
    end
    followers
  end
end