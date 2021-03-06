module Phoenx
	
	class Project

		attr_reader :configurations
		attr_reader :config_files
		
		attr_accessor :pre_install_scripts
		attr_accessor :post_install_scripts
		attr_accessor :project_name
		attr_reader   :targets

		def initialize
	
			@configurations = []
			@config_files = {}
			@targets = []
			@pre_install_scripts = []
			@post_install_scripts = []
			
			yield self
	
		end
		
		def configuration(name, parent)
		
			@configurations << Configuration.new(name, parent)
		
		end
		
		def target(name, type, platform, version, &block)

			targets << Phoenx::TestableTarget.new(name, type, platform, version, &block)
		
		end
		
		def project_file_name
		
			return @project_name + "." + XCODE_PROJECT_EXTENSION
		
		end
	
	end

end
