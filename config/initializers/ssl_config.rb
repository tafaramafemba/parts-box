require 'certifi'
OpenSSL::SSL::SSLContext::DEFAULT_CERT_STORE.add_file(Certifi.where)
