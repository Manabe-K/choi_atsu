require "net/http"
require "json"

class GithubOrgMemberCheckService
  GITHUB_API_URL = "https://api.github.com/orgs/%{org_name}/members/%{username}".freeze

  def initialize(org_name: "runteq", github_username:)
    @org_name = org_name
    @github_username = github_username
    @token = ENV["GITHUB_ACCESS_TOKEN"] # 自分で発行したPersonal Access Token（read:org付き）
  end

  def member?
    uri = URI(GITHUB_API_URL % { org_name: @org_name, username: @github_username })
    request = Net::HTTP::Get.new(uri)
    request["Authorization"] = "token #{@token}"

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    Rails.logger.debug "GitHub API response status: #{response.code}"
    Rails.logger.debug "GitHub API response body: #{response.body}"

    response.is_a?(Net::HTTPSuccess)
  rescue => e
    Rails.logger.error "GithubOrgMemberCheckService Error: #{e.message}"
    false
  end
end