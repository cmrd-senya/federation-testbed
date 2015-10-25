Given(/^an existing user account at the testbed$/) do
  GeneratedData.instance.roll
end

Given(/^an existing server$/) do
  Config.instance
end

Given(/^we discovered a user from our target$/) do
  @webfinger = request_and_parse_webfinger(Config.instance.diaspora_user)
  @h_card = request_and_parse_hcard(@webfinger)
end

Then(/^the status code should be success$/) do
  @response.code != 200
end

Then(/^the status code should be not found$/) do
  @invalid_request.include? "404 Resource not found"
end

