quest Kill_Boss begin
	state start begin
		when 9012.chat." أرغب في قتل الزعيم " begin
		say_title(mob_name(9012))
		say("")
		say(" مرحبا أرغب في الدخول لقتل الزعيم ")
		local firstselect = select (" دخول "," لا شكرآ ")
		
		if firstselect == 1 then
		
			if game.get_event_flag("kill_boss") == 0 then
		
				if pc.count_item(71095) >= 1 then -- التذكرة المطلوبة للدخول
					pc.remove_item(71095,1) 
					pc.warp(873100, 242600)
					game.set_event_flag("boss_room_close", get_time()+60*15) 
					game.set_event_flag("kill_boss", 1)
					notice_all(" تمكن اللاعب "..pc.get_name().." من الدخول لغرفه "..mob_name(2493).." بنجاح , بالتوفيق له ") 
				else
					say("")
					say(" للأسف للدخول يجب أن تمتلك ") 
					say_item_vnum(71095) 
					return
				end
			else
				say_title(" الدخول للزعيم ")
				say(" لم ينقضي وقت الأنتظار بعد ")
				return
			end
		end
		end  -- for when
		
		when kill or login or logout or levelup with game.get_event_flag("kill_boss") == 1 begin
			if game.get_event_flag("boss_room_close") < get_time() then
				game.set_event_flag("kill_boss", 0)
				return
			end
		end
		
		when 2493.kill with pc.get_map_index() == 97 begin 
			
			notice_all(" تمكن اللاعب "..pc.get_name().." من هزيمه الزعيم "..mob_name(2493).." بنجاح , مبارك له ") 
			
			game.set_event_flag("reopen", get_time()+60*15)
			
			--warp_to_village()
		end 
		
		when login with pc.get_map_index() == 355 begin 
			if game.get_event_flag("reopen") < get_time() then
				syschat(" دخول مخالف .. سيتم طردك ")
				warp_to_village()
			else
				syschat(" أفعل مابوسعك لهزيمه الزعيم ")
			end 
		end
		when 9012.chat." تصفير الوقت " with pc.is_gm() begin
			say_title(" تصفير الوقت : ")
			say(" لتصفير الوقت يلزم أمر  إداري . ")
			say("")
			say(" هل انت متأكد من الأستمرار ؟ ")
			say("")
			local conbiran = select(" نعم ", " لا ")
			
			if conbiran == 1 then
				say("")
				say(" تم تصفير وقت الانتظار بنجاح. ")
				say("")
				game.set_event_flag("kill_boss",0)
				game.set_event_flag("boss_room_close", get_time()-60*15) 
				game.set_event_flag("reopen", get_time()-60*15) 
			elseif conbiran == 2 then
				say("")
				say(" لاتحاول العبث في أمور ليست من أختصاصك ")
				say(" مجدداً ")
				return
			end -- if conbiran 
			
		end 
	end
end
