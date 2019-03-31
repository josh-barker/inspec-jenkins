# frozen_string_literal: true

#
# Custom jenkins_user matcher
#

class JenkinsBuild < JenkinsBase
  name 'jenkins_build'

  attr_reader :build_name
  attr_reader :build_number

  def initialize(name, number)
    @build_name = name

    @build_number = number =~ /\A\d+\Z/ ? number.to_i : resolve_build_tag_to_number(number)
  end

  def exist?
    !json.nil?
  end

  def parameters
    return {} unless json && json[:actions]

    params = json[:actions].find { |a| a.key?(:parameters) }
    return {} unless params

    # Transform:
    #
    #  {:parameters=>
    #    [{:name=>"STRING_PARAM", :value=>"meeseeks"},
    #     {:name=>"BOOLEAN_PARAM", :value=>true}]}
    #
    # into a nice param_name => param_value Hash
    #
    Hash[params[:parameters].map { |p| [p[:name], p[:value]] }]
  end

  def result
    json && json[:result]
  end

  def to_s
    "Jenkins Build #{build_name} ##{build_number}"
  end

  private

  def json
    return @json if @json
    return unless build_number

    build_result_url = "http://localhost:8080/job/#{build_name}/#{build_number}/api/json?pretty=true"
    opts = {}
    worker = rest_call('GET', build_result_url, opts)

    @json = if worker.status.to_i == 404
              nil
            else
              JSON.parse(worker.body, symbolize_names: true)
            end
  end

  def resolve_build_tag_to_number(build_tag)
    build_url = "http://localhost:8080/job/#{build_name}/api/json?pretty=true"
    worker = rest_call('GET', build_url, {})

    return unless worker.status.to_i == 200

    build_json = JSON.parse(worker.body, symbolize_names: true)
    return unless build_json[build_tag.to_sym]
    build_json[build_tag.to_sym][:number]
  end
end
