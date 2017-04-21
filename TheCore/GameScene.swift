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

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    var player:SKSpriteNode?
    var score:SKLabelNode!
    var bg:SKAudioNode!
    var counter:UInt32 = 0
    let noCategory:UInt32 = 0
    let playerCategory:UInt32 = 0b1 << 1
    let enemyCategory:UInt32 = 0b1 << 2
    let goldCategory:UInt32 = 0b1 << 3
  

    
    
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        
        player = self.childNode(withName: "player") as? SKSpriteNode
        player?.physicsBody?.categoryBitMask = playerCategory
        player?.physicsBody?.collisionBitMask = noCategory
        player?.physicsBody?.contactTestBitMask = enemyCategory | goldCategory
        player?.physicsBody?.isDynamic = true
        
        score = self.childNode(withName:"score") as? SKLabelNode

        
            let bg:SKAudioNode = SKAudioNode(fileNamed:"loop.wav")
            bg.autoplayLooped = true
            self.addChild(bg)
            
    
     
        

        
    }
    func respawnG(){

        
        var objectTexture = SKTexture()
        objectTexture = SKTexture(imageNamed: "gold")
        let drop = SKSpriteNode(texture: objectTexture) as SKSpriteNode?
        drop?.physicsBody = SKPhysicsBody(rectangleOf: objectTexture.size())
        drop?.physicsBody?.categoryBitMask = goldCategory
        drop?.physicsBody?.contactTestBitMask = playerCategory
        drop?.physicsBody?.affectedByGravity = false;
        
            let xPosition = CGFloat(arc4random()).truncatingRemainder(dividingBy: size.width)
            let yPosition = size.height + (drop?.size.height)!
            drop?.position = CGPoint(x: yPosition, y: xPosition)
            let drift = SKAction.moveTo(x:-600, duration: 5.0)
            let wait = SKAction.wait(forDuration: 3)
            let remove = SKAction.run((drop?.removeFromParent)!)
            drop?.size.width = 30
            drop?.size.height = 30
            drop?.physicsBody?.isDynamic = true
        
      
            drop?.zPosition = 2
            drop?.name = "love"

        
            drop?.run(SKAction.sequence([drift, wait, remove]))
            self.addChild(drop!)
        
      
        
    }
//    func respawnE(){
//        
//        
//        var objectTexture2 = SKTexture()
//        objectTexture2 = SKTexture(imageNamed: "Shark")
//        let sh = SKSpriteNode(texture: objectTexture2) as SKSpriteNode?
//        sh?.physicsBody = SKPhysicsBody(rectangleOf: objectTexture2.size())
//        sh?.physicsBody?.categoryBitMask = enemyCategory
//        sh?.physicsBody?.contactTestBitMask = playerCategory
//        sh?.physicsBody?.affectedByGravity = false;
//        
//        let xPosition = CGFloat(arc4random()).truncatingRemainder(dividingBy: size.width)
//        let yPosition = size.height + (sh?.size.height)!
//        sh?.position = CGPoint(x: yPosition, y: xPosition)
//        let drift = SKAction.moveTo(x:-600, duration: 5.0)
//        let wait = SKAction.wait(forDuration: 3)
//        let remove = SKAction.run((sh?.removeFromParent)!)
//        sh?.size.width = 30
//        sh?.size.height = 30
//        sh?.physicsBody?.isDynamic = true
//    
//  
//        
//        
//        sh?.run(SKAction.sequence([drift, wait, remove]))
//        self.addChild(sh!)
//        
//        
//        
//    }

    func didBegin(_ contact: SKPhysicsContact) {
        
        let cA:UInt32 = contact.bodyA.categoryBitMask
        let cB:UInt32 = contact.bodyB.categoryBitMask
        print(cA)
        print(cB)
<<<<<<< HEAD
        if cA == playerCategory || cB == playerCategory {
            let otherNode:SKNode = (cA == playerCategory) ? contact.bodyB.node!: contact.bodyA.node!
=======

        if(cA == playerCategory)
        {
            let otherNode:SKNode = contact.bodyB.node!
//             bodyB.node! is returning nil and I can not figure out why
            
>>>>>>> 974df22aed5041ba4db633871b426a67c5a3eba9
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
            score.text = "00" + counter.description
            
        }
        else if otherCategory == enemyCategory {
//            other.removeFromParent()
//            player?.removeFromParent()
            counter-=1
            score.text = "00" + counter.description
        }
    }
 
    func generator()
    {
        let Rand = randomBetweenNumbers(firstNum: 0, secondNum: 20)
        print(Rand)
        if(Rand > 19){
            respawnG()
        }
//        if(Rand < 1){
//            respawnE()
//        }
    }
    func randomBetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat{
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        player?.position = CGPoint(x:-250,y:pos.y)
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        player?.position = CGPoint(x:-250,y:pos.y)
        if player!.position.y < UIScreen.main.bounds.size.height
        {
            
        }
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

        
        
    }
   
}
