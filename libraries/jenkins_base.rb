# frozen_string_literal: true

#
# Custom jenkins_base
#

class JenkinsBase < Inspec.resource(1)
  require 'json'
  require 'openssl'
  require 'rexml/document'
  require 'rexml/xpath'

  def rest_call(method, url, options)
    Inspec::Resources::Http::Worker::Remote.new(inspec, method, url, options)
  end

  def read_file(filename)
    f = inspec.backend.file(filename)
    return unless f.file?

    case File.extname(filename)
    when '.xml'
      REXML::Document.new(f.content)
    when '.json'
      JSON.parse(f.content)
    else
      f.content
    end
  end

  def try(&_block)
    yield
  rescue NoMethodError
    nil
  end
end
