class SpotImageUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  @@store_id

  def set_store_id(storeId)
    @@spot_id = storeId
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/images/spot/#{@@spot_id}"
  end

  # Process files as they are uploaded:
  process resize_to_limit: [500, 500]

  # Add a white list of extensions which are allowed to be uploaded.
  def extension_allowlist
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
