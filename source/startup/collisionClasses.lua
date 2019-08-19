function createCollisionClasses()

    world:addCollisionClass('Ignore', {ignores = {'Ignore'}})
    world:addCollisionClass('Player', {ignores = {'Ignore'}})
    world:addCollisionClass('Button', {ignores = {'Ignore'}})
    world:addCollisionClass('Chest', {ignores = {'Ignore'}})
    world:addCollisionClass('Fire', {ignores = {'Ignore'}})
    world:addCollisionClass('Torch', {ignores = {'Ignore', 'Fire'}})

end