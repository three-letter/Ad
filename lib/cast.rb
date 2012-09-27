#coding: utf-8
require File.expand_path("../login",__FILE__)
require File.expand_path("../base",__FILE__)

module Ad
	class Cast < Ad::Base
		include Login

		@@DEFAULT_OPTIONS = {
			:order_id						=> 0,
			:index							=> 0,
			:ad_type_id					=> 88,
			:name								=> nil,
			:add								=> "新增",
			:change_flag				=> "null",
			:deliver_type				=> 0,
			:deviceType					=> 0,
			:end_date						=> (Time.now + 60 * 60 * 24 * 3).strftime("%Y-%m-%d"),
			:isClick						=> -1,
			:isCopyrightLimit		=> -1,
			:isIpVip						=> -1,
			:isIsindexturbo			=> -1,
			:isKeywordLimit			=> -1,
			:isOverAll					=> 1,
			:isRegionLimit			=> -1,
			:isUrlLimit					=> -1,
			:isVidLimit					=> -1,
			:isYouKuUserLimit		=> -1,
			:priority						=> "AR",
			:priority_number		=> 0,
			:rates							=> 6,
			:start_date					=> Time.now.strftime("%Y-%m-%d"),
			:status							=> 1,
			:tiepianposition		=> [1,4],			
			:vip_number					=> ""
		}
		
		def cast
			pid,cid,type = register
			name = create_show.match(/name="name"\s+value="(.+?)"/)[1] 
			name = @opts[:name] unless @opts[:name].nil?
			data = @params
			data += "cid=#{cid}&pid=#{pid}&type=#{URI.escape(type)}&name=#{URI.escape(name)}"
			conn,headers = login
			conn.post("/cast/castAction_new.jsp",data,headers)
		end

		private
			# 获取创建投放的基本信息
			def register
				conn,headers = login
				doc = conn.get("/vp_do/vp_register_status.jsp?order_id=#{@opts[:order_id]}",headers).body.force_encoding("utf-8")
				infos = doc.scan(/onclick="createSysCast\('系统投放',\s+'(.+?)'\)"/)
				info = infos[@opts[:index]].join # 目前只支持第一个
				pid,cid,type = info.match(/pid=(\d+)/)[1],info.match(/cid=(\d+)/)[1],info.match(/type=(.+?)/)[1]
			end
			
			def create_show
				pid, cid, type = register
				conn,headers = login
				doc = conn.get("/cast/castCreateOrUpdate_add.jsp?orderId=#{@opts[:order_id]}&pid=#{pid}&cid=#{cid}&type=#{type}",headers)
			  doc.body.force_encoding("utf-8")
			end

	end
end
