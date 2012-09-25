#coding: utf-8
require File.expand_path("../login",__FILE__)

module Ad
	# 订单的产品预订模块
	class Product
		include Ad::Login

		attr_reader :opts
		attr_reader :params

		# 默认产品选项参数/值
		@@DEFAULT_OPTIONS = {
			:config_id        => "null",
			:config_type      => 0,
			:accord_channel   => ["c","d"], 
			:check_all_city   => 1, 
			:accord_province	=> [52,36,15,42,43,22,35,37,45,44,51,34,62,71,81,32,21,14,46,41,61,13,23,33,65,53,63,64,82,54,99],
			:core_city        => [11,31,440100,440300,510100,50,420100,320100,430100,210100,330100,12],
			:desc             => "",
			:order_id         => 0,
			:product_id       => 1,
			:t_type           => 0,
			:time             => [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23],
			:time_check_all   => "radiobutton",
			:post_action      => "http://10.10.221.40/vp/vpConfigAdd.sdo"
		}

		def initialize *args
			@opts = eval(args[0]) if args && args.length > 0
			process_options @opts
			yield self if block_given?
		end
		
		# 设置产品信息，包括：类型 地区 时间等
		def set
			conn,headers = login
			post_url = URI.parse(@opts[:post_action])
			rsp = conn.post(post_url.path,@params,headers)
			msg = rsp.body.to_s.strip
		end
		
		# 获取产品配置信息：ID 名称
		def config(pro=1)
			conn,headers = login
			doc = conn.get("/vp/vp_config_list.jsp?order_id=#{@opts[:order_id]}&product_id=1",headers).body
			doc = doc.force_encoding("UTF-8")
			conf = []
			config_ids = doc.scan(/<TD>(\d+)<\/TD>/)
			config_id = nil
			config_ids.each_with_index do |conf,index| 
				if pro-1 == index
					config_id = conf.join
					break
				end
			end
			config_names = doc.scan(/name=name\s+value='(.+)'/)
			config_name = nil
			config_names.each_with_index do |conf,index| 
				if pro-1 == index
					config_name = conf.join
					break
				end
			end
			conf << config_id
			conf << config_name
			conf
		end

		#	submit产品配置
		def submit(config,pro=1)
			conn,headers = login
			data = "config_id=#{config[0]}&order_id=#{@opts[:order_id]}&product_id=#{pro}&name=#{config[1]}&crazy=1&fre=1&pre=1&content=1&cpm=6"
			data = URI.escape(data)
			rsp = conn.post("/vp/vpConfigUpdate.sdo",data,headers)
		end
		
		# 获取产品具体预定信息
		def get_scheduled_info conf
			y,m,d = get_now_date
			conn,headers = login
			data = "order_id=#{@opts[:order_id]}&config_id=#{conf[0]}&year=#{y}&month=#{m.to_i}"
			data = URI.escape(data)
			rsp = conn.post("/vp/vp_videoData.jsp",data,headers).body
			rsp = rsp.force_encoding("UTF-8")
			rsp.match(/<td\s+id="(td_\d+_#{y}-#{m.to_i}-#{d.to_i}_#{conf[0]})"/)[1]
		end

		# 预定产品日期模式
		def scheduled conf
			info = get_scheduled_info conf
			infos = info.split("_")
			conn,headers = login
			data = "discountType=0&op_type=1&order_id=#{@opts[:order_id]}&vp_position_id=#{infos[1]}&ask_date=#{infos[2]}&config_id=#{conf[0]}"
			rsp = conn.post("/VideoAddServlet.sdo",data,headers)
		end

		private
			# 处理参数 默认和输入的进行合并
			def process_options opts
				@opts = @@DEFAULT_OPTIONS
				@opts = @@DEFAULT_OPTIONS.merge opts if opts
				@opts.keys.each do |key|
					next if key.to_s == "post_action"
					@params ||= ""
					value = @opts[key.to_sym]
					if value.is_a?(Array)
						value.each {|v| @params += "#{key}=#{URI.escape(v.to_s)}&"}
					else
						@params += "#{key}=#{URI.escape(value.to_s)}&"
					end
				end
			end
			
			# 获取当前日期的年月日
			def get_now_date
				time = Time.now
				y,m,d = time.strftime("%Y %m %d").split(" ")				
			end
	end
end
