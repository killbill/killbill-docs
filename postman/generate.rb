require 'json'
require 'logger'
require 'pathname'
require 'securerandom'

# this tool will generate Postman Collection Format v1.0.0 (https://schema.getpostman.com/json/collection/v1.0.0/docs/index.html)

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
  Dir[Pathname.new(File.dirname(__FILE__)).join('..').join('swagger').join('file').join('*.json')].sort.each do |file|
    logger.info("Processing file #{file}")
    begin
      swagger = JSON.parse(File.read(file))
    rescue JSON::ParserError => e
      logger.warn(e)
      next
    end

    swagger['paths'].each do |resource_path, swagger_api|
      swagger_api.each do |method, method_values|
        tag = method_values['tags'][0]
        name = method_values['operationId']
        summary = method_values['summary']

        logger.info("Generating operation #{name}")
        if folder_exist?(collection, tag)
          folder = get_folder(collection, tag)
        else
          folder = generate_folder(logger, collection['id'], tag)
          collection['folders'] << folder
        end

        request = generate_request(collection['id'], folder['id'], name, summary, resource_path, method,  method_values['parameters'])
        collection['requests'] << request
        folder['order'] << request['id']
      end
    end

    collection['requests'].sort_by! { |request| request['name'] }
  end

  collection
end

def folder_exist?(collection, tag)
  collection['folders'].any? { |folder| folder['name'] == tag }
end

def get_folder(collection, tag)
  collection['folders'].select { |folder| folder['name'] == tag }[0]
end

def convert_path_params(path)
  path.tr('{', ':').delete('}')
end

def convert_parameters(parameters)
  parameters.select { |parameter| parameter['in'] == 'query' }.map do |param|
    query_param = {
      'key' => param['name'],
      'value' => param['default'],
      'description' => "Type:#{param['type']} Required:#{param['required']}"
    }

    query_param['description'] = "#{query_param['description']} Options:#{param['enum'].join('|')}" unless param['enum'].nil?
    query_param
  end
end

def query_parameters(parameters)
  parameters = convert_parameters(parameters)
  return '' if parameters.nil? || parameters.empty?
  query_param = ''
  parameters.each do |param|
    query_param = "#{query_param}&" unless query_param.empty?
    query_param = "#{query_param}#{param['key']}=#{param['value']}"
  end
  "?#{query_param}"
end

def generate_folder(logger, collection_id, tag)
  {
      'id' => SecureRandom.uuid.to_s,
      'name' => tag,
      'description' => '',
      'order' => [],
      'owner' => '0',
      'collectionId' => collection_id
  }
end

def generate_request(collection_id, folder_id, name, description, path, method, parameters)
  {
      'id' => SecureRandom.uuid.to_s,
      'headers' => "Accept: application/json\nContent-Type: application/json\nX-Killbill-ApiKey: {{api_key}}\nX-Killbill-ApiSecret: {{api_secret}}\nX-Killbill-CreatedBy: Postman\nAuthorization: Basic YWRtaW46cGFzc3dvcmQ=\n",
      'url' => "http://{{host}}:{{port}}#{convert_path_params(path)}#{query_parameters(parameters)}",
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
      'rawModeData' => '',
      'queryParams' => convert_parameters(parameters)
  }
end

logger = Logger.new(STDERR)
puts JSON.pretty_generate(generate_collection(logger))
