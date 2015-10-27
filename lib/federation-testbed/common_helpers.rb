def request_webfinger(account)
  RestClient.get Config.instance.server_url + "/webfinger?q=acct:" + account
end

def request_and_parse_webfinger(account)
  DiasporaFederation::Discovery::WebFinger.from_xml(request_webfinger(account))
end

def request_hcard(webfinger)
  RestClient.get webfinger.hcard_url
end

def request_and_parse_hcard(webfinger)
  DiasporaFederation::Discovery::HCard.from_html(request_hcard(webfinger))
end

def generate_public_message(entity)
  pkey = OpenSSL::PKey::RSA.new GeneratedData.instance.private_key
  DiasporaFederation::Salmon::Slap.generate_xml(GeneratedData.instance.test_user_id, pkey, entity)
end

def generate_private_message(entity)
  pkey = OpenSSL::PKey::RSA.new GeneratedData.instance.private_key
  pubkey= OpenSSL::PKey::RSA.new @h_card.public_key
  DiasporaFederation::Salmon::EncryptedSlap.generate_xml(GeneratedData.instance.test_user_id, pkey, entity, pubkey)
end
