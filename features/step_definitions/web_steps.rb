Given(/^an existing user account at the testbed$/) do
  GeneratedData.instance.roll
end

Given(/^an existing server$/) do
  Config.instance
end

Then(/^the status code should be success$/) do
  @response.code != 200
end

Then(/^the status code should be not found$/) do
  @invalid_request.include? "404 Resource not found"
end

