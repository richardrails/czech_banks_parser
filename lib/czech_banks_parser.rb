require 'rest-client'
require 'banks/fio.rb'
require 'banks/csas.rb'

class CzechBanksParser
  def initialize(opts = {})
    @opts = opts
  end

  def connect(token, bank)
    case bank
      when 'csas' then Banks::Csas.new(token, config('csas'))
      when 'fio' then Banks::Fio.new(token, config('fio'))
      else raise(NotImplementedError)
    end
  end

  def config(state)
    case state
      when 'csas'
        {
          base_uri: @opts[:mode] == 'production' ? 'https://www.csast.csas.cz/webapi/api/v3' : 'https://api.csas.cz/sandbox/webapi/api/v3',
          auth_uri: @opts[:mode] == 'production' ? 'https://www.csast.csas.cz/widp/oauth2/auth' : 'https://api.csas.cz/sandbox/widp/oauth2/auth',
          token_uri: @opts[:mode] == 'production' ? 'https://www.csast.csas.cz/widp/oauth2/token' : 'https://api.csas.cz/sandbox/widp/oauth2/token',
          client_id: @opts[:client_id],
          secret: @opts[:secret],
          web_api_key: @opts[:web_api_key]
        }
      when 'fio'
        {
          base_uri: 'https://www.fio.cz/ib_api/rest'
        }
    end
  end
end
