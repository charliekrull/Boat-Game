SHIPS = {
    ['player'] = {
        width = 64,
        height = 112,
        image = love.graphics.newImage('graphics/PNG/Ships/ship (1).png'),
        moveSpeed = 200, --adjusting as needed for now
        rotationSpeed = math.pi, --radians per second
        sailDeploySpeed = 50,
        mass = 3000,
        inertia = 3000,
        steerForce = 3000,
        strafeForce = 10000,
        maxHealth = 100
    }
}