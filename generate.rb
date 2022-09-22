# frozen_string_literal: true

require 'json'
require 'yaml'

# Genrate the flake-registry.json file for the registry
class Generate
  attr_reader :yml_file

  def initialize
    @yml_file = YAML.load_file("#{__dir__}/flake-registry.yml")
  end

  def run
    puts 'Generating flake-registry.json.....'
    File.write("#{__dir__}/flake-registry.json", JSON.pretty_generate(yml_file))
  end
end

Generate.new.run
