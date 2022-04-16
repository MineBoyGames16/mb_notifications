function GetMinimapAnchor()
    -- Safezone goes from 1.0 (no gap) to 0.9 (5% gap (1/20))
    -- 0.05 * ((safezone - 0.9) * 10)
    local safezone = GetSafeZoneSize()
    local safezone_x = 1.0 / 20.0
    local safezone_y = 1.0 / 20.0
    local aspect_ratio = GetAspectRatio(0)
	local res_x, res_y = GetActiveScreenResolution()
    local xscale = 1.0 / res_x
    local yscale = 1.0 / res_y
    local Minimap = {}
    Minimap.is_widescreen = GetIsWidescreen()
    Minimap.is_window = not isCommonAspectRation(res_x,res_y)
    Minimap.aspect_ratio = aspect_ratio
    Minimap.width = xscale * (res_x / (4 * aspect_ratio))
    Minimap.height = yscale * (res_y / 5.674)
    Minimap.left_x = xscale * (res_x * (safezone_x * ((math.abs(safezone - 1.0)) * 10)))
    if (Minimap.is_widescreen and aspect_ratio > 2) then
        if(Minimap.is_window) then
            Minimap.left_x = Minimap.left_x + Minimap.width * 1.17
            Minimap.width = Minimap.width * 1.025
        else
            Minimap.left_x = Minimap.left_x + Minimap.width * 1.17
            Minimap.width = Minimap.width * 1.025
        end
	elseif aspect_ratio > 2 then
		Minimap.left_x = Minimap.left_x + Minimap.width * 0.845
		Minimap.width = Minimap.width * 0.76
    elseif aspect_ratio > 1.7 then
        if(Minimap.is_window) then
            if(Minimap.is_widescreen) then
		        Minimap.left_x = Minimap.left_x + Minimap.width * 0.11
                Minimap.width = Minimap.width * 1.025
            else
		        Minimap.left_x = Minimap.left_x + Minimap.width * 0.2225
                Minimap.width = Minimap.width * 0.995
            end
        end
    end
    
    Minimap.bottom_y = 1.0 - yscale * (res_y * (safezone_y * ((math.abs(safezone - 1.0)) * 10)))
    Minimap.right_x = Minimap.left_x + Minimap.width
    Minimap.top_y = Minimap.bottom_y - Minimap.height
    Minimap.x = Minimap.left_x
    Minimap.y = Minimap.top_y
    Minimap.xunit = xscale
    Minimap.yunit = yscale
    Minimap.res_x = res_x
    Minimap.res_y = res_y
    
    return Minimap
end

function isCommonAspectRation(w,h)
    if h == (w/16)*9 then 
        return true 
    elseif h == (w/4)*3 then 
        return true
    elseif h == (w/16)*10 then 
        return true
    elseif h == (w/21)*9 then 
        return true
    elseif h == (w/64)*27 then 
        return true
    elseif h == (w/5)*4 then 
        return true
    elseif h == (w/3)*2 then 
        return true
    elseif h == (w/32)*9 then 
        return true
    else
        return false 
    end
end

exports("GetMinimapAnchor", GetMinimapAnchor)