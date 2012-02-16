require "mylib/fblogin"

class LoginController < ApplicationController


  def getcode
    fb = Fblogin.new
    fb.app_id = "your app id"
    fb.app_secret = "your app secret"
    fb.canvas_url = "https://apps.facebook.com/your app name space/gettoken"
    fb.permission = "email,read_stream"
    redirect_to fb.dialogue_url
  end


  def gettoken
    if params[:code]
      fb = Fblogin.new
      fb.app_id = "your app id"
      fb.app_secret = "your app secret"
      fb.canvas_url = "https://apps.facebook.com/your app name space/gettoken"
      fb.permission = "read_stream user_photo"
      access_token = fb.access_token(params[:code])
      if access_token
        user = fb.userinfo(access_token)
        if user.has_key?('name')
          session[:user_name] = user['name']
          session[:user_fbid] = user['fbid']
          redirect_to main_url
        else
          render :text => "failed to fetch user info"
        end
      else
        render :text => "no token"
      end
    else
      render :text => "no code"
    end
  end

  def main
    @name = session[:user_name]
    @fbid = session[:user_fbid]
  end


end
