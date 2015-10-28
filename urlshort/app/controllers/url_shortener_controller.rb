#require_relative '../helpers/CustomRadix'

class UrlShortenerController < ApplicationController

  #Needed to allow API to be called without auth token.
  skip_before_filter :verify_authenticity_token, only: [:create_api, :info_api]

  def create

    shortenParams = createShortenRequestParams()

    shortenUrlCore(shortenParams)

    populateInfoPage()

    flash[:isNewlyCreated] = 'true'

    redirect_to :action => "info", :id => @shortUrl.url_id
  end

  def create_api

    shortenParams = createShortenRequestParams()

    if !checkUrlIsValid(params[:shortenRequest][:original_url])
      response = { message: "The URL must be valid and have a scheme attached."}
      render json: response, status: :bad_request
      return
    end

    shortenUrlCore(shortenParams)

    response = createShortUrlJsonResponse()

    render json: response
  end

  def info

    if flash[:isNewlyCreated]
      @isNewlyCreated = true
    end

    @shortUrl = findshortUrlByUrlId(params[:id])

    populateInfoPage()
  end

  def info_api

    @shortUrl = findshortUrlByUrlId(params[:id])

    response = createShortUrlJsonResponse()

    render json: response
  end

  def new

    @shortenRequest = ShortUrl.new
  end

  def show

    @shortUrl = findshortUrlByUrlId(params[:id])

    #detect redirect loop
    if @shortUrl.original_url.include? root_url
      puts "Redirect loop detected, returning to home"
      redirect_to root_url
      return
    end

    redirect_to @shortUrl.original_url
  end

  private

    def shortenUrlCore(shortenParams)
      @shortUrl = ShortUrl.new(shortenParams)

      @shortUrl.save

      idBase64 = UrlShortenerHelper.getShortId(@shortUrl.id)

      @shortUrl.url_id = idBase64
      @shortUrl.save
    end

    def checkUrlIsValid(url)
      result = false
      begin
        uri = URI(url)
        result = !(uri.scheme.blank?)
      rescue URI::InvalidURIError
        puts "Invalid URL detected"
        result = false
      end
      result
    end

    def createShortUrlJsonResponse
      response = {
        url_id: @shortUrl.url_id,
        maps_to: @shortUrl.original_url
       }
    end

    def createShortenRequestParams
      params.require(:shortenRequest).permit(:original_url)
    end

    def findshortUrlByUrlId(urlId)
      ShortUrl.find_by url_id: urlId
    end

    def getAbsoluteUrlFromUrlId(urlId)
        URI.join(root_url, urlId)
    end

    #Prepares all data to show on the info view
    def populateInfoPage
      @absoluteShortUrl = getAbsoluteUrlFromUrlId(@shortUrl.url_id)
    end

end
