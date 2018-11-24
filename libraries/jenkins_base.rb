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

  def xml; end

  def xml_string(query, default_value = nil)
    return default_value unless xml
    return default_value unless xml.elements[query]
    return default_value unless xml.elements[query].text

    if block_given?
      yield xml.elements[query].text
    else
      xml.elements[query].text
    end
  end

  def xml_integer(query, default_value = nil)
    xml_string(query, default_value) { |text| text.to_i }
  end
end
