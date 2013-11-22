class Talk

	attr_reader :name

	def initialize(name, minutes)
		@name = name
		@minutes = minutes
	end

	def minutes
		if @minutes == "lightning"
			@minutes = 5
		else
			@minutes = @minutes.to_f
		end
	end
end