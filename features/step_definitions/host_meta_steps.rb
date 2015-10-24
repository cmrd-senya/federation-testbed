When(/^I send a host meta request to an existing diaspora pod$/) do
  @response = RestClient.get Config.instance.server_url + "/.well-known/host-meta"
end

# MK: What happens in this step does not reflect the name of the step
Then(/^it should contain a link to the webfinger document$/) do
  @webfinger_url = @response.to_s.rpartition(/(https?):((\/\/)|(\\\\))+[\w\d:\#\@\%\/;$()~_?\+-=\\\.&]*/)[-2] + Config.instance.diaspora_user
  RestClient.get @webfinger_url
end




