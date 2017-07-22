class User < ActiveRecord::Base
  class << self
    def find_or_create_from_omniauth(omniauth)
      u = User.find_by_instagram_uid(omniauth['uid'].to_s)
      u = User.new unless u
      u.instagram_uid = omniauth['uid'].to_i
      u.name = omniauth['info']['name']
      u.nick_name = omniauth['info']['nickname']
      u.profile_picture = omniauth['info']['image']
      u.instagram_token = omniauth['credentials']['token']
      u.save
      return u
    end
  end
end
