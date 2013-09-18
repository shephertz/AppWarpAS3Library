import com.shephertz.appwarp.WarpClient;
import com.shephertz.appwarp.listener.ChatRequestListener;
import com.shephertz.appwarp.listener.ConnectionRequestListener;
import com.shephertz.appwarp.listener.NotificationListener;
import com.shephertz.appwarp.listener.RoomRequestListener;
import com.shephertz.appwarp.messages.Chat;
import com.shephertz.appwarp.messages.LiveRoom;
import com.shephertz.appwarp.messages.Lobby;
import com.shephertz.appwarp.messages.Move;
import com.shephertz.appwarp.messages.Room;
import com.shephertz.appwarp.types.ResultCode;

import flash.text.TextField;
import flash.utils.ByteArray;

var outputTextField:TextField = new TextField();
var userinputTextField:TextField = new TextField();
var connectbtn:TextField = new TextField();
var disconnectbtn:TextField = new TextField();
var chatBtn:TextField = new TextField();

// AppWarp String Constants
var roomID:String = "1799555827";
var apiKey:String = "b29f4030aba3b2bc7002c4eae6815a4130c862c386e43ae2a0a092b27de1c5af"
var secretKey:String = "bf45f27e826039754f8dda659166d59ffb7b9dce830ac51d6e6b576ae4b26f7e";

// Watermark Text
var NAME_PROMPT:String = "Enter name and click connect..";
var CHAT_PROMPT:String = "Type message..";

// COLORS
var GREY:uint = 0x999999;
var BLACK:uint = 0x000000;
var WHITE:uint = 0xFFFFFF;
var RED:uint = 0xDF0101;

// AppWarp Reference
var appwarp:WarpClient;

/*
Handle connection events. If successfully connected, send join room request.
*/
class connectionListener implements ConnectionRequestListener
{
    public function onConnectDone(res:int):void
    {
        if(res == ResultCode.success)
        {
            appwarp.joinRoom(roomID);
        }
        else{
            outputTextField.text += "\nConnection Failed!";
            connectbtn.backgroundColor = BLACK;
            chatBtn.backgroundColor = GREY;
            disconnectbtn.backgroundColor = GREY;
        }
    }
    
    public function onDisConnectDone(res:int):void
    {
        outputTextField.text += "\nDisconnected!";
        userinputTextField.text = NAME_PROMPT;
        userinputTextField.textColor = GREY;
        connectbtn.backgroundColor = BLACK;
        chatBtn.backgroundColor = GREY;
        disconnectbtn.backgroundColor = GREY;
    }
}

/*
Handle responses for room requests.
First Join, then Subscribe the room. Alert the user in case 
any operation fails.
*/
class roomListener implements RoomRequestListener
{
    public function onSubscribeRoomDone(event:Room):void
    {
        if(event.result == ResultCode.success){
            outputTextField.text += "\nReady To Chat!";
            userinputTextField.text = CHAT_PROMPT;
            userinputTextField.textColor = GREY;    
            chatBtn.backgroundColor = BLACK;
            disconnectbtn.backgroundColor = BLACK;
        }
        else{
            outputTextField.text += "\nSubscribe Room Failed!";
        }
    }
    public function onUnsubscribeRoomDone(event:Room):void
    {
    }
    
