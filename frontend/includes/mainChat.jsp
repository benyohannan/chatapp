

        <!-- Main Chat Area -->
        <div class="main-chat" id="mainChat">
            <!-- Welcome Screen (shown when no chat is selected) -->
            <div class="welcome-screen" id="welcomeScreen">
                <div class="welcome-logo">
                    <i class="fa-solid fa-comment"></i>
                </div>
                <h1 class="welcome-title">RainChatify</h1>
                <p class="welcome-subtitle">
                    Select one of the chats to start messaging.
                </p>
            </div>

            <!-- Chat Interface (hidden by default) -->
            <div class="chat-interface" id="chatInterface" style="display: none; flex-direction: column; height: 100%;">
                <!-- Chat Header -->
                <div class="chat-header">
                    <div class="chat-user-info">

                        <i class="fas fa-arrow-left back-btn" id="backBtn" title="Back"></i>
                        <div class="chat-user-avatar" id="chatAvatar">JD</div>
                        <div class="chat-user-details">
                            <h3 id="chatName">John Doe</h3>
                            <div class="chat-user-status" id="chatStatus">Online</div>
                        </div>
                    </div>
                    <div class="chat-header-actions">
                        <ul class="communication-action">
                            <li><i class="fas fa-phone" onclick="startAudioCall()" title="Audio call"></i></li>
                            <li><i class="fas fa-video"  onclick="startVideoCall()" title="Video call"></i></li>
                            <li><i class="fas fa-phone-volume" onclick="showCallHistory()" title="Call history"></i></li>
                        </ul>
                        <ul>
                            <li><i class="fas fa-search" id="searchToggleBtn" title="Search in chat"></i></li>
                            <li><i class="fas fa-ellipsis-v" id="chatMenuBtn" title="Menu"></i>
                              <!-- Chat Menu Dropdown -->
                                <div class="dropdown-menu" id="chatDropdownMenu">
                                    <div class="dropdown-item" id="clearChatBtn">
                                        <i class="fas fa-broom"></i>
                                        Clear chat
                                    </div>
                                    <div class="dropdown-divider"></div>
                                    <div class="dropdown-item danger" id="closeChatBtn">
                                        <i class="fas fa-times-circle"></i>
                                        Close chat
                                    </div>
                                </div>
                            </li>
                        </ul>
                    </div>
                </div>

                <!-- Chat Search Container -->
                <div class="chat-search-container" id="chatSearchContainer">
                    <div class="chat-search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" class="chat-search-input" id="chatSearchInput" placeholder="Search messages">
                    </div>
                    <div class="search-navigation">
                        <div class="search-count" id="searchCount">0 of 0</div>
                        <button class="search-nav-btn" id="prevSearchBtn">
                            <i class="fas fa-chevron-up"></i>
                        </button>
                        <button class="search-nav-btn" id="nextSearchBtn">
                            <i class="fas fa-chevron-down"></i>
                        </button>
                    </div>
                    <button class="close-search-btn" id="closeSearchBtn">
                        <i class="fas fa-times"></i>
                    </button>
                </div>

                <!-- Reply Bar -->
                <div class="reply-bar" id="replyBar">
                    <div class="reply-bar-header">
                        <div class="reply-bar-title">Replying to <span id="replyToName"></span></div>
                        <button class="reply-bar-close" id="replyBarClose">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                    <div class="reply-bar-content" id="replyBarContent"></div>
                </div>

                <!-- Chat Messages -->
                <div class="chat-messages" id="chatMessages">
                    <div class="message received" data-message-id="1">
                        <div class="message-bubble">
                            <div class="message-content">Hey! How are you doing today? 😊</div>
                            <div class="message-time">2:30 PM</div>
                         <div class="message-actions">
                            <div class="message-actions-btn">
                                <i class="fas fa-chevron-down"></i>
                            </div>
                         </div>
                        </div>
                       
                    </div>

                    <div class="message sent" data-message-id="2">
                        <div class="message-actions">
                            <div class="message-actions-btn">
                                <i class="fas fa-chevron-down"></i>
                            </div>
                        </div>
                        <div class="message-bubble">
                            <div class="message-content">I'm doing great! Just working on some new projects. How about you?</div>
                            <div class="message-time">
                                2:32 PM
                                <i class="fas fa-check-double message-status"></i>
                            </div>
                        </div>
                    </div>

                    <div class="message received" data-message-id="3">
                        <div class="message-bubble">
                            <div class="message-content">That sounds awesome! I'd love to hear more about your projects sometime. 🚀</div>
                            <div class="message-time">2:33 PM</div>
                            <div class="message-reactions">
                                <div class="reaction">
                                    <span class="reaction-emoji">👍</span>
                                    <span class="reaction-count">1</span>
                                </div>
                            </div>
                        </div>
                        <div class="message-actions">
                            <div class="message-actions-btn">
                                <i class="fas fa-chevron-down"></i>
                            </div>
                        </div>
                    </div>

                    <div class="message sent" data-message-id="4">
                        <div class="message-actions">
                            <div class="message-actions-btn">
                                <i class="fas fa-chevron-down"></i>
                            </div>
                        </div>
                        <div class="message-bubble">
                            <div class="message-content">Let's catch up over coffee this weekend? ☕</div>
                            <div class="message-time">
                                2:35 PM
                                <i class="fas fa-check-double message-status"></i>
                            </div>
                        </div>
                    </div>

                    <div class="message received" data-message-id="5">
                        <div class="message-bubble">
                            <div class="message-content">Perfect! Saturday works for me. Looking forward to it! 🎉</div>
                            <div class="message-time">2:36 PM</div>
                        </div>
                        <div class="message-actions">
                            <div class="message-actions-btn">
                                <i class="fas fa-chevron-down"></i>
                            </div>
                        </div>
                    </div>

                    <!-- Typing Indicator -->
                    <div class="typing-indicator" id="typingIndicator" style="display: none;">
                        <span class="typing-text">typing</span>
                        <div class="typing-dots">
                            <div class="typing-dot"></div>
                            <div class="typing-dot"></div>
                            <div class="typing-dot"></div>
                        </div>
                    </div>
                </div>

                <!-- Chat Input -->
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
    </div>
