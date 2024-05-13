require 'sinatra/base'
require 'rack'
require 'securerandom'
require 'mime/types'
require './services/image_resizer.rb'

class App < Sinatra::Base
  get '/' do
    @name = params[:name] || 'World'
    erb :index
  end

  post '/' do
    if params[:image] && (tmpfile = params[:image][:tempfile])
      image_mime_type = MIME::Types[params[:image][:type]].first
      filepath = "/tmp/#{SecureRandom.uuid}.#{image_mime_type.preferred_extension}"
      File.open(filepath, 'wb') do |file|
        file.write(tmpfile.read)
      end
      image_resizer = ImageResizer.new
      out_path = image_resizer.execute(filepath, params[:maxSize]&.to_i || 1920)
      content_type 'application/octet-stream'
      attachment(out_path)
      File.read(out_path)
    else
      status 400
      @error_msg = "画像ファイルを選択してください"
      erb :index
    end
  end

  run! if app_file == $0
end
