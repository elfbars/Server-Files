--NOVA Studios



local a=module("cfg/cfg_groupselector")local b=a.selectors;local c={}local d=false;local d=""RMenu.Add("main","groupselector",RageUI.CreateMenu("","",1300,100))RMenu:Get("main","groupselector"):SetSubtitle("~b~Select a job.")RegisterNetEvent("NOVA:onClientSpawn")AddEventHandler("NOVA:onClientSpawn",function(a,a)if a then TriggerServerEvent("NOVA:getJobSelectors")TriggerServerEvent('NOVA:getFactionWhitelistedGroups')end end)RegisterNetEvent("NOVA:gotJobSelectors",function(e)c=e;local d=function(a)d=a.selectorId end;local e=function(a)RageUI.ActuallyCloseAll()RageUI.Visible(RMenu:Get("main","groupselector"),false)end;local a=function(c)if IsControlJustPressed(1,38)then local b=b[c.selectorId].type;RageUI.ActuallyCloseAll()RMenu:Get("main","groupselector"):SetSpriteBanner(a.selectorTypes[b]._config.TextureDictionary,a.selectorTypes[b]._config.texture)RageUI.Visible(RMenu:Get("main","groupselector"),true)end;local a,d,e=table.unpack(GetFinalRenderedCamCoord())DrawText3D(b[c.selectorId].position.x,b[c.selectorId].position.y,b[c.selectorId].position.z,"Press [E] to open Job Selector.",a,d,e)end;for b,c in pairs(c)do tNOVA.createArea("selector_"..b,c.position,1.5,6,d,e,a,{selectorId=b})tNOVA.addMarker(c.position.x,c.position.y,c.position.z-1,1.0,1.0,1.0,255,0,0,170,50,27)tNOVA.addBlip(c.position.x,c.position.y,c.position.z,c._config.blipid,c._config.blipcolor,c._config.name)end end)RageUI.CreateWhile(1.0,true,function()if RageUI.Visible(RMenu:Get('main','groupselector'))then RageUI.DrawContent({header=true,glare=false,instructionalButton=false},function()for a,b in pairs(c)do if a==d then for c,c in pairs(b.jobs)do RageUI.ButtonWithStyle(c[1],b._config.name,{RightLabel="→→→"},true,function(b,b,b)if b then TriggerServerEvent("NOVA:jobSelector",a,c[1])SetTimeout(1000,function()ExecuteCommand("blipson")end)end end)end;RageUI.ButtonWithStyle("Unemployed","",{RightLabel="→→→"},true,function(b,b,b)if b then TriggerServerEvent("NOVA:jobSelector",a,"Unemployed")SetTimeout(1000,function()end)end end)end end end)end end)