#require_relative '../helpers/CustomRadix'

class UrlShortenerController < ApplicationController

  def create

    shortenParams = createParams()

    @shortUrl = ShortUrl.new(shortenParams)

    @shortUrl.save

    idBase64 = UrlShortenerHelper.getShortId(@shortUrl.id)

    puts idBase64

    @shortUrl.url_id = idBase64
    @shortUrl.save

    redirect_to :action => "info", :id => @shortUrl.url_id
  end

  def info

  end

  def new
    @shortenRequest = ShortUrl.new
  end

  def show
    id = params[:id]
    render html: "<strong>the id is " + id + " ?</strong>".html_safe
  end

  private
    def createParams
      params.require(:shortenRequest).permit(:original_url)
    end

end
