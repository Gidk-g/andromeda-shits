function create()
    print("create")
end

function beatHit(beat)
    print(beat)
    dad.y = dad.y + 5
end

local counter = 0;

local startX = (window.boundsWidth-window.width)/2
local startY = (window.boundsHeight-window.height)/2
local shakeDuration = 0

function dadNoteHit()
	shakeDuration = 0.1;
end

function update(elapsed)
	counter = counter + elapsed*3;
	if(shakeDuration > 0)then
		shakeDuration = shakeDuration - elapsed;
		window.x = startX+math.random(-15,15)
		window.y = startY+math.random(-15,15)
	else
		window.x = startX
		window.y = startY
	end
end