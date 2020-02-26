Rails.application.config.middleware.use OmniAuth::Builder do
    # To get a GITHUB_CLIENT & GITHUB_SECRET, you must create
    # a Github developer application. You can do this in 
    # settings > developer settings > Oauth apps.
    # This is the same process you will have to do with 
    # nearly every provider
    # provider :provider, ENV['PROVIDER_CLIENT'], ENV['PROVIDER_SECRET']
  provider :github, ENV['GITHUB_CLIENT'], ENV['GITHUB_SECRET']
end