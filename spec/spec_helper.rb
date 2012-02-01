require 'crud_star'
require 'crud_star/engine'
require 'pathname'

module Rails
  def self.root
    Pathname.new(File.expand_path("../support/rails_root/", __FILE__))
  end
end

CrudStar::Engine.config.url_path = ''
