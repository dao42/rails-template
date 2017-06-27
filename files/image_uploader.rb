class ImageUploader < CarrierWave::Uploader::Base
  storage :upyun

  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  def filename
    if super.present?
      @prefix ||= SecureRandom.uuid.gsub("-","")
      "#{@prefix}.#{file.extension.downcase}"
    end
  end
end
