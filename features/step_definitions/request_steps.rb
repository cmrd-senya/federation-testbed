When(/^a sharing request$/) do
  request = DiasporaFederation::Entities::Request.new({
    sender_id:    GeneratedData.instance.test_user_id,
    recipient_id: Config.instance.diaspora_user
  })

  @xml = generate_private_message(request)
end
