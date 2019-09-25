# Omniauth-backoffice

10Pines's Backoffice Strategy for OmniAuth.

## Installing

Add to your `Gemfile`:
```
gem 'omniauth-backoffice', git: 'https://github.com/10pines/omniauth-backoffice.git'
```

then run `bundle install`.

## Usage

`OmniAuth::Strategies::Backoffice` is simply a Rack middleware. Read the OmniAuth docs for detailed instructions: https://github.com/intridea/omniauth.

Here's a quick example, adding the middleware to a Rails app in `config/initializers/omniauth.rb`:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :backoffice, app_id: "MY_APP_ID", secret: "MY_SECRET", backoffice_url: "https://backoffice.com", callback_path: "/auth/backoffice/callback"
end
```

## Configuring

You need to set a few attributes, which you pass in to the `provider` method via a `Hash`:

Option name | Explanation
--- | ---
`app_id` | Your app's id from Backoffice
`secret` | Your app's secret from Backoffice
`backoffice_url` | Absolute URL to the backoffice
`callback_path` | You app's OmniAuth callback path for the Backoffice strategy

## Failure
The strategy will call OmniAuth's `fail!` method if something goes wrong on the authentication (i.e. user denying the authentication at the backoffice).
To handle these cases, you can set the `on_failure` block when initializing the `OmniAuth::Builder` and handle the request inside one of your own controllers.

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  on_failure { |env| OmniAuthController.action(:failure).call(env) }
end
```

## Auth Hash

*Auth Hash* structure available in `request.env['omniauth.auth']`:

```ruby
{
  provider: 'backoffice',
  uid: '1234567',
  info: {
    email: 'user@user.com',
    name: 'Super User',
    nickname: 'myusername',
    fecha_de_ingreso: '08/09/2014',
    cuit_o_cuil: '30-59209832-3'
  },
  extra: {
    root: true
  }
}
```
