package
{
    import com.shephertz.appwarp.WarpClient;
    import com.shephertz.appwarp.types.ConnectionState;
    
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.ui.Keyboard;
    
    [SWF(backgroundColor="0xBDBDBD", width="500", height="400",)]
    public class SpriteMoveDemo extends Sprite
    {
        private var localPlayer:Sprite;
        private var remotePlayer:Sprite;
        private var localProjectile:Sprite;
        private var remoteProjectile:Sprite;
        
        private var isProjectileMoving:Boolean = false;
        private var isRemoteProjectileMoving:Boolean = false;
        
        private var localDestinationY:int;

        private var remoteDestinationY:int;
        
        // AppWarp String Constants
        public var roomID:String = "1799555827";
        public var localUsername:String;
        private var apiKey:String = "b29f4030aba3b2bc7002c4eae6815a4130c862c386e43ae2a0a092b27de1c5af"
        private var secretKey:String = "bf45f27e826039754f8dda659166d59ffb7b9dce830ac51d6e6b576ae4b26f7e";
        
        private const WIDTH:int = 500;
        private const HEIGHT:int = 400;
        
        private var listener:AppWarpListener;
        
        public function SpriteMoveDemo()
        {
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT
            localPlayer = createAvatar(0xFFFF00) // size, color yellow
            localPlayer.x = 0;
            localPlayer.y = HEIGHT/2;
            addChild(localPlayer);
            
            remotePlayer = createAvatar(0xFF0000) // size, color red
            remotePlayer.x = WIDTH;
            remotePlayer.y = HEIGHT/2;
            addChild(remotePlayer);            
            
            localProjectile = createProjectile(0xFFFF00);
            localProjectile.y = HEIGHT/2;
            localDestinationY = HEIGHT/2;
            localProjectile.x = 0;
                        
            remoteProjectile = createProjectile(0xFF0000);
            remoteProjectile.x = WIDTH;
            remoteProjectile.y = HEIGHT/2;
            remoteDestinationY = HEIGHT/2;
            
            addChild(localProjectile);
            addChild(remoteProjectile);
            
            stage.addEventListener(KeyboardEvent.KEY_UP, keyPressedDown);
            stage.addEventListener(MouseEvent.CLICK, onMouseClick);
            
            listener = new AppWarpListener(this);
            
            WarpClient.initialize(apiKey, secretKey);
            
            WarpClient.getInstance().setConnectionRequestListener(listener);
            WarpClient.getInstance().setRoomRequestListener(listener);
            WarpClient.getInstance().setNotificationListener(listener);
            
            localUsername = Math.random().toString();
            WarpClient.getInstance().connect(localUsername);
        }
        
        private function onMouseClick(e:MouseEvent):void
        {
            if(WarpClient.getInstance().getConnectionState() == ConnectionState.connected){
                if(isProjectileMoving == false)
                {
                    WarpClient.getInstance().sendChat("projectile,"+e.localX+","+e.localY);   
                    isProjectileMoving = true;
                    localProjectile.y = e.localY;
                }
            }
        }
        
        private function drawprojectile(event:Event):void
        {
            updateLocalProjectile();
            updateRemoteProjectile();
        }
        
        private function updateLocalProjectile():void
        {
            if(isProjectileMoving){
                localProjectile.x += 10;
            }            
            if(localProjectile.x >= WIDTH){
                localProjectile.x = 0;
                isProjectileMoving = false;
            }             
        }       
        
        private function keyPressedDown(event:KeyboardEvent):void {
            
            if(WarpClient.getInstance().getConnectionState() != ConnectionState.connected){
                return;
            }
            var key:uint = event.keyCode;
            var step:uint = 15;
            switch (key) {
                case Keyboard.LEFT :
                    //localPlayer.x -= step;
                    break;
                case Keyboard.RIGHT :
                    //localPlayer.x += step;
                    break;
                case Keyboard.UP :
                    localPlayer.y -= step;
                    break;
                case Keyboard.DOWN :
                    localPlayer.y += step;
                    break;
            }
            WarpClient.getInstance().sendChat("player,"+localPlayer.x+","+localPlayer.y);
        }
        
        public function moveRemotePlayer(x:int, y:int):void
        {
            remotePlayer.y = y;

        }
                
        public function moveRemoteProjectile(x:int, y:int):void
        {    
            remoteProjectile.x = WIDTH;
            remoteProjectile.y = y;
            isRemoteProjectileMoving = true;

        }
        
        private function updateRemoteProjectile():void
        {
            if(isRemoteProjectileMoving){
                remoteProjectile.x -= 10;
            }
            if(remoteProjectile.x <= 0){
                remoteProjectile.x = WIDTH;
                isRemoteProjectileMoving = false;
            }            
        }
        
        private function createAvatar(bgColor:uint):Sprite {
            var s:Sprite = new Sprite();
            s.graphics.beginFill(bgColor);
            s.graphics.drawCircle(0, 0, 40);
            s.graphics.endFill();
            s.graphics.beginFill(0x000000);
            s.graphics.drawCircle(-15, -10, 5);
            s.graphics.drawCircle(+15, -10, 5);
            s.graphics.endFill();
            s.graphics.lineStyle(2, 0x000000, 100);
            s.graphics.moveTo(-20,15);
            //this will define the start point of the curve
            s.graphics.curveTo(0,35, 20,15); 
            //the first two numbers are your control point for the curve
            //the last two are the end point of the curve
            return s;
        }
        
        private function createProjectile(color:uint):Sprite {
            var s:Sprite = new Sprite();
            s.graphics.beginFill(color);
            s.graphics.drawCircle(0, 0, 10);
            s.graphics.endFill();
            s.addEventListener(Event.ENTER_FRAME, drawprojectile);
            return s;
        }
        
    }
}