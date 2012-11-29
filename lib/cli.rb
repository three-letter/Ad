
module Ad
	module Cli
		@@COMMANDS = %W{order product wproduct config scheduled cast idea submit shortcut db}

		def self.run
			command = ARGV.shift
			if @@COMMANDS.include?(command)
				load "lib/cli/#{command}.rb"
			else
				puts <<-INFO
The command is lost.
Usage:
  ./ad <command> [arguments]
Commands:
  #{@@COMMANDS.join(", ")}
				INFO
			end
		end
	end
end
