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
    xml_string('//disabled', true) do |text|
      text.to_s == 'true'
    end
  end

  def enabled?
    !disabled?
  end

  def command
    xml_string('//command') do |text|
      text.strip
    end
  end

  def plugin
    return unless xml

    xml.root.attributes['plugin']
  end

  def to_s
    "Jenkins Job #{name}"
  end

  private

  def xml
    @xml ||= read_file("/var/lib/jenkins/jobs/#{name}/config.xml")
  end
end
