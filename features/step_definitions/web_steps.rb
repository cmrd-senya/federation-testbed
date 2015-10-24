Given(/^an existing user account diaspora_user$/) do 
  GeneratedData.instance
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

