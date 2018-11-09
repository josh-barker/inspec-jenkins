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
    try { xml.elements['//remoteFS'].text }
  end

  def labels
    try { xml.elements['//label'].text.split(' ').map(&:strip) } || []
  end

  def usage_mode
    mode = try { xml.elements['//mode'].text }
    mode.downcase if mode
  end

  def availability
    # returns something like `hudson.slaves.RetentionStrategy$Always`
    retention_class = try { xml.elements['//retentionStrategy'].attributes['class'] }
    retention_class.split('$').last if retention_class
  end

  def in_demand_delay
    try { xml.elements['//inDemandDelay'].text }.to_i
  end

  def idle_delay
    try { xml.elements['//idleDelay'].text }.to_i
  end

  def environment
    try do
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
  end

  ############################################
  # SSH Slave Attributes
  ############################################
  def host
    try { xml.elements['//host'].text }
  end

  def port
    try { xml.elements['//port'].text.to_i }
  end

  def java_path
    try { xml.elements['//javaPath'].text }
  end

  def credentials_id
    credentials_id = try { xml.elements['//credentialsId'].text }
    credentials_xml = credentials_xml_for_id(credentials_id)
    try { credentials_xml.elements['id'].text }
  end

  def credentials_username
    credentials_id = try { xml.elements['//credentialsId'].text }
    credentials_xml = credentials_xml_for_id(credentials_id)
    try { credentials_xml.elements['username'].text }
  end

  def launch_timeout
    try { xml.elements['//launchTimeoutSeconds'].text.to_i }
  end

  def ssh_retries
    try { xml.elements['//maxNumRetries'].text.to_i }
  end

  def ssh_wait_retries
    try { xml.elements['//retryWaitTime'].text.to_i }
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
