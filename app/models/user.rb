class User < ApplicationRecord
  def getToken
    # uri = URI.parse "https://authz.dinero.dk/dineroapi/oauth/token" 
    # request = Net::HTTP::Post.new(uri)
    # request.basic_auth "ALCO", "SAGqbeheya6gKvuSstUemHB0fwJteZPTUC75TMKpNI" 
    # request["Accept"] = "application/x-www-form-urlencoded"
    # request.body = "grant_type=password&scope=read write&username=1f7ec76c2b4c418f802690a922d93226&password=1f7ec76c2b4c418f802690a922d93226"

    # req_options = {
    #   use_ssl: uri.scheme == "https",
    # }

    # response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    #   http.request request 
    # end

    
    #   api_token = JSON.parse response.body
  end
end
