#coding: utf-8
require File.expand_path("../login",__FILE__)
require File.expand_path("../base",__FILE__)
require 'mysql2'

module Ad
	class Idea < Ad::Base
		include Ad::Login
		
		@@DEFAULT_OPTIONS = {
			:____campaign						=> 0,
			:ad_type_id							=> "",
			:adType_temp_value			=> nil,
			:campaign								=> 0, #4462,
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
			adType = info.match(/name="adType_temp_value"\s+value='(.+?)'/)[1]
			data = @params
			data += "adType_temp_value=#{adType}"
			rsp = conn.post("/cast/setIdeaAction.jsp",data,headers)
			rsp.body.force_encoding("utf-8")
		end
		
		def up_db
			idea_id = info.match(/name="idea_id"\s+value="(\d+)"/)[1]
			con = Mysql2::Client.new(:host => "10.10.221.25", :username => "root", :password => "", :database => "ad", :port => 3306)
			con.query("update idea set numlimit = 10 where id = #{idea_id}")
		end

		private
			def info
				conn,headers = login
				rsp = conn.get("/cast/setIdea_new.jsp?id=#{@opts[:id]}",headers)
				doc = rsp.body.force_encoding("utf-8")
			end

	end
end
