Given(/^an existing webfinger document$/) do
  url = @method + '://' + @server + '//webfinger?q=acct:' + @diaspora_user
  # MK: Consider using interpolation vs. concatenation (throughout the project).
  # Not a must -- but more 'idiomatic'
  # http://stackoverflow.com/questions/10076579/string-concatenation-vs-interpolation-in-ruby
  @webfinger = Nokogiri::XML(open(url))
  # MK: I sould suggest to stricly separate responsibililties of RestClient (for requests) and Nokogiri (for parsing)
end

When(/^I make a hcard request with not existing user$/) do
  begin
    RestClient.get @method + '://' + @server + '/hcard/users/23@42@notvaliduser'
  rescue => e
    @invalid_request = e.to_s
  end
end

When(/^I make a hcard\-request$/) do
  @response = RestClient.get @webfinger.xpath('//xmlns:Link')[0].attr('href')
end

Then(/^the document should contain User profile$/) do
  @response.to_s.index("User profile") > 0
end

Then(/^I should receive a valid hcard document$/) do
  @h_card = DiasporaFederation::Discovery::HCard.from_html(@response)
end

