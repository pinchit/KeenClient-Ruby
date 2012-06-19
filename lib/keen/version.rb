require 'keen'
require 'yaml'

# parse VERSION.yml
yaml_path = File.join(File.expand_path(File.dirname(__FILE__)), '..', '..', 'VERSION.yml')
version_info = File.open( yaml_path ) { |file| YAML::load( file ) }

# build the version string
version_string = ""
version_string += "#{version_info[:major]}"
version_string += "#{version_info[:minor]}"
version_string += "#{version_info[:patch]}"

if version_info[:build]
  version_string += "#{version_info[:build]}"
end

# set the constant
Keen::VERSION = version_string
