require 'spec_helper'
require 'action_view'
require 'fileutils'
require File.expand_path('../../../app/helpers/crud_star/admin_helper', __FILE__)

class View < ActionView::Base
  attr_accessor :params
  include CrudStar::AdminHelper
end

describe "the admin helper" do
  let(:view) { View.new }
  subject { view }
end
