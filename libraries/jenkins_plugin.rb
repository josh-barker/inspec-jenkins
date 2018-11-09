# frozen_string_literal: true

#
# Custom jenkins_user matcher
#

class JenkinsPlugin < JenkinsBase
  attr_reader :name

  name 'jenkins_plugin'

  def initialize(name)
    @name = name
  end

  def exist?
    return false unless config

    !config.empty?
  end

  def enabled?
    !disabled?
  end

  def disabled?
    !exist? || inspec.backend.file(disabled_plugin).file?
  end

  def version
    return unless config

    config[:plugin_version]
  end

  def to_s
    "Jenkins Plugin #{name}"
  end

  private

  def disabled_plugin
    "/var/lib/jenkins/plugins/#{name}.jpi.disabled"
  end

  def config
    @config ||= begin
      manifest_content = read_file("/var/lib/jenkins/plugins/#{name}/META-INF/MANIFEST.MF")
      return unless manifest_content

      Hash[*manifest_content.lines.map do |line|
        next unless line
        next if line.strip.empty?

        key, value = line.strip.split(' ', 2).map(&:strip)
        key = key.delete(':').tr('-', '_').downcase.to_sym
        next unless key && value
        [key, value]
      end.flatten.compact]
    end
  end
end
