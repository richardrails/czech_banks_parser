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