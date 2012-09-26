
require File.expand_path("../login",__FILE__)
require File.expand_path("../base",__FILE__)

module Ad
	class Config < Ad::Base
		include Ad::Login
		@@DEFAULT_OPTIONS = {
			:config_id  => 0,
			:order_id   => 0,
			:product_id => 1,
			:name       => "",
			:crazy      => nil,
			:fre        => nil,
			:pre        => nil,
			:content    => nil,
			:cpm        => 6
		}

		def submit
			conn,headers = login
			rsp = conn.post("/vp/vpConfigUpdate.sdo",@params,headers)
			rsp.body
		end

	end
end
