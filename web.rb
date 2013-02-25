require 'sinatra'
require 'RMagick'

before do
  headers "X-Frame-Options" => "Allow-From http://www.markkropf.com"
end
get "/" do
	"<html><head><title>If Gartner Had a Magic Quadrant for Private PaaS</title><script type=""text/javascript"" src=""/refresh.js""></script></head><body><img src='/image' id='quad' name='quad'/></body></html>"
end

get '/refresh.js' do
  content_type "text/javascript"
"
            var newImage = new Image();
            newImage.src = '/image';

            function updateImage()
            {
              if(newImage.complete) {
                  document.getElementById('quad').src = newImage.src;
                  newImage = new Image();
                  newImage.src = '/image?time=' + new Date();
              }
                setTimeout(updateImage, 1000);
            }

            onload = updateImage;
"
end

get "/image" do
  content_type 'image/jpeg'
  background = Magick::Image.read("GartnerBlank.jpg").first
  dot        = Magick::Image.read("Dot.jpg",).first
  text       = Magick::Draw.new
  text.font_family = 'helvetica'
  text.pointsize = 16
  paas  = ['rPath','dotCloud','Apprenda','Heroku','CloudFoundry','OpenShift','Cumulogic','Google Appengine','Azure']
  xlist = paas.count.times.map { Random.new.rand(150..790) }
  ylist = paas.count.times.map { Random.new.rand(75..725) }

  paas.each_index do |i|
    background.composite!(dot,xlist[i],ylist[i], Magick::OverCompositeOp)
    text.annotate(background, 0, 0, xlist[i]+25, ylist[i]+15, paas[i])
  end
  background = background.scale(550, 581)
  background.to_blob
end