require_relative 'boot'

require 'rails/all'
require "graphql/client"
require "graphql/client/http"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AnimeApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    
  end
  AUTH_HEADER = "Bearer VvZSpm4ZWSvJGQ1_5mEG2XXOvGQEOu6o52R0JKKmNgc"
  # xxx=作成した際に表示されたアクセストークン
  HTTP = GraphQL::Client::HTTP.new("https://api.annict.com/graphql") do 
  #上記には、接続したいAPIのエンドポイントURLを記入
    def headers(context)
      { "Authorization": AUTH_HEADER }
    end
  end
  Schema = GraphQL::Client.load_schema(HTTP)
  # 上記を使って API サーバーから GraphQL Schema 情報を取得
  Client = GraphQL::Client.new(schema: Schema, execute: HTTP)
  # 上記を使ってクライアントを作成
end
