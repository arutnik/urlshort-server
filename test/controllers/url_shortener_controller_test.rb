require 'test_helper'

class UrlShortenerControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end

  #API Related Tests

  test "API Create with valid params creates short URL" do

    longUrl = uniqueUrl()
    post(:create_api, { shortenRequest: { original_url: longUrl}  })

    newUrl = ShortUrl.find_by original_url: longUrl

    assert_not_nil newUrl, "model was not created"
    assert newUrl.url_id.length < longUrl.length, "short url was not short"
    assert_response :success, "invalud http response"
  end

  test "API Create with valid params then API info gets URL info" do

    longUrl = uniqueUrl()
    post(:create_api, { shortenRequest: { original_url: longUrl}  })

    newUrl = ShortUrl.find_by original_url: longUrl
    assert_not_nil newUrl, "model was not created"

    get(:info_api, id: newUrl.url_id)

    assert_response :success, "invalid http response"
    body = JSON.parse(response.body)

    assert_equal newUrl.url_id, body["url_id"], "response format incorrect"
    assert_equal newUrl.original_url, body["maps_to"], "response format incorrect"
  end

  test "API Create with broken params creates no short URL, returns fails" do
    modelCount = ShortUrl.count
    post(:create_api, { hortenRequest: { original_url: "http://www.google.com"}  })
    newModelCount = ShortUrl.count

    assert_response :bad_request, "invalid http response"
    assert_equal modelCount, newModelCount, "Should not have created any db records on failure"
  end

  test "API Create with invalid url creates no short URL, returns fails" do
    modelCount = ShortUrl.count
    post(:create_api, { shortenRequest: { original_url: "dsadsadas"}  })
    newModelCount = ShortUrl.count

    assert_response :bad_request, "invalid http response"
    assert_equal modelCount, newModelCount, "Should not have created any db records on failure"
  end

  test "API Create with no-scheme url creates no short URL, returns fails" do
    modelCount = ShortUrl.count
    post(:create_api, { shortenRequest: { original_url: "google.com"}  })
    newModelCount = ShortUrl.count

    assert_response :bad_request, "invalid http response"
    assert_equal modelCount, newModelCount, "Should not have created any db records on failure"
  end

  #Non API Tests

  test "Create with invalid url creates no short URL, returns fails" do
    modelCount = ShortUrl.count
    post(:create, { shortenRequest: { original_url: "dsadsadas"}  })
    newModelCount = ShortUrl.count

    assert_response :bad_request, "invalid http response"
    assert_equal modelCount, newModelCount, "Should not have created any db records on failure"
  end

  test "Create with no-scheme url creates no short URL, returns fails" do
    modelCount = ShortUrl.count
    post(:create, { shortenRequest: { original_url: "google.com"}  })
    newModelCount = ShortUrl.count

    assert_response :bad_request, "invalid http response"
    assert_equal modelCount, newModelCount, "Should not have created any db records on failure"
  end

  test "Create with broken params creates no short URL, returns fails" do
    modelCount = ShortUrl.count
    post(:create, { shortsenRequest: { original_url: "google.com"}  })
    newModelCount = ShortUrl.count

    assert_response :bad_request, "invalid http response"
    assert_equal modelCount, newModelCount, "Should not have created any db records on failure"
  end

  test "Create with valid params creates short URL and redirects" do

    longUrl = uniqueUrl()
    post(:create, { shortenRequest: { original_url: longUrl}  })

    newUrl = ShortUrl.find_by original_url: longUrl

    assert_not_nil newUrl, "model was not created"
    assert newUrl.url_id.length < longUrl.length, "short url was not short"
    assert_response :found, "invalud http response"

    assert_redirected_to :action => "info", :id => newUrl.url_id
  end

  test "Create then get info shows info" do

    longUrl = uniqueUrl()
    post(:create, { shortenRequest: { original_url: longUrl}  })

    newUrl = ShortUrl.find_by original_url: longUrl

    assert_not_nil newUrl, "model was not created"

    get(:info, id: newUrl.url_id)

    assert_response :success, "invalid http response"
    assert_template :info
  end

  test "Get info invalid  short url shows 404 page" do

    longUrl = rand(36**8).to_s(36)

    get(:info, id: longUrl)

    assert_response :not_found, "invalid http response"
    assert_template :not_found
  end

  test "Create then get request short redirects to long" do

    longUrl = uniqueUrl()
    post(:create, { shortenRequest: { original_url: longUrl}  })

    newUrl = ShortUrl.find_by original_url: longUrl

    assert_not_nil newUrl, "model was not created"

    get(:show, id: newUrl.url_id)

    assert_redirected_to longUrl
  end

  test "Request show invalid  short url shows 404 page" do

    longUrl = rand(36**8).to_s(36)

    get(:show, id: longUrl)

    assert_response :not_found, "invalid http response"
    assert_template :not_found
  end

  def uniqueUrl
    "http://www.google.com/" + rand(36**8).to_s(36)
  end
end
