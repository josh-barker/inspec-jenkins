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
    try { xml.elements['description'].text }
  end

  def has_password?
    return false unless xml

    !!(try { xml.elements['password'].text })
  end

  def has_private_key?
    return false unless xml
    return false unless xml.elements['privateKeySource/privateKey']

    !!(xml.elements['privateKeySource/privateKey'].text)
  end

  def has_passphrase?
    !!(try { xml.elements['passphrase'].text })
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
