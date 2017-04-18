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
//    var otherONe
    var score:SKLabelNode!
    var counter:UInt32 = 0
    let noCategory:UInt32 = 0
    let playerCategory:UInt32 = 0b1 << 1
    let enemyCategory:UInt32 = 0b1 << 2
    let goldCategory:UInt32 = 0b1 << 3
    let gol = SKTexture(imageNamed: "gold")
    let en = SKTexture(imageNamed: "Shark")
  

    
    
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        
        player = self.childNode(withName: "player") as? SKSpriteNode
        player?.physicsBody?.categoryBitMask = playerCategory
        player?.physicsBody?.collisionBitMask = noCategory
        player?.physicsBody?.contactTestBitMask = enemyCategory | goldCategory
        
        score = self.childNode(withName:"score") as? SKLabelNode
        let bg:SKAudioNode = SKAudioNode(fileNamed:"loop.wav")
        bg.autoplayLooped = true
        self.addChild(bg)
        

        
    }
     private func respawnG(){
    
            let drop = SKSpriteNode(texture: gol) as SKSpriteNode?
            drop?.physicsBody = SKPhysicsBody(texture: gol, size: gol.size())
            drop?.physicsBody?.categoryBitMask = goldCategory
            drop?.physicsBody?.contactTestBitMask = playerCategory
            drop?.physicsBody?.affectedByGravity = false;
        
        
            let xPosition = CGFloat(arc4random()).truncatingRemainder(dividingBy: size.width)
            let yPosition = size.height + (drop?.size.height)!
            drop?.position = CGPoint(x: yPosition, y: xPosition)
            let drift = SKAction.moveTo(x:-400, duration: 5.0)
            drop?.size.width = 30;
            drop?.size.height = 30;
        
            drop?.run(drift)
            SKAction.removeFromParent()
            drop?.zPosition = 2
        
        
            self.addChild(drop!) 
        
      
        
    }
    
// CPU LEAK WARNING
//    private func respawnE(){
//        
//        let drop = SKSpriteNode(texture: en)
//        drop.physicsBody = SKPhysicsBody(texture: en, size: en.size())
//        drop.physicsBody?.categoryBitMask = enemyCategory
//        drop.physicsBody?.contactTestBitMask = playerCategory
//        drop.physicsBody?.affectedByGravity = false;
//        
//        
//        let xPosition = CGFloat(arc4random()).truncatingRemainder(dividingBy: size.width)
//        let yPosition = size.height + drop.size.height
//        drop.position = CGPoint(x: yPosition, y: xPosition)
//        let drift = SKAction.moveTo(x:-400, duration: 5.0)
//        drop.size.width = 50;
//        drop.size.height = 50;
//        drop.run(drift)
//        SKAction.removeFromParent()
//        drop.zPosition = 2
//        
//        self.addChild(drop)
//        
//        
//        
//    }
    func didBegin(_ contact: SKPhysicsContact) {
        
        let cA:UInt32 = contact.bodyA.categoryBitMask
        let cB:UInt32 = contact.bodyB.categoryBitMask
        print(cA)
        print(cB)

        if(cA == playerCategory)
        {
            let otherNode:SKNode = contact.bodyB.node!
            playerDidCollide(with: otherNode)
 
        }
        else if(cB == playerCategory)
        {
            let otherNode2:SKNode = contact.bodyA.node!
            playerDidCollide(with: otherNode2)
      
        }
        
        
//        if cA == playerCategory || cB == playerCategory {
////            let otherNode:SKNode = (cA == playerCategory) ? contact.bodyB.node!: contact.bodyA.node!
//            playerDidCollide(with: otherNode)
//        }
//        else {
//            contact.bodyA.node?.removeFromParent()
//            contact.bodyB.node?.removeFromParent()
//        }
    }
   
    
    func playerDidCollide(with other:SKNode) {
        let otherCategory = other.physicsBody?.categoryBitMask
        if otherCategory == goldCategory {
            other.removeFromParent()
            counter+=1
            score.text = "00" + counter.description
            
        }
        else if otherCategory == enemyCategory {
            other.removeFromParent()
            player?.removeFromParent()
        }
    }
 
    func generator()
    {
        let Rand = randomBetweenNumbers(firstNum: 0, secondNum: 20)
        print(Rand)
        if(Rand > 19){
            respawnG()
        }
//        if(Rand < 2){
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
