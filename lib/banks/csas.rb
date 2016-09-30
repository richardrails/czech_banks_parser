module Banks
  class Csas
    # 7777777777
    # https://help.salesforce.com/apex/HTViewHelpDoc?id=remoteaccess_oauth_refresh_token_flow.htm&language=en_US

    def initialize(token, config)
      @config = config
      @token = get_token(token)
    end

    def accounts
      JSON.parse(RestClient.get(@config[:base_uri] + '/netbanking/my/accounts', headers), symbolize_names: true)[:accounts]
    end

    def ibans
      accounts.collect{|ac| ac[:accountno][:iban]}
    end

    def transactions(time_start = nil, time_end = nil, iban = nil)
      url = @config[:base_uri] + '/netbanking/my/accounts/' + iban.to_s + '/transactions'
      url += "?dateStart=#{time_start.iso8601}" if time_start.present?
      url += "#{url =~ /\?/ ? '&' : '?'}dateEnd=#{time_end.iso8601}" if time_end.present?

      JSON.parse RestClient.get(url, headers), symbolize_names: true
    end

    private

    def headers
      {'WEB-API-key' => @config[:web_api_key], 'Authorization' => "Bearer #{@token}", accept: :json}
    end

    def get_token(token)
      response = RestClient.post @config[:token_uri], {grant_type: 'refresh_token', client_id: @config[:client_id], client_secret: @config[:secret], refresh_token: token}
      JSON.parse(response, symbolize_names: true)[:access_token]
    end
  end
end
