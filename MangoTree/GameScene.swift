import SpriteKit
import UIKit
import Foundation

class GameScene: SKScene {
    var mangoTree: SKSpriteNode!
    var mango: Mango?
    var touchStart: CGPoint = .zero
    var shapeNode = SKShapeNode()
    
    override func didMove(to view: SKView) {
        //Connect Game Objects
        mangoTree = childNode(withName: "tree") as! SKSpriteNode
        // Configure shapeNode
        shapeNode.lineWidth = 20
        shapeNode.lineCap = .round
        shapeNode.strokeColor = UIColor(white: 1, alpha: 0.3)
        addChild(shapeNode)
        
        // Set the contact delegate
        physicsWorld.contactDelegate = self
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
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Get the location of the touch
        let touch = touches.first!
        let location = touch.location(in: self)
        
        // Update the position of the Mango to the current location
        mango?.position = location
        
        // Draw the firing vector
        let path = UIBezierPath()
        path.move(to: touchStart)
        path.addLine(to: location)
        shapeNode.path = path.cgPath
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
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
            
        // Remove the path from shapeNode
        shapeNode.path = nil
        }
    }

extension GameScene: SKPhysicsContactDelegate {
    // Called when the physicsWorld detects two nodes colliding
    func didBegin(_ contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        
        // Check that the bodies collided hard enough
        if contact.collisionImpulse > 15 {
            if nodeA?.name == "skull" {
                removeSkull(node: nodeA!)
            } else if nodeB?.name == "skull" {
                removeSkull(node: nodeB!)
            }
        }
    }
    
    // Function used to remove the Skull node from the scene
    func removeSkull(node: SKNode) {
        node.removeFromParent()
    }
}
