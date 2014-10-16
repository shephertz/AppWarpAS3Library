package
{
    import com.shephertz.appwarp.WarpClient;
    import com.shephertz.appwarp.listener.ConnectionRequestListener;
    import com.shephertz.appwarp.listener.NotificationListener;
    import com.shephertz.appwarp.listener.RoomRequestListener;
    import com.shephertz.appwarp.messages.Chat;
    import com.shephertz.appwarp.messages.LiveRoom;
    import com.shephertz.appwarp.messages.Lobby;
    import com.shephertz.appwarp.messages.Move;
    import com.shephertz.appwarp.messages.Room;
    import com.shephertz.appwarp.types.ResultCode;
    
    import flash.utils.ByteArray;
    
    public class AppWarpListener implements ConnectionRequestListener, RoomRequestListener, NotificationListener
    {
        private var _owner:SpriteMoveDemo;
        
        public function AppWarpListener(owner:SpriteMoveDemo)
        {
            _owner = owner;
        }
        
        
        public function onConnectDone(res:int, reason:int):void
        {
            if(res == ResultCode.success){
                WarpClient.getInstance().joinRoom(_owner.roomID);
                WarpClient.getInstance().subscribeRoom(_owner.roomID);
            }
            else if(res == ResultCode.auth_error){
                _owner.updateStatus("Auth Error");
            }
            else if(res == ResultCode.connection_error){
                _owner.updateStatus("Network Error. Check your internet connectivity and retry.");
            }
            else{
                _owner.updateStatus("Unknown Error");
            }
        }
        
        public function onDisConnectDone(res:int):void
        {
        }
        
        public function onInitUDPDone(res:int):void
        {
            
        }
        public function onSubscribeRoomDone(event:Room):void
        {
        }
        
        public function onUnsubscribeRoomDone(event:Room):void
        {
        }
        
        public function onJoinRoomDone(event:Room):void
        {
            if(event.result == ResultCode.success){
                _owner.updateStatus("Started! Use up/down arrows and click to shoot.");
            }
            else{
                _owner.updateStatus("Room join failed. Verify your room id.");
            }
        }
        
        public function onLeaveRoomDone(event:Room):void
        {
        }
        
        public function onGetLiveRoomInfoDone(event:LiveRoom):void
        {
        }
        
        public function onSetCustomRoomDataDone(event:LiveRoom):void
        {
        }
        
        public function onLockPropertiesDone(result:int):void
        {
            
        }
        
        public function onUnlockPropertiesDone(result:int):void
        {
            
        }
        
        public function onUpdatePropertiesDone(event:LiveRoom):void
        {
        }
        
        public function onRoomCreated(event:Room):void
        {
        }
        
        public function onRoomDestroyed(event:Room):void
        {
        }
        
        public function onUserLeftRoom(event:Room, user:String):void
        {
        }
        
        public function onUserJoinedRoom(event:Room, user:String):void
        {
        }
        public function onUserResumed(roomid:String, isLobby:Boolean, username:String):void
        {
            
        }
        public function onUserPaused(roomid:String, isLobby:Boolean, username:String):void
        {
            
        }
        public function onUserLeftLobby(event:Lobby, user:String):void
        {
        }
        
        public function onUserJoinedLobby(event:Lobby, user:String):void
        {
        }
        
        public function onPrivateChatReceived(sender:String, chat:String):void
        {
            
        }
        
        public function onChatReceived(event:Chat):void
        {
            if(event.sender != _owner.localUsername){
                var xyArray:Array = event.chat.split(",");
                var x:int = parseInt( xyArray[1]);
                var y:int = parseInt( xyArray[2]);
                if(xyArray[0] == "player"){
                    _owner.moveRemotePlayer(x, y);
                }
                else if(xyArray[0] == "projectile"){
                    _owner.moveRemoteProjectile(x, y);
                }
            }
        }
        
        public function onUpdatePeersReceived(update:ByteArray, fromUDP:Boolean):void
        {
            
        }
        
        public function onUserChangeRoomProperties(room:Room, user:String, properties:Object, lockTable:Object):void
        {
        }
        
        public function onMoveCompleted(moveEvent:Move):void
        {
            
        }
        public function onGameStarted(sender:String, roomid:String, nextTurn:String):void
        {
            
        }
        public function onGameStopped(sender:String, roomid:String):void
        {
            
        }
		
		public function onPrivateUpdateReceived(sender:String, update:ByteArray, isUDP:Boolean):void
		{
			
		}
		
		public function onNextTurnRequest(lastTurn:String):void
		{
			
		}
    }
}