class Post < ApplicationRecord
  has_rich_text :content
  validates :title, length: { maximum: 32 }, presence: true

  validate :validate_content_length
  validate :validate_content_byte
  validate :validate_content_picture

  MAX_CONTENT_LENGTH = 300
  ONE_KILOBYTE = 1024
  MEGA_BYTE = 4
  MAX_CONTENT_BYTE = MEGA_BYTE * ONE_KILOBYTE * 1_000
  MAX_COUNT_PICTURE = 8
  
  private

  def validate_content_length
    length = content.to_plain_text.length

    if length > MAX_CONTENT_LENGTH
       errors.add(
         :content, 
         :too_long, 
         max_content_length: MAX_CONTENT_LENGTH,
         length: length
       )
    end
  end 

  def validate_content_byte
    content.body.attachables.grep(ActiveStorage::Blob).each do |attachable|
      if attachable.byte_size > MAX_CONTENT_BYTE
        errors.add(
        :base,
        :byte_over,
        max_content_byte: MAX_CONTENT_BYTE,
        byte: attachable.byte_size,
        max_content_mega_byte: MEGA_BYTE
      )
      end
    end
  end

  def validate_content_picture
    picture = content.body.attachables.grep(ActiveStorage::Blob).count
    if picture > MAX_COUNT_PICTURE
      errors.add(
      :base,
      :picture_count_over,
      max_count_picture: MAX_COUNT_PICTURE
      )
    end
  end

end
