require_relative '../../lib/http_client'
require_relative '../../lib/device_generator'
require_relative '../../app/const/defaults'
require 'active_support'
class Instagram

  cattr_accessor :logged_user, :rank_token

  def initialize(username=nil,password=nil)
    unless @@logged_user
      @@headers = {
          'User-Agent': nil,
          Accept: Defaults::HEADER[:accept],
          'Accept-Encoding': Defaults::HEADER[:encoding],
          'Accept-Language': 'en-US',
          'X-IG-Capabilities': Defaults::HEADER[:capabilities],
          'X-IG-Connection-Type': Defaults::HEADER[:type],
          Cookie: nil
      }
      @@logged_user = login(username,password)
    end
  end

  def current_user_info
    HttpClient.get(Defaults::URL + "users/#{@@logged_user['pk']}/info/",@@headers)
  end

  def login(username, password)
    generator = DeviceGenerator.new(username)
    @@headers[:'User-Agent'] = generator.user_agent
    response = HttpClient.post(Defaults::URL + 'accounts/login/', format(
        'ig_sig_key_version=4&signed_body=%s',
        generator.generate_signature(
            device_id: generator.device_id,
            login_attempt_user: 0, password: password, username: username,
            _csrftoken: 'missing', _uuid: generator.generate_uuid
        )), {'User-Agent' => @@headers[:'User-Agent']}
    )
    json_body = JSON.parse response.body
    raise json_body['message'] if json_body['status'] == 'fail'
    str = ''
    response.cookies.each do |k, v|
      str+="#{k}=#{v}; "
    end
    @@headers[:Cookie] = str
    @@rank_token = generator.generate_rank_token(json_body['logged_in_user']['pk'])
    json_body['logged_in_user']
  end


end