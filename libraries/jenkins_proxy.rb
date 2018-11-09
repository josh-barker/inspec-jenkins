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
    try { xml.elements['//name'].text }
  end

  def port
    try { xml.elements['//port'].text.to_i }
  end

  def noproxy
    try { xml.elements['//noProxyHost'].text.split("\n").map(&:strip) } || []
  end

  def to_s
    'Jenkins Proxy'
  end

  private

  def xml
    @xml ||= read_file('/var/lib/jenkins/proxy.xml')
  end
end
