module Banks
  class Fio

    def initialize(token, config)
      @config = config
      @token = token
    end

    def transactions(time_start, time_end, iban)
      url = "#{@config[:base_uri]}/periods/#{@token}/#{time_start.strftime('%Y-%m-%d')}/#{time_end.strftime('%Y-%m-%d')}/transactions.json"

      trans = []
      JSON.parse(RestClient.get(url), symbolize_names: true)[:accountStatement][:transactionList][:transaction].each do |tr|
        trans << {
          id: tr[:column22].try(:[], :value),
          date: tr[:column0].try(:[], :value),
          amount: tr[:column1].try(:[], :value),
          currency: tr[:column14].try(:[], :value),
          account: "#{tr[:column2].try(:[], :value)}/#{tr[:column3].try(:[], :value)}",
          bank: tr[:column12].try(:[], :value),
          name: tr[:column7].try(:[], :value) || tr[:column9].try(:[], :value),
          variable_symbol: tr[:column5].try(:[], :value),
          message: tr[:column16].try(:[], :value)
        }
      end
      trans
    end

  end
end
