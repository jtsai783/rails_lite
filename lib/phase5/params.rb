require 'uri'
require 'byebug'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:
    def initialize(req, route_params = {})
      @params = {}
      if !req.query_string.nil?
        parse_www_encoded_form(req.query_string)
      end

      if !req.body.nil?
        parse_www_encoded_form(req.body)
      end

      @params.merge!( route_params )
    end

    def [](key)
      if key.is_a? String
      else
        key = key.to_s
      end
      @params[key]
    end

    def to_s
      @params.to_json.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      params_arr = URI::decode_www_form(www_encoded_form)
      params_arr.length.times do |i|
        current_keys = parse_key(params_arr[i][0])
        current_value = params_arr[i][1]
        current = @params
        current_keys.each_with_index do | key, index|
          if index != current_keys.length - 1
            current[key] ||= Hash.new
            current = current[key]
          else
            current[key] = current_value
          end
        end
      end
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      key.split(/\]\[|\[|\]/)
    end
  end
end