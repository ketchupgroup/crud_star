require 'spec_helper'
require 'crud_star'
require 'crud_star/utility'
require 'fileutils'

describe CrudStar::Utility do
  describe "#get_partial" do
    def create_file(path)
      path = Pathname.new(path)
      FileUtils.mkdir_p(path.dirname)
      File.open(path, "w") { |f| f.puts "" }
      path.should exist
    end
    
    def destroy_file(path)
      path = Pathname.new(path)
      FileUtils.rm(path)
      path.should_not exist
    end

    before(:each) do
      create_file Rails.root.join("app", "views", "get_partials", "_list_item.html.erb")
      create_file Rails.root.join("app", "views", "crud_star_overrides", "_get_partial.html.erb") 
    end
    
    after(:each) do
      destroy_file Rails.root.join("app", "views", "get_partials", "_list_item.html.erb")
      destroy_file Rails.root.join("app", "views", "crud_star_overrides", "_get_partial.html.erb") 
    end
    
    let(:controller_name) { "get_partials" }
    
    it "returns nil when the partial does not exist" do
      CrudStar::Utility.get_partial(controller_name, "doesnt_exist").should be_nil
    end

    it "returns the default crud_star partial if no others exist" do
      CrudStar::Utility.get_partial(controller_name, "list").should eq("crud_star/list")
    end

    it "returns the application's default partial if it exists" do
      CrudStar::Utility.get_partial(controller_name, "get_partial").should eq("crud_star_overrides/get_partial")
    end

    it "returns the controller_name's partial if it exists" do
      CrudStar::Utility.get_partial(controller_name, "list_item").should eq("get_partials/list_item")
    end
  end
end
