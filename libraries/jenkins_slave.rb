# frozen_string_literal: true

#
# Custom jenkins_slave matcher
#

class JenkinsSlave < JenkinsBase
  name 'jenkins_slave'

  attr_reader :name

  def initialize(name)
    @name = name
  end

  def exist?
    !xml.nil?
  end

  def connected?
    return false unless json

    json && !json[:offline]
  end

  def online?
    return false unless json

    json && !json[:temporarilyOffline]
  end

  ############################################
  # Base Slave Attributes
  ############################################
  def description
    json && json[:description]
  end

  def remote_fs
    xml_string('//remoteFS')
  end

  def labels
    xml_string('//label', []) do |text|
      text.split(' ').map(&:strip)
    end
  end

  def usage_mode
    xml_string('//mode') do |text|
      text.downcase
    end
  end

  def availability
    return unless xml

    # returns something like `hudson.slaves.RetentionStrategy$Always`
    retention_class = xml.elements['//retentionStrategy'].attributes['class']
    retention_class.split('$').last if retention_class
  end

  def in_demand_delay
    xml_integer('//inDemandDelay', 0)
  end

  def idle_delay
    xml_integer('//idleDelay', 0)
  end

  def environment
    hash = {}
    key = nil

    return hash unless xml

    REXML::XPath.each(xml, '//tree-map/string') do |str|
      if key
        hash[key] = str.text
        key = nil
      else
        key = str.text
      end
    end

    hash
  end

  ############################################
  # SSH Slave Attributes
  ############################################
  def host
    xml_string('//host')
  end

  def port
    xml_integer('//port')
  end

  def java_path
    xml_string('//javaPath')
  end

  def credentials_id
    return unless xml
    return unless xml.elements['//credentialsId']

    credentials_id = xml.elements['//credentialsId'].text
    credentials_xml = credentials_xml_for_id(credentials_id)
    credentials_xml.elements['id'].text
  end

  def credentials_username
    return unless xml
    return unless xml.elements['//credentialsId']

    credentials_id = xml.elements['//credentialsId'].text
    credentials_xml = credentials_xml_for_id(credentials_id)
    credentials_xml.elements['username'].text
  end

  def launch_timeout
    xml_integer('//launchTimeoutSeconds')
  end

  def ssh_retries
    xml_integer('//maxNumRetries')
  end

  def ssh_wait_retries
    xml_integer('//retryWaitTime')
  end

  ############################################
  # Offline Attributes
  ############################################
  def offline_reason
    # offlineCauseReason has escaped spaces
    json && json[:offlineCauseReason].gsub('\\ ', ' ')
  end

  def to_s
    "Jenkins Slave #{name}"
  end

  private

  def xml
    return @xml if @xml

    config_url = "http://localhost:8080/computer/#{name}/config.xml"
    worker = rest_call('GET', config_url, {})

    @xml = case worker.status
           when 404
             nil
           when 403
             # If authn is enabled fall back to reading main config from disk
             read_slave_config || read_jenkins_config
           else
             REXML::Document.new(worker.body)
           end
  end

  def read_slave_config
    read_file("/var/lib/jenkins/nodes/#{name}/config.xml")
  end

  def read_jenkins_config
    config_xml = read_file('/var/lib/jenkins/config.xml')
    REXML::Document.new(config_xml.elements["//slave[name='#{name}']"].to_s)
  end

  def json
    return @json if @json

    config_url = "http://localhost:8080/computer/#{name}/api/json?pretty=true"
    opts = {}
    worker = rest_call('GET', config_url, opts)

    @json = if worker.status == 404
              nil
            else
              JSON.parse(worker.body, symbolize_names: true)
            end
  end

  def credentials_xml_for_id(credentials_id)
    doc = read_file('/var/lib/jenkins/credentials.xml')
    REXML::XPath.first(doc, "//*[id/text() = '#{credentials_id}']/")
  end
end
