addEvent( "setPedAnim", true )
addEventHandler( "setPedAnim", resourceRoot, function(player, block, anim) 

    setPedAnimation(player, block, anim, -1, true, false, true)

end)