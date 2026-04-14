
        <!-- Main Chat Area -->
        <div class="main-chat" id="mainChat">
            <!-- Welcome Screen (shown when no chat is selected) -->
            <div class="welcome-screen" id="welcomeScreen">
                <div class="welcome-logo">
                    <i class="fa-solid fa-comment"></i>
                </div>
               <h1 class="welcome-title">ZyncChat</h1>
                <p class="tagline">Stay in Sync !</p>
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
                        <i class="fas fa-smile emoji-btn" id="pmEmojiBtn" title="Emoji"></i>
                        <label for="fileInput" style="cursor: pointer;">
                            <i class="fas fa-paperclip" title="Attach File"></i>
                        </label>
                        <input type="file" id="fileInput" class="file-input" multiple accept="*/*">
                    </div>
                    <div class="message-input-wrapper">
                        <input type="text" class="message-input" placeholder="Type a message" id="messageInput">
                    </div>
                    <div class="emoji-picker-panel" id="pmEmojiPicker" style="display:none;"></div>
                    <button class="send-btn" id="sendBtn" onclick="sendMessage()">
                        <i class="fas fa-paper-plane"></i>
                    </button>
                </div>
            </div>
        </div>
    </div>
