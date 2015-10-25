When(/^I make a webfinger request with not existing user$/) do
  begin
    request_webfinger("lkasdjflasjiohsdfgj@" + Config.instance.server)
    false
  rescue => e
    @invalid_request = e.to_s
  end
end

When(/^I make a webfinger request to an existing diaspora pod$/) do
  @response = request_webfinger(Config.instance.diaspora_user)
end

Then(/^I should receive a valid webfinger document$/) do
  DiasporaFederation::Discovery::WebFinger.from_xml(@response)
end

Then(/^the document type should be XML$/) do
  @response.to_s.index("application/xrd+xml") == 0
end

Then(/^the webfinger document contains the link to the hcard$/) do
  @response.to_s.index("hcard") > 0
end

