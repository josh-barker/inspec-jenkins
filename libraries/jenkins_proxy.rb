# frozen_string_literal: true

#
# Custom jenkins_proxy matcher
#

class JenkinsProxy < JenkinsBase
  name 'jenkins_proxy'

  def exist?
    !xml.nil?
  end

  def name
    xml_string('//name')
  end

  def port
    xml_integer('//port')
  end

  def noproxy
    xml_string('//noProxyHost', []) do |text|
      text.split("\n").map(&:strip)
    end
  end

  def to_s
    'Jenkins Proxy'
  end

  private

  def xml
    @xml ||= read_file('/var/lib/jenkins/proxy.xml')
  end
end
