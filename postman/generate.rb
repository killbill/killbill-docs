require 'json'
require 'logger'
require 'pathname'
require 'securerandom'

def generate_collection(logger)
  collection = {
      'id' => SecureRandom.uuid.to_s,
      'name' => 'Kill Bill',
      'description' => '',
      'order' => [],
      'folders' => [],
      'timestamp' => 0,
      'owner' => '0',
      'remoteLink' => '',
      'public' => false,
      'requests' => []
  }

  # Populate folders
  Dir[Pathname.new(File.dirname(__FILE__)).join('..').join('swagger').join('files').join('*.json')].sort.each do |file|
    logger.info("Processing file #{file}")
    begin
      swagger = JSON.parse(File.read(file))
    rescue JSON::ParserError => e
      logger.warn(e)
      next
    end

    folder = generate_folder(logger, collection['id'], swagger['resourcePath'])
    collection['folders'] << folder

    swagger['apis'].each do |swagger_api|
      path = swagger_api['path']

      swagger_api['operations'].each do |swagger_operation|
        name = swagger_operation['nickname']
        logger.info("Generating operation #{name}")

        description = swagger_operation['summary']
        method = swagger_operation['method']

        request = generate_request(logger, collection['id'], folder['id'], name, description, path, method)
        collection['requests'] << request
      end
    end

    collection['requests'].sort_by! { |request| request['name'] }.each do |request|
      folder['order'] << request['id']
    end
  end

  collection
end

def generate_folder(logger, collection_id, name)
  {
      'id' => SecureRandom.uuid.to_s,
      'name' => name,
      'description' => '',
      'order' => [],
      'owner' => '0',
      'collectionId' => collection_id
  }
end

def generate_request(logger, collection_id, folder_id, name, description, path, method)
  {
      'id' => SecureRandom.uuid.to_s,
      'headers' => "Accept: application/json\nContent-Type: application/json\nX-Killbill-ApiKey: {{api_key}}\nX-Killbill-ApiSecret: {{api_secret}}\nX-Killbill-CreatedBy: Postman\nAuthorization: Basic YWRtaW46cGFzc3dvcmQ=\n",
      'url' => "http://{{host}}:{{port}}#{path}",
      'preRequestScript' => '',
      'pathVariables' => {},
      'method' => method,
      'data' => [],
      'dataMode' => 'raw',
      'version' => 2,
      'tests' => '',
      'currentHelper' => 'basicAuth',
      'helperAttributes' => {
          'id' => 'basic',
          'username' => '{{username}}',
          'password' => '{{password}}',
          'saveToRequest' => true
      },
      'time' => 0,
      'name' => name,
      'description' => description,
      'collectionId' => collection_id,
      'responses' => [],
      'folder' => folder_id,
      'timestamp' => nil,
      'rawModeData' => ''
  }
end

logger = Logger.new(STDERR)
puts JSON.pretty_generate(generate_collection(logger))
