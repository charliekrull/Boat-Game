SHIPS = {
    ['player'] = {
        width = 16,
        height = 28,
        image = love.graphics.newImage('graphics/PNG/Ships/ship (1).png'),
        moveSpeed = 100, --adjusting as needed for now
        rotationSpeed = math.pi, --radians per second
        sailDeploySpeed = 50,
        mass = 3000,
        inertia = 3000,
        steerForce = 10,
        strafeForce = 250,
        maxHealth = 100
    }
}