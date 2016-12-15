Connect Czech banks FIO and CSAS with your Ruby application

# Initializing API

### FIO:

```ruby

token = 'sdiohsiodgsr75rg7e8r7gh' # FIO bank token

@parser = CzechBanksParser.new.connect(token, 'fio')

```

### CSAS:

```ruby

token = 'sdiohsiodgsr75rg7e8r7gh' # CSAS Oauth2 refresh token

opts = {}
opts[:web_api_key] = CSAS_WEB_API_KEY
opts[:client_id] = CSAS_CLIENT_ID
opts[:secret] = CSAS_SECRET
otps[:mode] = 'production' # or sandbox

@parser = CzechBanksParser.new(opts).connect(token, 'csas')

```


# Downloading transactions


```ruby

date_from = Date.today - 1.week
date_to = Date.today
iban = 'CZ8788665897' # important only for CSAS

@parser.transactions(date_from, date_to, iban).each do |tr|
    # output: {trans_id: tr[:id], variable_symbol: tr[:variable_symbol], date: tr[:date], amount: tr[:amount], currency: tr[:currency], from_account: tr[:account], bank: tr[:bank], name: tr[:name], message: tr[:message]}
end

```

# Other

### Obtaining CSAS refresh token

```ruby

class BankTokensController < ApplicationController
  load_resource :account
  load_resource through: :account

  def auth
    config = parser.config(params[:state])
    redirect_to "#{config[:auth_uri]}?state=profil&redirect_uri=#{callback_account_bank_tokens_url(@account)}&client_id=#{config[:client_id]}&response_type=code&access_type=offline"
  end

  def callback
    config = parser.config('csas')
    redirect_to "#{config[:token_uri]}?grant_type=authorization_code&code=#{params[:code]}&client_id=#{config[:client_id]}&client_secret=#{config[:secret]}&redirect_uri=#{get_token_account_bank_tokens_url(@account)}&state=csas"
  end

  def get_token
    if params[:refresh_token].present?

      ibans = parser.connect(params[:refresh_token], 'csas').ibans # get accounts ibans from CSAS

      if ibans.include?(@account.bank_account.iban)
        bt = @account.bank_tokens.new(bank: 'csas', token: params[:refresh_token], active: true)
        bt.save!
        redirect_to accounts_path, notice: t('bank_account_connected')
      else
        flash[:error] = t('no_iban_match', iban: @account.bank_account.iban, ibans: ibans.join(', '))
        redirect_to accounts_path
      end
    end
  end

  private

  def parser
    CzechBanksParser.new({web_api_key: CSAS_WEB_API_KEY, client_id: CSAS_CLIENT_ID, secret: CSAS_SECRET})
  end


end

```

# About

&copy; Author: Richard Lapiš