# frozen_string_literal: true

#
# Custom jenkins_credentials matcher
#

class JenkinsCredentials < JenkinsBase
  attr_reader :username

  def initialize(username)
    @username = username
  end

  def exist?
    !xml.nil?
  end

  def id
    try { xml.elements['id'].text }
  end

  def to_s
    "Jenkins Credentials #{username}"
  end

  private

  def doc
    @doc ||= begin
      read_file('/var/lib/jenkins/credentials.xml')
    end
  end

  def xml
    raise 'must be implemented by child class'
  end
end
