import SpriteKit

class GameScene: SKScene {
    var mangoTree: SKSpriteNode!
    var mango: Mango?
    var touchStart: CGPoint = .zero
    
    override func didMove(to view: SKView) {
        //Connect Game Objects
        mangoTree = childNode(withName: "tree") as! SKSpriteNode
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Get the location of the touch on the screen
        let touch = touches.first!
        let location = touch.location(in: self)
        
        // Check if the touch was on the Mango Tree
        if atPoint(location).name == "tree" {
            // Create the mango and add it to the scene at the touch location
            mango = Mango()
            mango?.physicsBody?.isDynamic = false
            mango?.position = location
            addChild(mango!)
            
            // Store the location of the touch
            touchStart = location
    }
    
        func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Get the location of the touch
        let touch = touches.first!
        let location = touch.location(in: self)
        
        // Update the position of the Mango to the current location
        mango?.position = location
    }
    
        func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Get the location of where the touch ended
        let touch = touches.first!
        let location = touch.location(in: self)
        
        // Get the difference between the start and end point as a vector
        let dx = touchStart.x - location.x
        let dy = touchStart.y - location.y
        let vector = CGVector(dx: dx, dy: dy)
        
        // Set the Mango dynamic again and apply the vector as an impulse
        mango?.physicsBody?.isDynamic = true
        mango?.physicsBody?.applyImpulse(vector)
    }
        
    }
}

