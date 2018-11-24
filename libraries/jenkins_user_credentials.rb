# frozen_string_literal: true

#
# Custom jenkins_credentials matcher
#

class JenkinsUserCredentials < JenkinsCredentials
  attr_reader :username

  name 'jenkins_user_credentials'

  def initialize(username)
    @username = username
  end

  def description
    xml_string('description')
  end

  def has_password?
    !!xml_string('password', false)
  end

  def has_private_key?
    !!xml_string('privateKeySource/privateKey', false)
  end

  def has_passphrase?
    !!xml_string('passphrase', false)
  end

  def to_s
    "Jenkins User Credentials #{username}"
  end

  private

  def xml
    return @xml if @xml

    @xml = REXML::XPath.first(doc, "//*[username/text() = '#{username}' and scope/text() = 'GLOBAL']/")
  end
end
