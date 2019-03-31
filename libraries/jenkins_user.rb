# frozen_string_literal: true

#
# Custom jenkins_user resource
#

class JenkinsUser < JenkinsBase
  name 'jenkins_user'

  attr_reader :id

  def initialize(id)
    @id = id
  end

  def exist?
    !xml.nil?
  end

  def email
    xml_string('//emailAddress')
  end

  def full_name
    xml_string('//fullName')
  end

  def public_keys
    xml_string('//authorizedKeys', []) do |text|
      text.split("\n").map(&:strip)
    end
  end

  def password_hash
    xml_string('//passwordHash')
  end

  def to_s
    "Jenkins User #{id}"
  end

  private

  def xml
    @xml ||= read_file("/var/lib/jenkins/users/#{id}/config.xml")
  end
end
