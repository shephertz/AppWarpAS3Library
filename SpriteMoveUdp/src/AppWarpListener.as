package
{
    import com.shephertz.appwarp.WarpClient;
    import com.shephertz.appwarp.listener.ConnectionRequestListener;
    import com.shephertz.appwarp.listener.NotificationListener;
    import com.shephertz.appwarp.listener.RoomRequestListener;
    import com.shephertz.appwarp.listener.ZoneRequestListener;
    import com.shephertz.appwarp.messages.Chat;
    import com.shephertz.appwarp.messages.LiveResult;
    import com.shephertz.appwarp.messages.LiveRoom;
    import com.shephertz.appwarp.messages.LiveUser;
    import com.shephertz.appwarp.messages.Lobby;
    import com.shephertz.appwarp.messages.MatchedRooms;
    import com.shephertz.appwarp.messages.Move;
    import com.shephertz.appwarp.messages.Room;
    import com.shephertz.appwarp.types.ResultCode;
    
    import flash.utils.ByteArray;
    
    public class AppWarpListener implements ConnectionRequestListener, RoomRequestListener, NotificationListener, ZoneRequestListener
    {
        private var _owner:SpriteMoveUdp;
        
        public function AppWarpListener(owner:SpriteMoveUdp)
        {
            _owner = owner;
        }
        
        public function onInitUDPDone(res:int):void
        {
            if(res == ResultCode.success){
                _owner.udpEnabled = true;
                _owner.updateStatus("udp enabled");
            }
        }
        
        public function onConnectDone(res:int, reason:int):void
        {
            if(res == ResultCode.success){
                WarpClient.getInstance().joinRoom(_owner.roomID);
                WarpClient.getInstance().subscribeRoom(_owner.roomID);
                try{
                    WarpClient.getInstance().initUDP();                    
                }
                catch(e:Error){
                    // happens when running in flash player (browser)
                    _owner.udpEnabled = false;
                }
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
        
        public function onSubscribeRoomDone(event:Room):void
        {
        }
        
        public function onUnsubscribeRoomDone(event:Room):void
        {
        }
        
        public function onJoinRoomDone(event:Room):void
        {
            if(event.result == ResultCode.success){
                _owner.updateStatus("Started! Use up/down arrows and click to shoot udpEnabled "+ _owner.udpEnabled);
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

        }
        
        public function onUpdatePeersReceived(update:ByteArray, fromUDP:Boolean):void
        {
            var msg:String = update.readUTF();
            var msgArray:Array = msg.split(",");
            var sender:String = msgArray[0];
            var tag:String = msgArray[1];
            var x:int = parseInt(msgArray[2]);
            var y:int = parseInt(msgArray[3]);
            if(sender == _owner.localUsername){
                return;
            }
            if(tag == "player"){
                _owner.moveRemotePlayer(x, y);
            }
            else if(tag == "projectile"){
                _owner.moveRemoteProjectile(x, y);
            }            
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

        /**
        *  Following are ZoneRequestListener interface implementation methods.
        *  Not used in this sample but this illustrates how to implement them.
         */
        
        public function onCreateRoomDone(event:Room):void
        {

        }
        
        public function onDeleteRoomDone(event:Room):void
        {

        }
        
        public function onGetLiveUserInfoDone(event:LiveUser):void
        {


        }
        
        public function onGetAllRoomsDone(event:LiveResult):void
        {

        }
        public function onGetOnlineUsersDone(event:LiveResult):void
        {

        }
        public function onSetCustomUserInfoDone(event:LiveUser):void
        {

        }
        
        public function onGetMatchedRoomsDone(event:MatchedRooms):void
        {

        }
    }
}