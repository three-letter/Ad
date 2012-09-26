
module Ad
	class Base
		attr_reader :opts
		attr_reader :params
		@@DEFAULT_OPTIONS = {}
		def initialize *args
			process_option args
			yield if block_given?
		end

		private 
			def process_option opts
				@opts = @@DEFAULT_OPTIONS
				@opts = @opts.merge(opts[0]) if opts && opts.length > 0
				@opts.keys.each do |key|
					@params ||= ""
					value = @opts[key.to_sym]
					next if key.to_s == "action" || value.nil?
					if value.is_a?(Array)
						value.each {|v| @params += "#{key}=#{URI.escape(v.to_s)}&"}
					else
						@params += "#{key}=#{URI.escape(value.to_s)}&"
					end
				end
			end
	end
end
