class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  # #{model.class.to_s.underscore} = user
  # model.id = current user id like "2916ccbf-605c-4877-b32c-b8e103026676"

  @@user_id

  def set_user_id(userId)
    @@user_id = userId
  end

  def store_dir
    "uploads/images/profile/#{@@user_id}"
  end

  # Process files as they are uploaded:
  process resize_to_limit: [300, 300]

  # Add a white list of extensions which are allowed to be uploaded.
  def extension_whitelist
    %w(jpg jpeg png)
  end

  # change extansion as jpg
  # process :convert => "jpg"

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    current_time = Time.new
    formatted_current_time = current_time.strftime("%Y%m%d_%H%M%S")
    formatted_current_time + "_" + original_filename
  end
end
