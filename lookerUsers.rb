

require 'uri'
require 'net/http'
require 'json'

##get auth code

#replace with your accurate client id and secret
def auth_looker
  client_id= 'ID GOES HERE'
  client_secret= 'SECRET GOES HERE'
uri = URI.parse("https://procore.looker.com:19999/login")
request = Net::HTTP::Post.new(uri)

request.body = "client_id=#{client_id}&client_secret=#{client_secret}"

req_options = {
  use_ssl: uri.scheme == "https",
}

response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
  http.request(request)
end
hash = JSON.parse(response.body, symbolize_names: true)
$token_value = hash[:access_token]
$token_type = hash[:token_type]
end

auth_looker()


url = URI("https://procore.looker.com:19999/api/3.0/users")

http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true

request = Net::HTTP::Get.new(url)
request["Accept"] = 'application/json'
request["Content-Type"] = 'application/json'
request["Authorization"] = "#{$token_type} #{$token_value}"
request["Cache-Control"] = 'no-cache'
response = http.request(request)
hash = JSON.parse(response.body, symbolize_names: true)

puts "email\tis_disabled"
puts "Total users found: #{hash.count}"
hash.each do |x|
  puts "#{x[:email]}\t#{x[:is_disabled]}"
end


