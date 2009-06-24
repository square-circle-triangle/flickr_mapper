class FlickrMapper::Photoset < FlickrMapper::Base
	
	attr_accessor :id, :owner, :title, :description, :visibility, :date_posted, :editability, :comments, :notes, :urls
  
  # Hack til I find a method to get the attributes
  #@@attrs = %w{owner title description visibility dates_posted editability comments notes urls}
  
  def self.find(param, args={})
    if param.is_a? String
      args = args.merge!(:photoset_id => param)
      super('flickr.photosets.getInfo', args)
    elsif param.is_a? Array
      photosets = []
      param.each do |p|
        data = args.merge!(:photoset_id => p)
        photosets << super('flickr.photosets.getInfo', data)
      end
      return photosets
    end
  end
  
  def self.parse(doc)
    model = self.new((doc/:photoset).attr("id"))
    (doc/:photoset).each do |photoset|
      model.title = (photoset/:title).innerHTML
      model.description = (photoset/:description).innerHTML
    end
    model
  end
  
  def self.parse_photos(doc)
    p_ids = doc.get_elements_by_tag_name("photo").map { |photo| photo["id"] }
    FlickrMapper::Photo.find(p_ids)
  end  

  def photos
    raw = request_raw("flickr.photosets.getPhotos", {:photoset_id => @id })
    FlickrMapper::Photoset.parse_photos(raw)
  end

end