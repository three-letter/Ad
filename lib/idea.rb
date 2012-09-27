#coding: utf-8
require File.expand_path("../login",__FILE__)
require File.expand_path("../base",__FILE__)

module Ad
	class Idea < Ad::Base
		include Ad::Login
		
		@@DEFAULT_OPTIONS = {
			:____campaign						=> 0,
			:ad_type_id							=> "",
			:adType_temp_value			=> 88,
			:campaign								=> 4462,
			:cpm										=> 6,
			:id											=> 0,
			:idea_url								=> "http://v.youku.com/v_show/id_XNDA1Mzg5MTYw.html",
			:Isosu									=> "",
			:name										=> "",
			:show_time							=> "",
			:syscast								=> "确认投放",
			:useOldUrl							=> ""
		}

		def idea
			conn,headers = login
			rsp = conn.post("/cast/setIdeaAction.jsp",@params,headers)
			rsp.body.force_encoding("utf-8")
		end
	end
end
