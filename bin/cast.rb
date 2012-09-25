#coding: utf-8
require File.expand_path("../login",__FILE__)

module Ad
	# 广告投放操作类
	class Cast
		include Ad::Login

		attr_reader :order_id, :idea_name
		
		def initialize *args
			@order_id = args[0]
			@idea_name = args[1]
		end
		
		# 获取创建投放的基本信息
		def register
			conn,headers = login
			doc = conn.get("/vp_do/vp_register_status.jsp?order_id=#{@order_id}",headers).body.force_encoding("utf-8")
			infos = doc.scan(/onclick="createSysCast\('系统投放',\s+'(.+?)'\)"/)
			info = infos[0].join # 目前只支持第一个
			pid,cid,type = info.match(/pid=(\d+)/)[1],info.match(/cid=(\d+)/)[1],info.match(/type=(.+?)/)[1]
		end
		
		# 创建广告投放
		def case
			pid,cid,type = register
			name = "BD推广_#{@order_id}_#{cid}_通用播放页特效广告"
			data = get_data
			data += "cid=#{cid}&order_id=#{@order_id}&pid=#{pid}&type=#{type}&name=#{name}"
			data = URI.escape(data)
			conn,headers = login
			conn.post("/cast/castAction_new.jsp",data,headers)
		end
		
		# 添加素材
		def idea
			conn,headers = login
			data = "____campaign=0&ad_type_id=&adType_temp_value=88&campaign=4462&cpm=0&id=#{@order_id}&Isosu=&name=#{@idea_name}&show_time=&useOldUrl=&syscast=确认投放&idea_url=http://v.youku.com/v_show/id_XNDA1Mzg5MTYw.html"
			data = URI.escape(data)
			rsp = conn.post("/cast/setIdeaAction.jsp",data,headers)
			puts rsp.body.strip
		end

		# 获取延伸信息
		def extends
			conn,headers = login
			doc = conn.get("/cast/materialSetting.sdo?order_id=17502&positionId=2701&data=56644",headers).body.force_encoding("utf-8")
			doc.match(/id=(\d+)/)[1]
		end

		private
			# 获取创建投放的固态信息，不支持动态变化
			def get_data
				start_date = Time.now.strftime("%Y-%m-%d") 
				end_date = (Time.now + 60 * 60 * 24 * 3).strftime("%Y-%m-%d")
				data = "ad_type_id=88&add=新增&change_flag=null&deliver_type=0&deviceType=0&end_date=#{end_date}&isClick=-1&isCopyrightLimit=-1&isIpVip=-1&isIsindexturbo=-1&isKeywordLimit=-1&isOverAll=1&isRegionLimit=-1&isUrlLimit=-1&isVidLimit=-1&isYoukuUserLimit=-1&priority=AR&priority_number=0&rates=6&start_date=#{start_date}&status=1&tiepianposition=1&tiepianposition=4&vip_number=&"
			end
	end
end
