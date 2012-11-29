#coding: utf-8
require File.expand_path("../login",__FILE__)
require File.expand_path("../base",__FILE__)

module Ad
	class Submit < Ad::Base
		include Ad::Login
		
		@@DEFAULT_OPTIONS = {
			:id         => 0,
			:needCheck  => "yes"
		}

		def submit
			conn,headers = login
			rsp = conn.get("/cast/doSysCast.jsp?#{@params}",headers)
			msg = rsp.body.force_encoding("utf-8").strip
			if msg == "信息一致，是否要直接投放?"
				con,header = login
				rsp = conn.get("/cast/doSysCast.jsp?id=#{@opts[:id]}",headers)
				msg = rsp.body.force_encoding("utf-8").strip
			end
			msg
		end

	end
end
