Given(/^a public message$/) do
  # MK: I propose to use more meaningful variable names
  e = DiasporaFederation::Entities::StatusMessage.new({
    raw_message: 'Writing another test message from outside on september 18th', guid: SecureRandom.hex(16),
    diaspora_handle: @diaspora_user, created_at: DateTime.now, public: true })
  @pkey = OpenSSL::PKey::RSA.new @private_key
  @xml = DiasporaFederation::Salmon::Slap.generate_xml(@diaspora_user, @pkey, e)


  puts "PUBLIC XML" + @xml

end

Given(/^a private message$/) do
  @pkey = OpenSSL::PKey::RSA.new @private_key
  @pubkey= OpenSSL::PKey::RSA.new @public_key
  e = DiasporaFederation::Entities::StatusMessage.new({ raw_message: 'text', guid: SecureRandom.hex(16), diaspora_handle: @diaspora_user, created_at: DateTime.now,  public: false})
  @xml = DiasporaFederation::Salmon::EncryptedSlap.generate_xml(@diaspora_user, @pkey, e, @pubkey)

  puts "PRIVATE XML" + @xml
end

When(/^I send a public message$/) do
  # MK: Just speculating because I cannot test it myself right now, but have you tried it like this?
  #   RestClient.post("https://wk3.org/receive/public", @xml)
  @response = RestClient.post @method + "://" + @server + "/receive/public", {:xml => @xml}
end

When(/^I send a private message$/) do
  @response = RestClient.post @method + "://" + @server + "/receive/users/#{@guid}", {:xml => @xml}
end
