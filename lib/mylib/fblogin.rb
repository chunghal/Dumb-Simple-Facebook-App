require "net/http"

class Fblogin
  #These are class instance variables, attr_accessor makes dedicated getters and setters for you
  attr_accessor :app_id,:app_secret,:canvas_url, :permission
  
  #Generate url that will redirect user to OAuth Dialogue. The canvas url should start by https:// and end with a slash.
  #If you're building an facebook app, the canvas_url should be something like https://apps.facebook.com/yourapp_namespace/yourapp_action
  def dialogue_url
    return "https://www.facebook.com/dialog/oauth?client_id="+@app_id+"&redirect_uri="+@canvas_url+"&scope="+@permission
  end
  
  #This will fetch the access_token given the code from the call_back of dialog_url
  def access_token(code)
    token_url = "https://graph.facebook.com/oauth/access_token?client_id="+@app_id+"&redirect_uri="+canvas_url+"&client_secret="+app_secret+"&code="+code

    uri = URI.parse(URI.encode(token_url))
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    access_token = response.body
    if access_token.index('{')==0
      return nil
    else
      return access_token[13...access_token.length]
    end
    
  end
  
  #This will return some basic information of user
  def userinfo(access_token)    
    querystr = "https://graph.facebook.com/me?access_token="+access_token

    uri = URI.parse(URI.encode(querystr))
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    result = JSON.parse(response.body)
    myinfo = {}
    if result['name']
      myinfo['name']=result['name']
      myinfo['fbid']=result['id']
    end
    return myinfo
  end
  
end