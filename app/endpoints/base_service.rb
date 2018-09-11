require_relative '../../lib/http_client'
require_relative '../../lib/device_generator'
require_relative '../../app/const/defaults'
class BaseService

  # cattr_accessor logged_user

  def login(username, password, config = IgApi::Configuration.new)
    generator = DeviceGenerator.new(username)
    request = HttpClient.post(Defaults::URL + 'accounts/login/',format(
        'ig_sig_key_version=4&signed_body=%s',
        generator.generate_signature(
            device_id: generator.device_id,
            login_attempt_user: 0, password: password, username: username,
            _csrftoken: 'missing', _uuid: generator.generate_uuid
        ), {ua: generator.useragent}
    ))


    json_body = JSON.parse request.body

    raise json_body['message'] if json_body['status'] == 'fail'

    logged_in_user = json_body['logged_in_user']

    user.data = {
        id: logged_in_user['pk'],
        full_name: logged_in_user['full_name'],
        is_private: logged_in_user['is_private'],
        profile_pic_url: logged_in_user['profile_pic_url'],
        profile_pic_id: logged_in_user['profile_pic_id'],
        is_verified: logged_in_user['is_verified'],
        is_business: logged_in_user['is_business']
    }
    cookies_array = []
    all_cookies = request.get_fields('set-cookie')
    all_cookies.each do |cookie|
      cookies_array.push(cookie.split('; ')[0])
    end
    cookies = cookies_array.join('; ')
    user.config = config
    user.session = cookies

    user
  end
end