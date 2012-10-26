class Photo < ActiveRecord::Base
  attr_accessible :album_id,:asset,:poster
  belongs_to :album
  has_attached_file :asset
  has_attached_file :poster
  
  after_save :create_thumbnail

  def create_thumbnail
    if self.poster.url=="/posters/original/missing.png"
      @photo = self
      fileName = @photo.asset_file_name
      tmpFile = @photo.asset
      if fileName.rindex('.') && fileName.rindex('.') >=0
        thumb_base_name = "#{fileName[0,fileName.rindex('.')]}_thumbnail"
      else
        thumb_base_name = "#{fileName}_thumbnail"
      end
      thumbNailProcessor = Paperclip::Thumbnail.new(tmpFile, {:thumbnailBaseName => thumb_base_name,:time_offset => -1, :geometry => '50x50'}) 
      thumb_ext = 'png'
      thumb_content_type = 'image/png'
      fileObject = thumbNailProcessor.make
      
      # renaming file
      thumbnail_abs_path = File.absolute_path(fileObject)
      if thumbnail_abs_path.rindex('/') and thumbnail_abs_path.rindex('/')>=0
        thumbnail_new_abs_path = thumbnail_abs_path[0,thumbnail_abs_path.rindex('/')+1]+"#{thumb_base_name}.#{thumb_ext}"
      else
        thumbnail_new_abs_path = "#{thumb_base_name}.#{thumb_ext}"
      end
      File.rename(thumbnail_abs_path,thumbnail_new_abs_path)
      fileObject = File.new(thumbnail_new_abs_path)
      
      @photo.update_attributes(:poster=>fileObject)
    end
  end

end
