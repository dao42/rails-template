CarrierWave.configure do |config|
  config.storage = :upyun
  config.upyun_username = ENV['UPYUN_USERNAME']
  config.upyun_password = ENV['UPYUN_PASSWORD']
  config.upyun_bucket = ENV['UPYUN_BUCKET']
  config.upyun_bucket_host = ENV['UPYUN_BUCKET_HOST']
end
