path = File.expand_path '../', __FILE__

require "#{path}/config/env.rb"

class Nushape < Sinatra::Base
  include Voidtools::Sinatra::ViewHelpers

  set :logging, true
  log = File.new "log/development.log", "a"
  STDOUT.reopen log
  STDERR.reopen log

  # partial :comment, { comment: "blah" }
  # partial :comment, comment

  def partial(name, value={})
    locals = if value.is_a? Hash
      value
    else
      hash = {}; hash[name] = value
      hash
    end
    haml "_#{name}".to_sym, locals: locals
  end

  ### helpers

  def subpath(url=request.path)
    url.split("/")[1]
  end

  def nav_link_to(label, url, options={})
    if subpath == subpath(url)
      options[:class] = "current #{options[:class]}".strip
    elsif url == "/" && subpath.nil?
      options[:class] = "current #{options[:class]}".strip
    end
    link_to label, url, options
  end

  def load_photos
    dir = subpath
    paths = Dir.glob("#{PATH}/public/photos/#{dir}/*.{jpg,JPG}")
    @photos = paths.map do |photo|
      dimensions = Dimensions.dimensions photo
      vertical = dimensions[0] < dimensions[1]
      { name: File.basename(photo), vertical: vertical }
    end.sort_by{ |p| p[:name] }
  end

  ###

  get "/" do
    haml :index
  end

  get "/peluches" do
    haml :photos
  end

  get "/sketchbook" do
    haml :photos
  end

  get "/contacts" do
    haml :contacts
  end
end

# require_all "#{path}/routes"