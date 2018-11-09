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
    try { xml.elements['//emailAddress'].text }
  end

  def full_name
    try { xml.elements['//fullName'].text }
  end

  def public_key
    try { xml.elements['//authorizedKeys'].text.split("\n").map(&:strip) } || []
  end

  def password_hash
    try { xml.elements['//passwordHash'].text }
  end

  def to_s
    "Jenkins User #{id}"
  end

  private

  def xml
    @xml ||= read_file("/var/lib/jenkins/users/#{id}/config.xml")
  end
end
