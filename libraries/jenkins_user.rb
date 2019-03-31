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
    @xml ||= begin
      content = read_file("/var/lib/jenkins/users/#{id}/config.xml")
      return content if content

      # Jenkins has a new way to store user config files
      # We need to read the mapping file to find the directory for the user config
      user_mapping = read_file('/var/lib/jenkins/users/users.xml')
      return unless user_mapping

      # its in a key pair configuration, user id => folder name
      folder = user_mapping.elements["//*[string/text() = '#{id}']/string[2]/text()"].to_s

      return if folder.empty?

      read_file("/var/lib/jenkins/users/#{folder}/config.xml")
    end
  end
end
