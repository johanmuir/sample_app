class ApplicationController < ActionController::Base
	def hello
		render hello: "Hello World!"
	end
end
