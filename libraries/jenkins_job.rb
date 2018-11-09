# frozen_string_literal: true

#
# Custom jenkins_user matcher
#

class JenkinsJob < JenkinsBase
  name 'jenkins_job'

  attr_reader :name

  def initialize(name)
    @name = name
  end

  def exist?
    !xml.nil?
  end

  def disabled?
    (try { xml.elements['//disabled'].text.to_s == 'true' }) != (nil || false)
  end

  def enabled?
    !disabled?
  end

  def command
    return unless xml
    return unless xml.elements['//command']

    xml.elements['//command'].text.strip
  end

  def plugin
    try { xml.root.attributes['plugin'] }
  end

  def to_s
    "Jenkins Job #{name}"
  end

  private

  def xml
    @xml ||= read_file("/var/lib/jenkins/jobs/#{name}/config.xml")
  end
end
