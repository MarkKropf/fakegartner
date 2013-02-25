require 'sinatra'
require 'RMagick'

get "/" do
	"<html><head><title>If Gartner Had a Magic Quadrant for Private PaaS</title><meta http-equiv='refresh' content='4'></head><body><img src='/image' /></body></html>"
end

get "/image" do
  content_type 'image/png'
  background = Magick::Image.read("GartnerBlank.png").first
  dot        = Magick::Image.read("Dot.png").first
  text       = Magick::Draw.new
  text.font_family = 'helvetica'
  text.pointsize = 16
  paas  = ['rPath','dotCloud','Apprenda','Heroku','CloudFoundry','OpenShift','Cumulogic','Google Appengine','Azure']
  xlist = paas.count.times.map { Random.new.rand(150..790) }
  ylist = paas.count.times.map { Random.new.rand(75..725) }

  paas.each_index do |i|
    background = background.composite!(dot,xlist[i],ylist[i], Magick::OverCompositeOp)
    text.annotate(background, 0, 0, xlist[i]+25, ylist[i]+15, paas[i])
  end
  background.to_blob
end