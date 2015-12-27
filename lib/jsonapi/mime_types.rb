module JSONAPI
  MEDIA_TYPE = 'application/vnd.api+json'
end

Mime::Type.register JSONAPI::MEDIA_TYPE, :api_json

mime_type = Mime::Type.lookup(JSONAPI::MEDIA_TYPE)

if Rails::VERSION::MAJOR >= 5
  ActionDispatch::Http::Parameters::DEFAULT_PARSERS[mime_type] = lambda do |body|
    JSON.parse(body)
  end
else
  ActionDispatch::ParamsParser::DEFAULT_PARSERS[mime_type] = lambda do |body|
    data = JSON.parse(body)
    data = {:_json => data} unless data.is_a?(Hash)
    data.with_indifferent_access
  end
end