    public function onJoinRoomDone(event:Room):void
    {
        if(event.result == ResultCode.success){
            appwarp.subscribeRoom(roomID);
        }
        else{
            outputTextField.text += "Room Join Failed!"
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
    
    public function onUpdatePropertiesDone(event:LiveRoom):void
    {        
    }
    
    public function onLockPropertiesDone(result:int):void
    {
        
    }
    
    public function onUnlockPropertiesDone(result:int):void
    {
        
    }
}

/*
Handle response for chat request. Alert user in case sending failed.
*/
class chatlistner implements ChatRequestListener
{
    public function onSendChatDone(res:int):void
    {
        if(res != ResultCode.success){
            outputTextField.text += "\nonSendChatDone : "+res;
        }
        else{
            chatBtn.backgroundColor = BLACK;
            userinputTextField.text = CHAT_PROMPT;
            userinputTextField.textColor = GREY;
        }
    }
    
    public function onSendPrivateChatDone(res:int):void
    {
        
    }
}

/*
Handle notification events from AppWarp
users joining/leaving and chat message events.
*/
class notifylistener implements NotificationListener
{
    public function onRoomCreated(event:Room):void
    {
    }
    public function onRoomDestroyed(event:Room):void
    {
    }
    public function onUserLeftRoom(event:Room, user:String):void
    {
        outputTextField.text += "\n"+user+" has left";
    }
    public function onUserJoinedRoom(event:Room, user:String):void
    {
        outputTextField.text += "\n"+user+" has joined";	
    }
    public function onUserLeftLobby(event:Lobby, user:String):void
    {
    }
    public function onUserJoinedLobby(event:Lobby, user:String):void
    {
    }        
    public function onChatReceived(event:Chat):void
    {
        outputTextField.text += "\n"+ event.sender+ ": " +event.chat;
    }
    public function onPrivateChatReceived(sender:String, message:String):void
    {
        
    }
    public function onUpdatePeersReceived(update:ByteArray, isUDP:Boolean):void
    {	
    }
    public function onUserChangeRoomProperties(room:Room, user:String,properties:Object, lockTable:Object):void
    {
    }
    
    public function onMoveCompleted(moveEvent:Move):void
    {
        
    }
}

package
{
    import com.shephertz.appwarp.WarpClient;
    import com.shephertz.appwarp.listener.ConnectionRequestListener;
    import com.shephertz.appwarp.types.ConnectionState;
    
    import flash.display.Sprite;
    import flash.events.FocusEvent;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    
    public class AppWarpChatRoomDemo extends Sprite
    {
        
        public function AppWarpChatRoomDemo()
        {            
            PrepareChatUI();
            
            // Initialize and register listeners.
            WarpClient.initialize(apiKey, secretKey);
            appwarp = WarpClient.getInstance();
            appwarp.setConnectionRequestListener(new connectionListener());
            appwarp.setRoomRequestListener(new roomListener());
            appwarp.setChatRequestListener(new chatlistner());
            appwarp.setNotificationListener(new notifylistener());
        }
        
        
        private function sendchat_click(e:MouseEvent):void
        {
            if(appwarp.getConnectionState() == ConnectionState.connected){
                if(userinputTextField.text != CHAT_PROMPT){
                    // Send the chat message
                    appwarp.sendChat(userinputTextField.text);
                    
                    chatBtn.backgroundColor = GREY;
                }
            }
        }
        
        private function connect_click(e:MouseEvent):void
        {
            if(appwarp.getConnectionState() == ConnectionState.disconnected){
                if(userinputTextField.text != NAME_PROMPT){
                    // Connect to AppWarp
                    appwarp.connect(userinputTextField.text); 
                    
                    outputTextField.text += "\nConnecting...";
                    connectbtn.backgroundColor = GREY;                                       
                }
            }
        }
        
        private function disconnect_click(e:MouseEvent):void
        {
            if(appwarp.getConnectionState() == ConnectionState.connected){
                // Disconnect from AppWarp
                appwarp.disconnect();
            }
        }
        
        private function PrepareChatUI():void
        {
            var headerFormat:TextFormat = new TextFormat();
            headerFormat.size = 20;
            headerFormat.bold = true;
            headerFormat.align = TextFormatAlign.LEFT;
            
            var headerLine1:TextField = new TextField();
            headerLine1.defaultTextFormat = headerFormat;
            headerLine1.text = "AppWarp AS3 FLASH";
            addChild(headerLine1);           
            headerLine1.wordWrap = true;
            headerLine1.width = 250;
            headerLine1.height = 30;
            headerLine1.textColor = RED;
            headerLine1.x = 0;
            headerLine1.y = 0;     
            
            
            var headerLine2:TextField = new TextField();
            headerLine2.defaultTextFormat = headerFormat;
            headerLine2.text = "Chat Demo";
            addChild(headerLine2);           
            headerLine2.wordWrap = true;
            headerLine2.width = 200;
            headerLine2.height = 25;
            headerLine2.textColor = BLACK;
            headerLine2.x = 0;
            headerLine2.y = 30;  
            
            
            outputTextField.width = 600;
            outputTextField.height = 900;
            outputTextField.y = 55;
            addChild(outputTextField);
            
            userinputTextField.width = 265;
            userinputTextField.height = 30;
            userinputTextField.x = 220;
            userinputTextField.text = NAME_PROMPT;
            userinputTextField.textColor = GREY;
            userinputTextField.border = true;
            userinputTextField.type = "input";
            userinputTextField.addEventListener(FocusEvent.FOCUS_IN, focusHandler);
            userinputTextField.addEventListener(FocusEvent.FOCUS_OUT, focusHandler);
            addChild(userinputTextField);
            
            connectbtn.y = userinputTextField.height + userinputTextField.y + 5;
            connectbtn.x = 220;
            connectbtn.selectable = false;
            connectbtn.width = 60;
            connectbtn.height = 25;
            connectbtn.background = true;
            connectbtn.backgroundColor = BLACK;
            connectbtn.textColor = WHITE;
            connectbtn.text = "Connect";
            connectbtn.addEventListener(MouseEvent.CLICK,connect_click);
            addChild(connectbtn);            
            
            disconnectbtn.y = userinputTextField.height + userinputTextField.y + 5;
            disconnectbtn.x = 400;
            disconnectbtn.selectable = false;
            disconnectbtn.width = 65;
            disconnectbtn.height = 25;
            disconnectbtn.background = true;
            disconnectbtn.backgroundColor = GREY;
            disconnectbtn.textColor = WHITE;
            disconnectbtn.text = "Disconnect";
            disconnectbtn.addEventListener(MouseEvent.CLICK,disconnect_click);
            addChild(disconnectbtn);
            
            chatBtn.y = userinputTextField.height + userinputTextField.y + 5;
            chatBtn.x = 300;
            chatBtn.selectable = false;
            chatBtn.width = 60;
            chatBtn.height = 25;
            chatBtn.background = true;
            chatBtn.backgroundColor = GREY;
            chatBtn.textColor = WHITE;
            chatBtn.text = "Send Chat";
            chatBtn.addEventListener(MouseEvent.CLICK,sendchat_click);
            addChild(chatBtn);
        }
        
        // Watermark text handling
        private  function focusHandler(event:FocusEvent):void
        {
            switch (event.type) {
                case FocusEvent.FOCUS_IN:
                    if (userinputTextField.text == NAME_PROMPT || userinputTextField.text == CHAT_PROMPT) {
                        userinputTextField.text = "";
                        userinputTextField.textColor = BLACK;
                    }
                    break;
                case FocusEvent.FOCUS_OUT:
                    if (userinputTextField.text == "") {
                        if(appwarp.getConnectionState() == ConnectionState.disconnected){
                            userinputTextField.text = NAME_PROMPT;
                        }
                        else{
                            userinputTextField.text = CHAT_PROMPT;
                        }
                        userinputTextField.textColor = GREY;
                    }
                    break;
            }
        }
    }
}