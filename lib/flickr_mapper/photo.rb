class FlickrMapper::Photo < FlickrMapper::Base
	
	attr_accessor :id, :owner, :title, :description, :visibility, :date_posted, :editability, :comments, :notes, :urls, :farm, :secret, :server, :original_format, :original_secret
  
  THUMB_SIZES = { :tiny => 't', :medium => 'm', :square => 's'}
  IMAGE_SIZES = { :big => 'b', :medium => 'm', :original => 'o'}
  
  # Hack til I find a method to get the attributes
  #@@attrs = %w{owner title description visibility dates_posted editability comments notes urls}
  

  def initialize(id=nil)
    super(id)
    @owner = nil
    @title = ""
    @description = ""
    @visibility = nil
    @date_posted = nil
    @editability = nil
    @comments = nil
    @notes = ""
    @urls = nil
    @farm = ""
    @secret = ""
    @server = ""
    @original_format = ""
    @original_secret = ""
  end
  
  
  
  def self.find(param, args={})
    if param.is_a? String
      args = args.merge!(:photo_id => param)
      super('flickr.photos.getInfo', args)
    elsif param.is_a? Array
      photos = []
      param.each do |p|
        data = args.merge!(:photo_id => p)
        photos << super('flickr.photos.getInfo', data)
      end
      return photos
    elsif param.is_a? Symbol
      if param == :all
        #blah
      elsif param == :first
      end
    end
  end
  
  
  def self.parse(doc)
    model = self.new
    (doc/:photo).each do |photo|
      model.title = (photo/:title).innerHTML
      model.description = (photo/:description).innerHTML
  		model.id = photo["id"]
  		model.farm = photo["farm"]
  		model.secret = photo["secret"]
  		model.server = photo["server"]
  		model.original_secret = photo["originalsecret"]
  		model.original_format = photo["originalformat"]
  		
  		#visibility ispublic="1" isfriend="0" isfamily="0" />
  		#model.visible_to_public = (photo/:visibility).attr("ispublic")
  		#model.visible_to_family = 
  		#model.visible_to_friends = 
  		
  		#dates posted="1210034906" taken="2008-05-04 13:30:49" takengranularity="0" lastupdate="1210034913" />
  		model.date_posted = (photo/:dates).attr("posted")
  		#editability cancomment="0" canaddmeta="0" />
  		#usage candownload="1" canblog="0" canprint="0" />
  		model.comments = (photo/:comments).innerHTML
  		model.notes = (photo/:notes).innerHTML
  		#tags
  		#  <tag id="1407141-2469654388-6260" author="51797041@N00" raw="Manly" machine_tag="0">manly</tag>
  		#/tags>
  		#urls>
  		#t<url type="photopage">http://www.flickr.com/photos/jaimo/2469654388/</url>
  		#/urls>
  		#model.urls[:main] = (((photo/:urls).first)/:url).innerHTML
    end
    model
  end  
  
  def thumbnail_url(size=:tiny)
    thumb_size = THUMB_SIZES[size]
    "http://farm#{@farm}.static.flickr.com/#{@server}/#{@id}_#{@secret}_#{thumb_size}.jpg"
  end
  
  def image_url(size=nil)
    if size == :original
      "http://farm#{@farm}.static.flickr.com/#{@server}/#{@id}_#{@original_secret}_o.#{@original_format}"
    else
      img_size = size.nil? ? "" : "_#{IMAGE_SIZES[size]}"
      "http://farm#{@farm}.static.flickr.com/#{@server}/#{@id}_#{@secret}#{img_size}.jpg"
    end
  end
end