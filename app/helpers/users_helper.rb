module UsersHelper
  
  def gravatar_for(user, size = 50)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "http://gravatar.com/avatar/#{gravatar_id}.png"
    image_tag(gravatar_url, alt: user.name, class: "gravatar", :size => size)
  end
  
end
