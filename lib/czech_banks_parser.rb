require 'rest-client'
require 'banks/fio.rb'
require 'banks/csas.rb'

class CzechBanksParser
  def initialize(token, bank, opts = {})
    @opts = opts
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
          base_uri: 'https://api.csas.cz/sandbox/webapi/api/v1',
          auth_uri: 'https://api.csas.cz/sandbox/widp/oauth2/auth',
          token_uri: 'https://api.csas.cz/sandbox/widp/oauth2/token',
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