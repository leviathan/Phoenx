require 'colored'

module Phoenx

	class GenerateWorkspace
	
		:project_files
		:workspace
	
		def initialize(workspace)

			@workspace = workspace
			@project_files = []
		
		end
		
		def generate_workspace
		
			workspace = Xcodeproj::Workspace.new(@workspace.main_project_path + @workspace.main_project_name + "." + XCODE_PROJECT_EXTENSION)

			@workspace.projects.each do |key,value| 

				workspace << value + key + "." + XCODE_PROJECT_EXTENSION

			end

			workspace.save_as(@workspace.name + "." + XCODE_WORKSPACE_EXTENSION)
		
		end
		
		def generate_project(name, value)
		
			path = value
			
			if path == nil
			
				path = '.'
			
			end
		
			previous = Dir.pwd

			Dir.chdir(path) do
				
				specs = Dir[name + '.' + PROJECT_EXTENSION]
				
				puts "Processing ".green + specs.first.bold

				file = File.read(specs.first)
				spec = eval(file)
			
				generator = Phoenx::GenerateProject.new spec
				generator.build
			end
			
			# Monkey patch due to bug in Xcode 8 that prevents chdir to switch back to previous dir
			Dir.cp_chdir previous
		
		end
		
		def generate_projects
		
			@workspace.projects.each do |key,value| 
			
				self.generate_project(key,value)
			
			end
			
			self.generate_project(@workspace.main_project_name,@workspace.main_project_path)
		
		end
		
		def generate

			self.generate_projects
			self.generate_workspace
		
		end
	
	end

end
