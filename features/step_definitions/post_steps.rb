Given(/^a public message$/) do
  entity = DiasporaFederation::Entities::StatusMessage.new({
    raw_message: 'Writing another test message from outside on september 18th', guid: SecureRandom.hex(16),
    diaspora_id: GeneratedData.instance.test_user_id, created_at: DateTime.now, public: true })
  @xml = generate_public_message(entity)
end

Given(/^a private message$/) do
  entity = DiasporaFederation::Entities::StatusMessage.new({ raw_message: 'text', guid: SecureRandom.hex(16), diaspora_id: GeneratedData.instance.test_user_id, created_at: DateTime.now,  public: false})
  @xml = generate_private_message(entity)
end

When(/^I send a public message$/) do
  # MK: Just speculating because I cannot test it myself right now, but have you tried it like this?
  #   RestClient.post("https://wk3.org/receive/public", @xml)
  @response = RestClient.post Config.instance.server_url + "/receive/public", {:xml => @xml}
end

When(/^I send a private message$/) do
  @response = RestClient.post Config.instance.server_url  + "/receive/users/#{@h_card.guid}", {:xml => @xml}
end
