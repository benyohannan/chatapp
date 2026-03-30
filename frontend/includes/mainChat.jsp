<!--<div class="row">
    < Chat List Sidebar -->
    <!--<div class="col-12 col-md-4" id="sidebar">
        <div class="chat-list">
            <div class="chat-item" onclick="openChat('John Doe')">
                <div class="chat-avatar">JD</div>
                <div class="chat-details">
                    <h5>John Doe</h5>
                    <p>Hey! How are you doing?</p>
                </div>
            </div>
             Add more chat items here 
        </div>
    </div>-->

    <!-- Main Chat Window -->
    <div class="col-12 col-md-8 d-none d-md-block" id="mainChat">
        <div class="chat-header" id="chatHeader">
            <div class="chat-user-info">
                <div class="chat-user-avatar" id="chatAvatar">JD</div>
                <div class="chat-user-details">
                    <h3 id="chatName">John Doe</h3>
                    <div class="chat-user-status" id="chatStatus">Online</div>
                </div>
            </div>

            <div class="chat-controls">
                <button class="btn btn-sm btn-outline-secondary" onclick="showSidebar()">
                    <i class="fas fa-chevron-left"></i>
                    <span>Chat List</span>
                </button>
            </div>
        </div>

        <div class="chat-messages" id="chatMessages" style="flex:1; overflow-y:auto;height: 50vh;">
            <!-- Messages will be dynamically loaded here -->
        </div>

        <div class="chat-input-container">
            <div class="input-actions">
                <i class="fas fa-smile emoji-btn" title="Emoji"></i>
                <label for="fileInput" style="cursor: pointer;">
                    <i class="fas fa-paperclip" title="Attach File"></i>
                </label>
                <input type="file" id="fileInput" class="file-input" multiple accept="*/*">
            </div>
            <div class="message-input-wrapper">
                <input type="text" class="message-input" placeholder="Type a message" id="messageInput">
            </div>
            <button class="send-btn" id="sendBtn">
                <i class="fas fa-paper-plane"></i>
            </button>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', () => {
        function openChat(userName) {
            const isMobile = window.innerWidth < 768; // Bootstrap's breakpoint for mobile
            const chatNameElement = document.getElementById('chatName');
            const chatMessagesElement = document.getElementById('chatMessages');
            const sidebarElement = document.getElementById('sidebar');
            const mainChatElement = document.getElementById('mainChat');

            chatNameElement.innerText = userName;
            chatMessagesElement.innerHTML = `
                <div class="message received">
                    <div class="message-bubble">
                        <div class="message-content">Hey! How are you doing today? 😊</div>
                        <div class="message-time">2:30 PM</div>
                    </div>
                </div>
                <div class="message sent">
                    <div class="message-bubble">
                        <div class="message-content">I'm doing great! Just working on some new projects. How about you?</div>
                        <div class="message-time">2:32 PM</div>
                    </div>
                </div>
            `;

            if (isMobile) {
                sidebarElement.classList.add('d-none');
                mainChatElement.classList.remove('d-none');
            }
        }

        function showSidebar() {
            const sidebarElement = document.getElementById('sidebar');
            const mainChatElement = document.getElementById('mainChat');

            sidebarElement.classList.remove('d-none');
            mainChatElement.classList.add('d-none');
        }

        // Expose functions globally for testing
        window.openChat = openChat;
        window.showSidebar = showSidebar;
    });
</script>