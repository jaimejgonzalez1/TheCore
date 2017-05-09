//
//  GameScene.swift
//  TheCore
//
//  Created by Jaime Gonzalez on 3/12/17.
//  Copyright © 2017 Columbia. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit


class GameScene: SKScene , SKPhysicsContactDelegate{
    
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    var player:SKSpriteNode?
    var score:SKLabelNode!
    var health:SKLabelNode!
    var labelR:SKLabelNode!

    var viewController: UIViewController?
    var bg:SKAudioNode!
    var healthBar:UInt32 = 100;
    var counter:UInt32 = 0
    let noCategory:UInt32 = 0
    let playerCategory:UInt32 = 0b1 << 1
    let enemyCategory:UInt32 = 0b1 << 2
    let goldCategory:UInt32 = 0b1 << 3
    let userDefults = UserDefaults.standard ///returns shared defaults object.
  

    

    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        
        
   
        player = self.childNode(withName: "player") as? SKSpriteNode
        player?.physicsBody?.categoryBitMask = playerCategory
        player?.physicsBody?.collisionBitMask = noCategory
        player?.physicsBody?.contactTestBitMask = enemyCategory | goldCategory
        player?.physicsBody?.isDynamic = true
        
        userDefults.set(0, forKey: "score")
        userDefults.set(100, forKey:"health")

        score = self.childNode(withName:"score") as? SKLabelNode
        health = self.childNode(withName: "health") as? SKLabelNode
        labelR = self.childNode(withName: "labelR") as? SKLabelNode
        
        labelR.isHidden = true;

        
        
        
        
  
        let bg:SKAudioNode = SKAudioNode(fileNamed:"loop.wav")
        bg.autoplayLooped = true
        self.addChild(bg)        
    
     
        

        
    }
    func respawnG(){

        
        var objectTexture = SKTexture()
        objectTexture = SKTexture(imageNamed: "gold")
        let drop = SKSpriteNode(texture: objectTexture) as SKSpriteNode?
        drop?.physicsBody = SKPhysicsBody(texture: objectTexture, size:CGSize(width:20,height:20))
        drop?.physicsBody?.categoryBitMask = goldCategory
        drop?.physicsBody?.contactTestBitMask = playerCategory
        drop?.physicsBody?.affectedByGravity = false;
        
            let xPosition = (CGFloat(arc4random()).truncatingRemainder(dividingBy: size.width))-100
            let yPosition = size.height + (drop?.size.height)!
            drop?.position = CGPoint(x: yPosition, y: xPosition)
            let drift = SKAction.moveTo(x:-600, duration: 3.0)
            let wait = SKAction.wait(forDuration: 3)
            let remove = SKAction.run((drop?.removeFromParent)!)
            drop?.size.width = 20
            drop?.size.height = 20
            drop?.physicsBody?.isDynamic = true
        

        
            drop?.run(SKAction.sequence([drift, wait, remove]))
            self.addChild(drop!)
        
      
        
    }
    func respawnE(){
        
        
        var objectTexture2 = SKTexture()
        objectTexture2 = SKTexture(imageNamed: "enemy")
        let sh = SKSpriteNode(texture: objectTexture2) as SKSpriteNode?
        sh?.physicsBody = SKPhysicsBody(texture: objectTexture2, size: CGSize(width:60,height:60))
        sh?.physicsBody?.categoryBitMask = enemyCategory
        sh?.physicsBody?.contactTestBitMask = playerCategory
        sh?.physicsBody?.affectedByGravity = false;
        
        let xPosition = (CGFloat(arc4random()).truncatingRemainder(dividingBy: size.width))-100
        let yPosition = size.height + (sh?.size.height)!
        sh?.position = CGPoint(x: yPosition, y: xPosition)
        let drift = SKAction.moveTo(x:-600, duration: 3.0)
        let wait = SKAction.wait(forDuration: 3)
        let remove = SKAction.run((sh?.removeFromParent)!)
        sh?.size.width = 60
        sh?.size.height = 60
        sh?.physicsBody?.isDynamic = true
        sh?.physicsBody?.allowsRotation = false
        sh?.zRotation = CGFloat(M_PI_4)
     
  
        
        
        sh?.run(SKAction.sequence([drift, wait, remove]))
        self.addChild(sh!)
        
        
        
    }

    func didBegin(_ contact: SKPhysicsContact) {
        
        let cA:UInt32 = contact.bodyA.categoryBitMask
        let cB:UInt32 = contact.bodyB.categoryBitMask
        print(cA)
        print(cB)
        if cA == playerCategory || cB == playerCategory {
            let otherNode : SKNode = (cA == playerCategory) ? contact.bodyB.node!: contact.bodyA.node!
        }

        if(cA == playerCategory)
        {
            let otherNode:SKNode = contact.bodyB.node!


            playerDidCollide(with: otherNode)
        }
        else {
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
        }
    }
   
    
    func playerDidCollide(with other:SKNode) {
        let otherCategory = other.physicsBody?.categoryBitMask
        if otherCategory == goldCategory {
            other.removeFromParent()
            counter+=1
            userDefults.set(counter, forKey: "score")
            if(counter > 50){
                labelR.text = "YOU WIN"
                labelR.isHidden = false;
                self.isPaused = true

            }
        
            
        }
        else if otherCategory == enemyCategory {
            print("HIT")
            other.removeFromParent()
            player?.alpha = 0.7
            if healthBar > 10{
            healthBar -= 10
            userDefults.set(healthBar, forKey:"health")
            }
            else{
        
                labelR.text = "YOU LOSE"
                labelR.isHidden = false;
                labelR.color = UIColor.red
                self.isPaused = true

               
                
            }
            }
    }
    
 
    func generator()
    {
        let Rand = randomBetweenNumbers(firstNum: 0, secondNum: 20)
        print(Rand)
        if(Rand > 19.5){
            respawnG()
        }
        if(Rand < 1){
            respawnE()
        }
    }
    func randomBetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat{
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        player?.position = CGPoint(x:-250,y:pos.y)
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        player?.position = CGPoint(x:-250,y:pos.y)
       
    }
    
    func touchUp(atPoint pos : CGPoint) {
        player?.position = CGPoint(x:-250,y:pos.y)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        generator()
        healthBar = userDefults.value(forKey: "health") as! UInt32
        counter = userDefults.value(forKey: "score") as! UInt32
        
        score.text = counter.description
        health.text = healthBar.description + "%"
        
        
    }
   
}