<script>
    document.addEventListener('DOMContentLoaded', () => {
        function openChat(userName) {
    const isMobile = window.innerWidth < 768;

    const chatNameElement = document.getElementById('chatName');
    const chatMessagesElement = document.getElementById('chatMessages');
    const sidebarElement = document.getElementById('sidebar');
    const mainChatElement = document.getElementById('mainChat');

    const welcomeScreen = document.getElementById('welcomeScreen');
    const chatInterface = document.getElementById('chatInterface');

    // ✅ SHOW CHAT UI
    welcomeScreen.style.display = "none";
    chatInterface.style.display = "flex";

    // ✅ Update chat name
    chatNameElement.innerText = userName;

    // ✅ Load messages (dummy for now)
    chatMessagesElement.innerHTML = `
        <div class="message received">
            <div class="message-bubble">
                <div class="message-content">Hello, this is ${userName}'s chat!</div>
                <div class="message-time">2:30 PM</div>
            </div>
        </div>
        <div class="message sent">
            <div class="message-bubble">
                <div class="message-content">Hi ${userName}, how can I help you?</div>
                <div class="message-time">2:32 PM</div>
            </div>
        </div>
    `;

    // ✅ Mobile view handling
    if (isMobile) {
    sidebarElement.classList.add('hide');
    mainChatElement.classList.add('show');
}
}
document.getElementById("backBtn").addEventListener("click", () => {
    const sidebar = document.getElementById('sidebar');
    const mainChat = document.getElementById('mainChat');

    // ✅ reverse animation
    sidebar.classList.remove("hide");
    mainChat.classList.remove("show");
});

        // Expose functions globally for testing
        window.openChat = openChat;
        window.showSidebar = showSidebar;
    });
</script>