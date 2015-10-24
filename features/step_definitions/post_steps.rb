Given(/^a public message$/) do
  # MK: I propose to use more meaningful variable names
  e = DiasporaFederation::Entities::StatusMessage.new({
    raw_message: 'Writing another test message from outside on september 18th', guid: SecureRandom.hex(16),
    diaspora_id: GeneratedData.instance.test_user_id, created_at: DateTime.now, public: true })
  @pkey = OpenSSL::PKey::RSA.new GeneratedData.instance.private_key
  @xml = DiasporaFederation::Salmon::Slap.generate_xml(GeneratedData.instance.test_user_id, @pkey, e)
end

Given(/^a private message$/) do
  @pkey = OpenSSL::PKey::RSA.new GeneratedData.instance.private_key
  @pubkey= OpenSSL::PKey::RSA.new @h_card.public_key
  e = DiasporaFederation::Entities::StatusMessage.new({ raw_message: 'text', guid: SecureRandom.hex(16), diaspora_id: GeneratedData.instance.test_user_id, created_at: DateTime.now,  public: false})
  @xml = DiasporaFederation::Salmon::EncryptedSlap.generate_xml(GeneratedData.instance.test_user_id, @pkey, e, @pubkey)
end

When(/^I send a public message$/) do
  # MK: Just speculating because I cannot test it myself right now, but have you tried it like this?
  #   RestClient.post("https://wk3.org/receive/public", @xml)
  @response = RestClient.post Config.instance.server_url + "/receive/public", {:xml => @xml}
end

When(/^I send a private message$/) do
  @response = RestClient.post Config.instance.server_url  + "/receive/users/#{@h_card.guid}", {:xml => @xml}
end
