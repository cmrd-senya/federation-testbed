When(/^a sharing request$/) do
  request = DiasporaFederation::Entities::Request.new({
    sender_id:    GeneratedData.instance.test_user_id,
    recipient_id: Config.instance.diaspora_user
  })

  @pkey = OpenSSL::PKey::RSA.new GeneratedData.instance.private_key
  @pubkey= OpenSSL::PKey::RSA.new @h_card.public_key
  @xml = DiasporaFederation::Salmon::EncryptedSlap.generate_xml(GeneratedData.instance.test_user_id, @pkey, request, @pubkey)
end
