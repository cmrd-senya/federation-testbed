Given(/^an existing webfinger document$/) do
  @webfinger = request_and_parse_webfinger(Config.instance.diaspora_user)
end

When(/^I make a hcard request with not existing user$/) do
  begin
    RestClient.get Config.instance.server_url + '/hcard/users/23@42@notvaliduser'
    false
  rescue => e
    @invalid_request = e.to_s
  end
end

When(/^I make a hcard\-request$/) do
  @response = request_hcard(@webfinger)
end

Then(/^the document should contain User profile$/) do
  @response.to_s.index("User profile") > 0
end

Then(/^I should receive a valid hcard document$/) do
  @h_card = DiasporaFederation::Discovery::HCard.from_html(@response)
end

