#coding: utf-8
require File.expand_path("../login",__FILE__)
require File.expand_path("../base",__FILE__)

module Ad
	class Scheduled < Ad::Base
		include Ad::Login

		@@DEFAULT_OPTIONS = {
			:date							=> Time.now.strftime("%Y-%m-%d"),
			:order_id					=> 0,
			:config_id				=> 0,
			:discountType			=> 0,
			:op_type					=> 1,
			:type             => 0
		}

		def scheduled
			# 便于根据type查找 date默认为1
			y, m, d = @opts[:date].split("-")
			info = scheduled_info
			infos = info.split("_")
			conn,headers = login
			data = "discountType=#{@opts[:discountType]}&op_type=#{@opts[:op_type]}&order_id=#{@opts[:order_id]}&vp_position_id=#{infos[1]}&ask_date=#{y}-#{m.to_i}-#{d}&config_id=#{@opts[:config_id]}"
			rsp = conn.post("/VideoAddServlet.sdo",data,headers)
			rsp.body
		end

		private 
			def scheduled_info
				y, m, d = @opts[:date].split("-")
				conn,headers = login
				data = "order_id=#{@opts[:order_id]}&config_id=#{@opts[:config_id]}&year=#{y}&month=#{m.to_i}"
				data = URI.escape(data)
				rsp = conn.post("/vp/vp_videoData.jsp",data,headers).body
				rsp = rsp.force_encoding("UTF-8")
				infos = rsp.scan(/<td\s+id="(td_\d+_#{y}-#{m.to_i}-01_#{@opts[:config_id]})"/)
				return rsp.match(/<\/head>(.+?)/)[1]  if infos.size == 0	
				infos[@opts[:type]].join
			end
	end
end
