class Conference

	attr_reader :tracks, :schedule

	AM_SESSION_LENGTH = 180
	PM_SESSION_LENGTH_MAX = 240

	def initialize
		@tracks = []
		self.add_new_track
		@schedule = []
	end

	def add_new_track
		@tracks << { am: [], pm: [] }
	end

	#adds talks to the sessions until they are full and creates a new track when both sessions are full
	def add_talk(talk)
		last_track = @tracks.last
 
		if last_track[:am].inject(0) { |total, talk| total + talk.minutes } + talk.minutes <= AM_SESSION_LENGTH
			last_track[:am] << talk
		elsif last_track[:pm].inject(0) { |total, talk| total + talk.minutes } + talk.minutes <= PM_SESSION_LENGTH_MAX
			last_track[:pm] << talk
		else	
			# add new track and run again to add the talk to the new track
			self.add_new_track
			self.add_talk(talk)
		end
	end

	#calculates start time of each talk
	def talk_start_time(time_to_add)
		(Time.mktime(0)+3600*(9+time_to_add)).strftime("%I:%M%p")
	end

	def schedule_generator
		@tracks.each_with_index do |track, index|
			@schedule << "Track #{ index + 1 }"

			time_am = 0

			track[:am].each do |talk|
				@schedule << " #{ talk_start_time(time_am) } #{ talk.name } #{ talk.minutes.to_i }min"
				time_am += round_minutes(talk)
			end
 
			@schedule << " 12:00PM Lunch"

			time_pm = 4 #add 4h to 09:00am start for 13:00 start

			track[:pm].each do |talk|
				@schedule << " #{ talk_start_time(time_pm) } #{ talk.name } #{ talk.minutes.to_i }min"
				time_pm += ((talk.minutes.to_f / 60) * 200).round / 200.0
			end

			@schedule << " #{ talk_start_time(time_pm) } Networking Event"

		end
	end

	def print_schedule
		@schedule.each {|i| puts i }	
	end


	def round_minutes(talk)
	((talk.minutes.to_f / 60) * 200).round / 200.0 #round up the number to the nearest .5 .05. or 005 to make sure 5 min calculates correctly
	end

end