require 'net/http'

module Proj
  # The NetworkApiExample class is a simple network api implementation that
  # delegates to Ruby's built-in Net::HTTP.
  class NetworkApiExample
    include NetworkApiCallbacks

    def initialize(context)
      install_callbacks(context)
    end

    def open(uri, offset, size_to_read)
      http = Net::HTTP.new(uri.host, uri.port)
      if uri.scheme == "https"
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      end
      http.start

      data, response = read_data(http, uri, offset, size_to_read)
      { http: http, uri: uri, response: response, data: data }
    end

    def close(connection)
      connection[:http].finish
    end

    def header_value(connection, name)
      connection[:response][name]
    end

    def read_range(connection, offset, size_to_read)
      data, response = read_data(connection[:http], connection[:uri], offset, size_to_read)
      connection[:response] = response
      data
    end

    private

    def read_data(http, uri, offset, size_to_read)
      headers = {"Range": "bytes=#{offset}-#{offset + size_to_read - 1}"}
      request = Net::HTTP::Get.new(uri.request_uri, headers)
      response = http.request(request)
      [response.body.force_encoding("ASCII-8BIT"), response]
    end
  end
end
